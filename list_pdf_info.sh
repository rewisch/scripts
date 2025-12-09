#!/usr/bin/env bash

set -euo pipefail
shopt -s nullglob

VERBOSE=false
SUMMARY=false

# --- Parse arguments ------------------------------------------------
for arg in "$@"; do
    case "$arg" in
        --verbose|-v)
            VERBOSE=true
            ;;
        --summary|-s)
            SUMMARY=true
            ;;
        *)
            echo "Unknown option: $arg"
            echo "Usage: $0 [--verbose] [--summary]"
            exit 1
            ;;
    esac
done

# --- Check dependencies --------------------------------------------
if ! command -v pdfinfo >/dev/null 2>&1; then
    echo "ERROR: 'pdfinfo' command not found."
    echo "Install it with:"
    echo "  sudo apt install poppler-utils"
    echo "  brew install poppler"
    exit 1
fi

# --- Check for PDFs -------------------------------------------------
pdf_files=( *.pdf )
if [ ${#pdf_files[@]} -eq 0 ]; then
    echo "No PDF files found in the current directory."
    exit 0
fi

# --- Summary counters ----------------------------------------------
total_files=0
total_pages=0

# --- Process PDFs ---------------------------------------------------
for pdf in "${pdf_files[@]}"; do
    if ! info=$(pdfinfo "$pdf" 2>/dev/null); then
        echo "ERROR reading: $pdf"
        continue
    fi

    # Extract pages
    pages=$(grep -m1 '^Pages:' <<<"$info" | awk '{print $2}' || true)
    [[ -z "${pages:-}" ]] && pages="0"

    # Update counters
    total_files=$((total_files + 1))
    case "$pages" in
        ''|*[!0-9]*) ;; # ignore non-numeric
        *) total_pages=$((total_pages + pages)) ;;
    esac

    if $VERBOSE; then
        # Extract title
        title=$(grep -m1 '^Title:' <<<"$info" | cut -d':' -f2- | sed 's/^ *//' || true)
        [[ -z "${title:-}" ]] && title="<no title>"

        echo "File: $pdf"
        echo "  Title : $title"
        echo "  Pages : $pages"
        echo
    else
        echo "$pdf; $pages pages"
    fi
done

# --- Summary Output -------------------------------------------------
if $SUMMARY; then
    echo "---------------------------"
    echo "Total files : $total_files"
    echo "Total pages : $total_pages"
fi

exit 0
