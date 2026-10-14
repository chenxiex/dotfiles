// Reapply the local XDG adaptation before installing an upstream runtime.
// Exact anchors deliberately fail closed when an upstream layout changes.
const fs = require('node:fs');
const path = require('node:path');
const scriptsDir = path.resolve(process.argv[2] || path.join(__dirname, '..', 'scripts'));

function replaceOnce(source, before, after) {
    if (source.includes(after)) return source;
    if (source.split(before).length !== 2) {
        throw new Error(`Unsupported upstream runtime; XDG anchor missing or ambiguous: ${before.slice(0, 90)}`);
    }
    return source.replace(before, after);
}

function patchRuntime(source) {
    const marker = 'function quarkXdgRoot(';
    if (source.includes(marker)) return patchRuntimeExtras(source);
    const start = source.indexOf('function Us(s){');
    const end = source.indexOf('function Rh(s){', start);
    if (start < 0 || end < 0) throw new Error('Unsupported upstream path module');
    const original = source.slice(start, end);
    const helper = `function quarkXdgRoot(kind){const p=require("node:path"),o=require("node:os"),defaults={CONFIG:[".config"],STATE:[".local","state"],CACHE:[".cache"]},value=process.env["XDG_"+kind+"_HOME"];return p.join(value&&p.isAbsolute(value)?value:p.join(o.homedir(),...defaults[kind]),"quarkclouddrive")}function quarkXdgAgent(s){return s?String(s).replace(/[^a-zA-Z0-9._-]/g,"_"):"common"}`;
    let paths = original;
    paths = replaceOnce(paths, 'function Us(s){return s?ne.join(Ze,s,_r):ne.join(Ze,_r)}', 'function Us(s){return ne.join(quarkXdgRoot("CONFIG"),quarkXdgAgent(s),_r)}');
    // Legacy helpers remain read-only sources for automatic auth migration.
    paths = paths.replaceAll('ne.join(Ze,Be,', 'ne.join(quarkXdgRoot("STATE"),Be,');
    paths = paths.replaceAll('ne.join(At(),Oe,Be,', 'ne.join(quarkXdgRoot("STATE"),Be,');
    paths = replaceOnce(paths, 'function Na(){X(Ze)}', 'function Na(){X(quarkXdgRoot("STATE"))}');
    paths = replaceOnce(paths, 'function Ln(s,e){return Ms(Ze)?ne.join(Ze,s,e):ne.join(At(),Oe,e)}', 'function Ln(s,e){return ne.join(quarkXdgRoot(e==="search"||e==="unauthorize"?"CACHE":"STATE"),quarkXdgAgent(s),e)}');
    source = source.slice(0, start) + helper + paths + source.slice(end);
    source = replaceOnce(source,
        'resolveConfigPath(){let e=he(),t=Us(e),r=Le.dirname(Le.dirname(t));return this.isDirWritable(r)?t:Ls(e)}',
        'resolveConfigPath(){return Us(he())}');
    source = replaceOnce(source,
        'let r=he(),n=Ls(r);if(Le.resolve(e)===Le.resolve(n))',
        'let r=he(),old=Le.join(Ze,r,_r),oldConfig=this.readConfigFromPath(old);if(oldConfig&&this.hasValidAccount(oldConfig))return this.migrateLegacyConfig(e,old,oldConfig);let n=Ls(r),cwdConfig=this.readConfigFromPath(n);if(cwdConfig&&this.hasValidAccount(cwdConfig))return this.migrateLegacyConfig(e,n,cwdConfig);if(Le.resolve(e)!==Le.resolve(n))');
    // Restrict diagnostic probes and their history to the cache tree.
    source = replaceOnce(source,
        'Ve.default.join(s.cwd(),wo,e)',
        'Ve.default.join(quarkXdgRoot("CACHE"),e,"probe","cwd")');
    source = replaceOnce(source,
        'Ve.default.join(s.homedir(),wo,e)',
        'Ve.default.join(quarkXdgRoot("CACHE"),e,"probe","home")');
    source = replaceOnce(source,
        'Ve.default.join(s.tmpdir(),wo,e)',
        'Ve.default.join(quarkXdgRoot("CACHE"),e,"probe","temp")');
    source = replaceOnce(source,
        'Ve.default.join(this.options.tmpdir(),wo,this.safeSegment(e,"unknown-agent"),"path-history.jsonl")',
        'Ve.default.join(quarkXdgRoot("CACHE"),this.safeSegment(e,"unknown-agent"),"probe","path-history.jsonl")');
    source = replaceOnce(source,
        'va.default.mkdirSync(s,{recursive:!0})',
        'va.default.mkdirSync(s,{recursive:!0,mode:448})');
    source = replaceOnce(source,
        'va.default.mkdirSync(s)',
        'va.default.mkdirSync(s,{mode:448})');
    source = replaceOnce(source,
        'ue.openSync(n,"w")',
        'ue.openSync(n,"w",384)');
    const updaterStart = source.indexOf('resolveInstallDir(){');
    const updaterEnd = source.indexOf('fetchSkillConfig(){', updaterStart);
    if (updaterStart < 0 || updaterEnd < 0) throw new Error('Unsupported upstream updater');
    source = source.slice(0, updaterStart) + 'resolveInstallDir(){this.installDir=ve.dirname(__dirname);return this.installDir}' + source.slice(updaterEnd);
    return patchRuntimeExtras(source);
}

function patchRuntimeExtras(source) {
    source = replaceOnce(source,
        'installFiles(e){let t=ve.join(this.installDir,"scripts"),r=[],n=[];',
        'installFiles(e){require("node:child_process").execFileSync(process.execPath,[ve.join(this.installDir,"xdg","apply.cjs"),e],{stdio:"pipe"});let t=ve.join(this.installDir,"scripts"),r=[],n=[];');
    source = replaceOnce(source,
        'hasPersistedConfig(){let e=this.resolveConfigPath();if(ue.existsSync(e))return!0;let t=he(),r=Ls(t);return Le.resolve(e)===Le.resolve(r)&&ue.existsSync(ka())?!0:ue.existsSync(Da(t))}',
        'hasPersistedConfig(){let e=this.resolveConfigPath();if(ue.existsSync(e))return!0;let t=he();return[Le.join(Ze,t,_r),Ls(t),ka(),Da(t)].some(p=>ue.existsSync(p))}');
    source = replaceOnce(source,
        'if(t&&this.hasValidAccount(t))return t;let r=he()',
        'if(t)return t;let r=he()');
    source = replaceOnce(source,
        'removeAgentConfigDir(){let e=Le.dirname(this.resolveConfigPath()),t={ok:!0};try{ue.rmSync(e,{recursive:!0,force:!0})}',
        'removeAgentConfigDir(){let e=Le.dirname(this.resolveConfigPath()),t={ok:!0};try{ue.rmSync(e,{recursive:!0,force:!0});t=this.writeConfigToPath(this.resolveConfigPath(),{...bu},!0)}');
    return source;
}

function patchInstaller(source) {
    source = replaceOnce(source, '\nTMP_DIR="$(dirname "$SKILL_DIR")/temp"', `
# quark-xdg: validate/reapply the adaptation before any CLI invocation.
if [ -f "$SKILL_DIR/scripts/quark-drive.cjs" ]; then
    node "$SKILL_DIR/xdg/apply.cjs" "$SKILL_DIR/scripts"
fi
TMP_DIR="$(dirname "$SKILL_DIR")/temp"`);
    source = replaceOnce(source, '  mkdir -p "$SKILL_DIR"\n\n  local scripts_dest=', `  # quark-xdg: patch staging files before replacing the installed scripts.
  if ! node "$SKILL_DIR/xdg/apply.cjs" "$scripts_src"; then
    error "上游版本不兼容本地 XDG 适配，保留当前安装"
    return 1
  fi
  mkdir -p "$SKILL_DIR"

  local scripts_dest=`);
    source = replaceOnce(source, '    cp -f "$skill_md_src" "$SKILL_DIR/SKILL.md"', `    cp -f "$skill_md_src" "$SKILL_DIR/SKILL.md"
    printf '\\n## 本地 XDG 存储适配\\n\\n使用前读取 [xdg/storage.md](xdg/storage.md)。本地适配由安装脚本在覆盖运行时前重新应用；不兼容的上游版本会停止更新。\\n' >> "$SKILL_DIR/SKILL.md"`);
    return source;
}

// Prepare all changes before committing any of them.
const changes = [];
for (const [name, patch] of [['quark-drive.cjs', patchRuntime], ['install.sh', patchInstaller]]) {
    const file = path.join(scriptsDir, name);
    const before = fs.readFileSync(file, 'utf8');
    const after = patch(before);
    if (before !== after) changes.push([file, after]);
}
for (const [file, after] of changes) {
    const temporary = `${file}.xdg-${process.pid}.tmp`;
    fs.writeFileSync(temporary, after, { mode: fs.statSync(file).mode });
    fs.renameSync(temporary, file);
}
