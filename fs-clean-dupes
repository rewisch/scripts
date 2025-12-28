#!/usr/bin/env python3
import json
import argparse
import os
import re
from collections import defaultdict
from pathlib import Path

# ------------------------------------------------------------
# Generate a new JSON filename: foo.json → foo-1.json → foo-2.json → ...
# ------------------------------------------------------------
def next_output_filename(original):
    p = Path(original)
    base = p.stem
    suffix = p.suffix
    parent = p.parent

    # Detect trailing -NUMBER
    m = re.search(r"-(\d+)$", base)
    if m:
        number = int(m.group(1)) + 1
        new_base = base[:m.start()] + f"-{number}"
    else:
        new_base = base + "-1"

    return str(parent / f"{new_base}{suffix}")


# ------------------------------------------------------------
# Main logic
# ------------------------------------------------------------
def main():
    parser = argparse.ArgumentParser(description="Process jdupes JSON with filtering and cleanup.")
    parser.add_argument("jsonfile", help="Input jdupes JSON file")
    parser.add_argument("--dry", action="store_true", help="Dry run (don't delete anything)")
    parser.add_argument("--delete-path", required=True,
                        help="Substring required for a file to be deleted (e.g. '/ojakldsf/')")
    args = parser.parse_args()

    delete_filter = args.delete_path

    # --- Load input JSON ---
    with open(args.jsonfile, "r") as f:
        data = json.load(f)

    match_sets = data.get("matchSets", [])
    dry_candidates = []        # files that *would* be deleted
    kept_match_sets = []       # cleaned matchsets

    for match in match_sets:
        filelist = match.get("fileList", [])
        if not filelist:
            continue

        keeper = filelist[0]["filePath"]
        new_filelist = [filelist[0]]  # keeper stays

        # Process the duplicates
        for entry in filelist[1:]:
            path = entry["filePath"]

            if delete_filter in path:
                # candidate for deletion
                if args.dry:
                    dry_candidates.append(path)
                else:
                    try:
                        os.remove(path)
                        print(f"Deleted: {path}")
                    except Exception as e:
                        print(f"ERROR deleting {path}: {e}")
            else:
                # protected file
                new_filelist.append(entry)

        # Only keep matchSets that still have >1 files
        if len(new_filelist) > 1:
            kept_match_sets.append({
                "fileSize": match.get("fileSize"),
                "fileList": new_filelist
            })

    # Replace matchSets with cleaned results
    data["matchSets"] = kept_match_sets

    # ------------------------------------------------------------
    # DRY RUN MODE
    # ------------------------------------------------------------
    if args.dry:
        print("\n==================== DRY RUN ====================")
        print("Files that *would* be deleted (alphabetically):\n")

        dry_sorted = sorted(dry_candidates)
        for path in dry_sorted:
            print(path)

        print("\nSummary per folder:\n")
        per_folder = defaultdict(int)
        for path in dry_candidates:
            folder = str(Path(path).parent)
            per_folder[folder] += 1

        for folder, count in sorted(per_folder.items()):
            print(f"{folder:60} {count} files")

        print("\nNo files were deleted.")
        print("Clean JSON NOT written (dry-run mode).")
        print("=================================================\n")
        return  # STOP HERE — no writing JSON


    # ------------------------------------------------------------
    # REAL DELETE MODE — write cleaned JSON
    # ------------------------------------------------------------
    output_file = next_output_filename(args.jsonfile)
    with open(output_file, "w") as f:
        json.dump(data, f, indent=2)

    print(f"\nCleaned JSON written to: {output_file}")
    print("Done.\n")


if __name__ == "__main__":
    main()
