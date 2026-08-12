#!/usr/bin/env node
// Signal + Clarity skill installer — single source of truth, OS-agnostic.
// Works on macOS, Linux, Windows (junction symlinks) via Node's os/path.
//
//   node bin/install.js [--local] [--targets opencode,claude-code,codex,cursor,copilot,antigravity]
//                       [--force] [--dry-run]
//
// User scope: absent agent dirs reported (agent-miss), never created.
// Project scope (--local): <repo>/.<agent>/skills, created. Symlinks: edits
// to this repo apply live.
"use strict";

const os = require("os");
const path = require("path");
const fs = require("fs");

const HERE = __dirname;
const REPO = path.resolve(HERE, "..");
const SKILLS = ["signal", "clarity"];

// [agent, userScopeSkillDir, projectScopeSkillDir, userScopeCommandDir]
const TARGETS = [
  ["opencode", "~/.config/opencode/skills", ".opencode/skills", "~/.config/opencode/commands"],
  ["claude-code", "~/.claude/skills", ".claude/skills", "~/.claude/commands"],
  ["codex", "~/.codex/skills", ".codex/skills", null],
  ["cursor", "~/.cursor/skills", ".cursor/skills", null],
  ["copilot", "~/.agents/skills", ".agents/skills", null],
  ["antigravity", "~/.agents/skills", ".agents/skills", null],
];

// Slash commands for agents that support them: the skill's activation text as
// a /command (opencode, claude-code). Others get none (reported).
const COMMAND_CONTENT = {
  signal:
    `---
description: Activate the Signal skill — reduce uncertainty, gather evidence, verify.
---

Use the Signal skill before working: reduce uncertainty before acting (read the code, check assumptions); gather decision-changing evidence (run tests, probe edge inputs); act within bounds; verify your change before claiming done; recover when something fails. Never claim completion without verifying it yourself.`,
  clarity:
    `---
description: Activate the Clarity skill — compact technical English.
---

Use the Clarity skill when communicating: lead with the answer, decision, or next action; remove filler, repetition, and needless jargon; preserve negation, conditions, uncertainty, and safety detail. Compact, natural English.`,
};

function parseArgs(argv) {
  const a = { mode: "global", only: [], skills: SKILLS, force: false, dry: false };
  for (let i = 0; i < argv.length; i++) {
    switch (argv[i]) {
      case "--local": a.mode = "local"; break;
      case "--force": a.force = true; break;
      case "--dry-run": a.dry = true; break;
      case "--targets":
        a.only = (argv[++i] || "").split(",").map((s) => s.trim()).filter(Boolean);
        break;
      case "--skills": {
        const pick = (argv[++i] || "").trim();
        if (pick === "both" || pick === "all" || pick === "signal+clarity") a.skills = SKILLS;
        else if (SKILLS.includes(pick)) a.skills = [pick];
        else { console.error(`unknown skill: ${pick} (use one of: ${SKILLS.join(", ")}, both)`); process.exit(2); }
        break;
      }
      default: console.error(`unknown option: ${argv[i]}`); process.exit(2);
    }
  }
  return a;
}

function expand(p) {
  if (p === "~" || p.startsWith("~/")) return path.join(os.homedir(), p.slice(1));
  return p;
}

function linkKind(dst) {
  try {
    if (fs.lstatSync(dst).isSymbolicLink()) return "symlink";
  } catch {}
  if (fs.existsSync(dst)) return "file";
  return "none";
}

function install() {
  const a = parseArgs(process.argv.slice(2));
  console.log(`signal install (skills: ${a.skills.join(" ")}, scope: ${a.mode}${a.only.length ? `, targets: ${a.only.join(",")}` : ""})`);
  for (const [name, userDir, projDir, cmdDir] of TARGETS) {
    if (a.only.length && !a.only.includes(name)) continue;
    const dir = a.mode === "local" ? path.join(REPO, projDir) : expand(userDir);
    if (a.mode !== "local" && !fs.existsSync(dir)) {
      console.log(`  ${name.padEnd(12)} skill     agent-miss ${dir}`);
      continue;
    }
    fs.mkdirSync(dir, { recursive: true });
    for (const s of a.skills) {
      const dst = path.join(dir, s);
      const src = path.join(REPO, s);
      let st;
      if (linkKind(dst) === "symlink" && fs.readlinkSync(dst) === src) {
        st = "up-to-date";
      } else if (linkKind(dst) === "file") {
        if (!a.force) {
          console.log(`  ${name.padEnd(12)} ${s.padEnd(8)} conflict ${dst} (use --force)`);
          continue;
        }
        st = "updated";
      } else {
        st = a.dry ? "installed (dry-run)" : "installed";
      }
      if (!a.dry && st !== "up-to-date") {
        if (st === "updated") fs.rmSync(dst, { recursive: true, force: true });
        fs.symlinkSync(src, dst, process.platform === "win32" ? "junction" : "dir");
      }
      console.log(`  ${name.padEnd(12)} ${s.padEnd(8)} ${st.padEnd(10)} ${dst}`);
    }
    // slash commands where supported
    if (cmdDir) {
      const cdir = a.mode === "local" ? path.join(REPO, path.basename(projDir, "skills") + "commands") : expand(cmdDir);
      if (!a.dry) fs.mkdirSync(cdir, { recursive: true });
      for (const s of a.skills) {
        const cdst = path.join(cdir, `${s}.md`);
        if (fs.existsSync(cdst) && !a.force) {
          console.log(`  ${name.padEnd(12)} ${s.padEnd(8)} conflict ${cdst} (use --force)`);
          continue;
        }
        if (!a.dry) fs.writeFileSync(cdst, COMMAND_CONTENT[s]);
        console.log(`  ${name.padEnd(12)} ${s.padEnd(8)} ${a.dry ? "command (dry-run)" : "command"} ${cdst}`);
      }
    }
  }
  console.log("Done. Restart your agent to pick up the skills.");
}

install();
