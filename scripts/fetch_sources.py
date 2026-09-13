#!/usr/bin/env python3
"""
fetch_sources.py
Cross-platform repository downloader for minimal_ros2.
Reads a VCS-style .repos YAML file and clones git repositories without requiring vcstool.
Works identically on macOS, Linux, and Windows.
"""

import argparse
import os
import re
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

def parse_repos_yaml(repos_file: Path):
    """
    Parse a VCS .repos YAML file.
    Tries pyyaml first, then falls back to a regex parser for standard .repos format.
    """
    text = repos_file.read_text(encoding="utf-8")
    try:
        import yaml
        data = yaml.safe_load(text)
        repos = []
        if isinstance(data, dict) and "repositories" in data:
            for rel_path, info in data["repositories"].items():
                repos.append({
                    "path": rel_path,
                    "type": info.get("type", "git"),
                    "url": info.get("url", ""),
                    "version": str(info.get("version", "main"))
                })
        return repos
    except ImportError:
        pass

    # Fallback line-by-line regex parser for standard .repos format
    repos = []
    current_repo = None
    in_repos_section = False

    for line in text.splitlines():
        trimmed = line.strip()
        if not trimmed or trimmed.startswith("#"):
            continue
        if trimmed.startswith("repositories:"):
            in_repos_section = True
            continue
        if not in_repos_section:
            continue

        # Match repo name header (e.g. "  ament/ament_cmake:")
        m_head = re.match(r"^\s{2}([a-zA-Z0-9_/-]+):\s*$", line)
        if m_head:
            if current_repo and current_repo.get("url"):
                repos.append(current_repo)
            current_repo = {"path": m_head.group(1), "type": "git", "url": "", "version": "main"}
            continue

        if current_repo:
            m_type = re.match(r"^\s{4}type:\s*(\S+)", line)
            if m_type:
                current_repo["type"] = m_type.group(1)
            m_url = re.match(r"^\s{4}url:\s*(\S+)", line)
            if m_url:
                current_repo["url"] = m_url.group(1)
            m_ver = re.match(r"^\s{4}version:\s*(\S+)", line)
            if m_ver:
                current_repo["version"] = m_ver.group(1)

    if current_repo and current_repo.get("url"):
        repos.append(current_repo)

    return repos

def clone_or_update_repo(repo: dict, src_dir: Path, shallow: bool, update: bool):
    target = src_dir / repo["path"]
    name = repo["path"]
    url = repo["url"]
    version = repo["version"]

    if (target / ".git").exists():
        if update:
            print(f"[FETCH] Updating {name} ({version})...")
            try:
                subprocess.run(["git", "-C", str(target), "fetch", "origin"], check=True, capture_output=True)
                subprocess.run(["git", "-C", str(target), "checkout", version], check=True, capture_output=True)
                return True, f"Updated {name}"
            except subprocess.CalledProcessError as e:
                return False, f"Failed to update {name}: {e}"
        else:
            return True, f"Skipping (already exists): {name}"

    print(f"[CLONE] Cloning {name} [{version}] from {url}...")
    target.parent.mkdir(parents=True, exist_ok=True)
    cmd = ["git", "clone"]
    if shallow:
        cmd += ["--depth", "1"]
    cmd += ["-b", version, url, str(target)]

    try:
        subprocess.run(cmd, check=True, capture_output=True, text=True)
        return True, f"Cloned {name}"
    except subprocess.CalledProcessError as e:
        # If branch/tag failed with shallow clone, try full clone then checkout
        print(f"[WARN] Shallow clone failed for {name}, trying full clone...")
        try:
            subprocess.run(["git", "clone", url, str(target)], check=True, capture_output=True, text=True)
            subprocess.run(["git", "-C", str(target), "checkout", version], check=True, capture_output=True, text=True)
            return True, f"Cloned {name}"
        except subprocess.CalledProcessError as e2:
            return False, f"Failed to clone {name}: {e2.stderr}"

def main():
    parser = argparse.ArgumentParser(description="Cross-platform repository fetcher for minimal_ros2")
    parser.add_argument("--repos-file", type=Path, default=Path("repos/minimal_ros2.repos"),
                        help="Path to .repos YAML file")
    parser.add_argument("--src-dir", type=Path, default=Path("src"),
                        help="Target directory where sources will be downloaded")
    parser.add_argument("--no-shallow", action="store_true", help="Disable shallow git cloning")
    parser.add_argument("--update", action="store_true", help="Update already cloned repositories")
    parser.add_argument("-j", "--jobs", type=int, default=4, help="Number of concurrent git jobs")
    args = parser.parse_args()

    if not args.repos_file.exists():
        sys.exit(f"ERROR: Repos file not found: {args.repos_file}")

    args.src_dir.mkdir(parents=True, exist_ok=True)
    repos = parse_repos_yaml(args.repos_file)
    print(f"==> Found {len(repos)} repositories in {args.repos_file}")

    shallow = not args.no_shallow
    failed = []

    with ThreadPoolExecutor(max_workers=args.jobs) as executor:
        futures = [
            executor.submit(clone_or_update_repo, repo, args.src_dir, shallow, args.update)
            for repo in repos
        ]
        for f in futures:
            ok, msg = f.result()
            if not ok:
                failed.append(msg)
                print(f"[ERROR] {msg}", file=sys.stderr)

    if failed:
        print(f"\n==> ERROR: {len(failed)} repository operations failed.", file=sys.stderr)
        sys.exit(1)

    print(f"\n==> All {len(repos)} repositories successfully synchronized in {args.src_dir}")

if __name__ == "__main__":
    main()
