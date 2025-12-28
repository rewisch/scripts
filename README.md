# Personal Scripts

A collection of personal command-line scripts, managed as a Git repository and
exposed via symlinks into `~/.local/bin`.

The goal is a **simple, Unix-like system** that stays readable and maintainable
over time.

---

## Naming Convention

Scripts follow this pattern:

```text
<prefix>-<action>
```

### Rules

* lowercase only
* hyphen-separated
* descriptive, verb-first where possible
* no file extensions (`.sh`, `.py`, etc.)
* executable via shebang

### Prefixes

| Prefix | Purpose                                |
| ------ | -------------------------------------- |
| `net`  | Networking (routes, connectivity, DNS) |
| `sys`  | System configuration and OS tweaks     |
| `fs`   | Filesystem and file operations         |
| `doc`  | Document and text processing           |
| `app`  | Application-specific helpers           |
| `misc` | Small general-purpose utilities        |
| `wip`  | Work in progress / experimental        |

### Examples

```text
net-route-table
sys-apply-gnome-settings
fs-clean-dupes
doc-pdf-info
app-send-to-anki
misc-sync-home
wip-test-thing
```

---

## Repository vs Runtime

* **This repository** is the source of truth
* **`~/.local/bin`** contains symlinks to stable scripts
* Scripts are never copied — only linked

---

## Setup

The `setup` script:

* creates `~/.local/bin` if needed
* symlinks executable scripts into it
* skips:

  * `README.md`
  * `setup.sh`
  * non-executable files
  * `wip-*` scripts
* removes broken symlinks that point back into this repo

### Install / Update

```bash
chmod +x setup.sh
./setup.sh
```

Safe to run multiple times.

---

## WIP Policy

Scripts prefixed with `wip-`:

* are not symlinked
* may keep file extensions
* are promoted by renaming to a real prefix

Example:

```bash
mv wip-test-thing net-test-thing
./setup.sh
```

---

## Design Goals

* predictable names
* no global state
* no magic
* easy cleanup
