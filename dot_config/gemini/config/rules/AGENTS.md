## Subagent Delegation

- Proactively delegate when a task contains an independent, bounded side track whose parallel or isolated execution materially improves speed, coverage, or confidence.
- Keep cheap, trivial, tightly coupled, or critical-path work in the main agent; do not delegate solely to create parallelism.
- Give each subagent the relevant context, a concrete objective, an expected output, and clear ownership. Do not assign overlapping write scopes or duplicate work.
- Continue useful, non-conflicting main work while subagents run, and synchronize before decisions or edits that depend on their results.
- Treat subagent output as evidence to verify, then synthesize the material findings in the main response.
- Use flash model as subagent by default. Only use inherit model when the task is very difficult or flash model failed.