const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const vm = require('node:vm');
const { execFileSync } = require('node:child_process');
const root = fs.mkdtempSync(path.join(os.tmpdir(), 'quark-xdg-test-'));
const scripts = path.join(__dirname, '..', 'scripts');
const runtime = fs.readFileSync(path.join(scripts, 'quark-drive.cjs'), 'utf8');
const start = runtime.indexOf('function quarkXdgRoot(');
const end = runtime.indexOf('function Rh(s){', start);
assert(start >= 0 && end > start);
const block = runtime.slice(start, end);

function context(env) {
    const sandbox = {
        require(name) {
            return name === 'node:os' ? { homedir: () => path.join(root, 'home') } : require(name);
        },
        process: { env, cwd: () => path.join(root, 'work') },
        ne: path, lu: { homedir: () => path.join(root, 'home') }, St: fs,
        Ze: path.join(root, 'skill'), _r: 'config.json', Oe: '.quarkclouddrive',
        Be: 'logs', xn: 'curl', Un: 'common', Pa: 'probe', uu: 'probe.log', cu: 'cli',
        he: () => 'codex',
        X: dir => fs.mkdirSync(dir, { recursive: true, mode: 0o700 }),
    };
    vm.createContext(sandbox);
    vm.runInContext(block, sandbox);
    return sandbox;
}

try {
    for (const env of [{}, { XDG_CONFIG_HOME: '', XDG_STATE_HOME: 'relative', XDG_CACHE_HOME: './cache' }]) {
        const c = context(env);
        assert.equal(c.Us('codex'), path.join(root, 'home/.config/quarkclouddrive/codex/config.json'));
        assert.equal(c.Ln('codex', 'upload'), path.join(root, 'home/.local/state/quarkclouddrive/codex/upload'));
        assert.equal(c.Ln('codex', 'search'), path.join(root, 'home/.cache/quarkclouddrive/codex/search'));
    }
    const env = {
        XDG_CONFIG_HOME: path.join(root, 'config with spaces'),
        XDG_STATE_HOME: path.join(root, 'state'),
        XDG_CACHE_HOME: path.join(root, 'cache'),
    };
    const c = context(env);
    assert.equal(c.Us('codex'), path.join(env.XDG_CONFIG_HOME, 'quarkclouddrive/codex/config.json'));
    for (const category of ['upload', 'download', 'storage', 'rename']) {
        assert.equal(c.Ln('codex', category), path.join(env.XDG_STATE_HOME, 'quarkclouddrive/codex', category));
    }
    for (const category of ['search', 'unauthorize']) {
        assert.equal(c.Ln('codex', category), path.join(env.XDG_CACHE_HOME, 'quarkclouddrive/codex', category));
    }
    for (const getLog of [c.hh, c.JE, c.ZE]) {
        assert(getLog().startsWith(path.join(env.XDG_STATE_HOME, 'quarkclouddrive/logs') + path.sep));
    }
    assert.equal(fs.statSync(path.join(env.XDG_STATE_HOME, 'quarkclouddrive/logs')).mode & 0o777, 0o700);

    // Verify migration precedence without reading or moving real credentials.
    Object.assign(c, { Le: path, ue: fs, M: { addAttributes() {} }, y: { addAttributes() {} }, bu: { accounts: [] } });
    const loadStart = runtime.indexOf('loadPersistedConfig(){');
    const loadEnd = runtime.indexOf('}migrateLegacyConfig(', loadStart) + 1;
    const auth = vm.runInContext('({' + runtime.slice(loadStart, loadEnd) + '})', c);
    const configPath = c.Us('codex');
    const legacyPaths = [path.join(c.Ze, 'codex/config.json'), c.Ls('codex'), c.ka(), c.Da('codex')];
    const configs = new Map();
    auth.resolveConfigPath = () => configPath;
    auth.readConfigFromPath = file => configs.get(file);
    auth.hasValidAccount = value => !!value.accessToken;
    auth.migrateLegacyConfig = (destination, source, value) => ({ destination, source, value });
    for (const legacy of legacyPaths) {
        configs.clear();
        configs.set(legacy, { accessToken: 'fixture-only' });
        assert.equal(auth.loadPersistedConfig().source, legacy);
    }
    configs.set(configPath, { accounts: [] });
    assert.deepEqual(auth.loadPersistedConfig(), { accounts: [] });

    // Exercise the actual config writer and logout cleanup in the fixture.
    const writeStart = runtime.indexOf('writeConfigToPath(e,t,r=!1){');
    const writeEnd = runtime.indexOf('}getWritePathType(', writeStart) + 1;
    const removeStart = runtime.indexOf('removeAgentConfigDir(){');
    const removeEnd = runtime.indexOf('}updatePersistedAccessToken(', removeStart) + 1;
    const writer = vm.runInContext('({' + runtime.slice(writeStart, writeEnd) + ',' + runtime.slice(removeStart, removeEnd) + '})', c);
    writer.resolveConfigPath = () => configPath;
    writer.getWritePathType = () => 'xdg';
    writer.renameWithReplace = (from, to) => fs.renameSync(from, to);
    assert(writer.writeConfigToPath(configPath, { accessToken: 'fixture-only' }).ok);
    assert.equal(fs.statSync(configPath).mode & 0o777, 0o600);
    assert(writer.removeAgentConfigDir().ok);
    assert.deepEqual(JSON.parse(fs.readFileSync(configPath, 'utf8')), { accounts: [] });

    const probesStart = runtime.indexOf('Ab=[') + 3;
    const probesEnd = runtime.indexOf('],mp=class', probesStart) + 1;
    c.Ve = { default: path };
    const probes = vm.runInContext(runtime.slice(probesStart, probesEnd), c);
    for (const probe of probes) {
        assert(probe.resolve({}, 'codex').startsWith(path.join(env.XDG_CACHE_HOME, 'quarkclouddrive/codex/probe') + path.sep));
    }

    // Exercise the actual bundled CLI in a fixture installation, without real account files.
    const fixtureScripts = path.join(root, 'fixture', 'scripts');
    fs.mkdirSync(fixtureScripts, { recursive: true });
    fs.copyFileSync(path.join(scripts, 'quark-drive.cjs'), path.join(fixtureScripts, 'quark-drive.cjs'));
    fs.copyFileSync(path.join(scripts, 'install.sh'), path.join(fixtureScripts, 'install.sh'));
    const childEnv = { ...process.env, ...env, CODEX_ENV: '1' };
    for (const option of ['--version', '--help']) {
        const output = execFileSync(process.execPath, [path.join(fixtureScripts, 'quark-drive.cjs'), option], {
            cwd: root, env: childEnv, timeout: 20000, encoding: 'utf8',
        });
        assert(output.trim().length > 0);
    }
    assert(!fs.existsSync(path.join(root, '.quarkclouddrive')));

    // Reapplication is idempotent. Incompatible staging files must not be rewritten.
    const before = fs.readFileSync(path.join(fixtureScripts, 'quark-drive.cjs'), 'utf8');
    execFileSync(process.execPath, [path.join(__dirname, 'apply.cjs'), fixtureScripts]);
    assert.equal(fs.readFileSync(path.join(fixtureScripts, 'quark-drive.cjs'), 'utf8'), before);
    fs.writeFileSync(path.join(fixtureScripts, 'quark-drive.cjs'), 'incompatible upstream');
    assert.throws(() => execFileSync(process.execPath, [path.join(__dirname, 'apply.cjs'), fixtureScripts], { stdio: 'pipe' }));
    assert.equal(fs.readFileSync(path.join(fixtureScripts, 'quark-drive.cjs'), 'utf8'), 'incompatible upstream');
    console.log('XDG defaults, overrides, categories, permissions, CLI startup and update guard passed.');
} finally {
    fs.rmSync(root, { recursive: true, force: true });
}
