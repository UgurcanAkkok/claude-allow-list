# Awesome Claude Allow List

A curated, ready-to-use collection of Claude Code permission rules for commands that are safe to run without manual approval.

## The Problem

Claude Code asks for your approval before running every bash command. This is a sensible default — but in practice, most commands Claude runs during a typical developer or DevOps session are completely safe: inspecting logs, querying Kubernetes, checking git history, listing cloud resources, reading package metadata.

Approving each of these individually is constant friction. Over time you accumulate a long tail of one-off approvals scattered across multiple `settings.json` files with no structure or rationale behind them.

**This repo solves that.** It provides a single, well-organized `settings.json` you can drop into your Claude config and immediately stop being prompted for 1,000+ commands that have no business requiring approval.

## What "Safe" Means Here

Commands in this list are safe in the sense that **they do not modify system state** — they read, inspect, list, describe, diff, or validate. They do not create, delete, update, apply, or execute.

That said, you are still giving an AI permission to run these commands autonomously. You should:

- Understand that Claude decides *when* and *why* to run them, not just *whether* it can
- Review the allow files and remove any categories irrelevant to your environment
- Not treat this list as a substitute for understanding what Claude is doing in your session

## Coverage

17 allow files, 1,184 rules:

| File | Coverage |
|---|---|
| `shell-readonly.jsonc` | Core Unix utilities — awk, cat, grep, curl, diff, stat, lsof, ss, openssl, git (read-only), etc. |
| `git.jsonc` | Comprehensive read-only git — log, diff, blame, stash list, for-each-ref, reflog show, and more |
| `docker.jsonc` | Docker inspect, logs, ps, stats, compose config, swarm inspection |
| `kubectl.jsonc` | Kubernetes get/describe/logs/top/diff + Helm list/get/show/template/lint |
| `terraform.jsonc` | Terraform, OpenTofu, and Terragrunt — plan, validate, show, output, state list |
| `gh.jsonc` | GitHub CLI — PRs, issues, runs, workflows, releases, search, secrets list |
| `aws.jsonc` | AWS CLI read-only — EC2, EKS, ECS, S3, IAM, Lambda, RDS, CloudWatch, Route53, and more |
| `gcloud.jsonc` | GCP CLI read-only — GCE, GKE, Cloud Run, IAM, SQL, Storage, DNS, Logging, and more |
| `azure.jsonc` | Azure CLI read-only — VMs, AKS, Networking, Storage, RBAC, Key Vault, Monitor, and more |
| `os-package-management.jsonc` | apt, dnf, yum, pacman, brew, apk, snap, flatpak — query only |
| `lang-package-management.jsonc` | pip, npm, yarn, cargo, go, mvn, gradle, gem, composer, and more — query only |
| `database-clis.jsonc` | psql, mysqladmin, redis-cli (safe commands), pg_isready, Kafka inspection |
| `observability.jsonc` | promtool, amtool, logcli, otelcol, grafana-cli, vector, fluent-bit |
| `vault.jsonc` | HashiCorp Vault — read, list, kv get, policy/auth/secrets inspection |
| `ansible.jsonc` | ansible-playbook (--check/--syntax-check only), ansible-doc, ansible-inventory, ansible-lint |
| `systemd.jsonc` | systemctl (read-only), journalctl, systemd-analyze, timedatectl, resolvectl |
| `version-managers.jsonc` | nvm, pyenv, rbenv, asdf, mise, rustup, volta, fnm — list/show only |

## Usage

**Build the merged `settings.json`:**

```bash
make build
```

This strips JSONC comments and merges all allow files into a single valid `settings.json`.

**Add to your Claude config:**

Copy the generated `settings.json` into your Claude project settings:

```bash
# Project-level (affects only this repo)
cp settings.json .claude/settings.json

# User-level (affects all projects)
cp settings.json ~/.claude/settings.json
```

Or merge manually into an existing settings file — the output contains only a `permissions.allow` array, which you can append to your current rules.

**Rebuild after changes:**

```bash
make clean && make build
```

## Customization

Each allow file is independent. To exclude a category (e.g. you don't use Azure), simply don't use those rules — the Makefile picks up all `*.jsonc` files in `allow/`, so you can delete or rename any file you don't need before building.

To add your own rules, create a new `.jsonc` file in `allow/` following the same format and run `make build`.

## Contributing

PRs welcome for new categories, additional commands within existing categories, or corrections to commands that are misclassified as safe.
