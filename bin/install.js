#!/usr/bin/env node
// Signal + Plain skill installer — single source of truth, OS-agnostic.
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
const SKILLS = ["signal", "plain"];

// [agent, userScopeDir, projectScopeDir]
const TARGETS = [
  ["opencode", "~/.config/opencode/skills", ".opencode/skills"],
  ["claude-code", "~/.claude/skills", ".claude/skills"],
  ["codex", "~/.codex/skills", ".codex/skills"],
  ["cursor", "~/.cursor/skills", ".cursor/skills"],
  ["copilot", "~/.agents/skills", ".agents/skills"],
  ["antigravity", "~/.agents/skills", ".agents/skills"],
];

function parseArgs(argv) {
  const a = { mode: "global", only: [], force: false, dry: false };
  for (let i = 0; i < argv.length; i++) {
    switch (argv[i]) {
      case "--local": a.mode = "local"; break;
      case "--force": a.force = true; break;
      case "--dry-run": a.dry = true; break;
      case "--targets":
        a.only = (argv[++i] || "").split(",").map((s) => s.trim()).filter(Boolean);
        break;
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
  console.log(`signal install (skills: ${SKILLS.join(" ")}, scope: ${a.mode}${a.only.length ? `, targets: ${a.only.join(",")}` : ""})`);
  for (const [name, userDir, projDir] of TARGETS) {
    if (a.only.length && !a.only.includes(name)) continue;
    const dir = a.mode === "local" ? path.join(REPO, projDir) : expand(userDir);
    if (a.mode !== "local" && !fs.existsSync(dir)) {
      console.log(`  ${name.padEnd(12)} skill     agent-miss ${dir}`);
      continue;
    }
    fs.mkdirSync(dir, { recursive: true });
    for (const s of SKILLS) {
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
        // Windows: junctions avoid admin rights; elsewhere a plain dir symlink.
        fs.symlinkSync(src, dst, process.platform === "win32" ? "junction" : "dir");
      }
      console.log(`  ${name.padEnd(12)} ${s.padEnd(8)} ${st.padEnd(10)} ${dst}`);
    }
  }
  console.log("Done. Restart your agent to pick up the skills.");
}

install();
