#!/usr/bin/env python3

import json
import requests
import sys
import re

def remove_block_comments(text: str) -> str:
    """Remove C-style /* ... */ comments from the JSON payload."""
    return re.sub(r"/\*.*?\*/", "", text, flags=re.DOTALL)

def main():
    filename = "cards.json"
    if len(sys.argv) > 1:
        filename = sys.argv[1]

    print(f"Loading cards from: {filename}")

    # Load JSON file (raw)
    try:
        with open(filename, "r", encoding="utf-8") as f:
            raw_text = f.read()
    except FileNotFoundError:
        print(f"❌ Error: File not found: {filename}")
        return

    # Remove /* ... */ comments
    cleaned_text = remove_block_comments(raw_text)

    # Parse cleaned JSON
    try:
        payload = json.loads(cleaned_text)
    except json.JSONDecodeError as e:
        print(f"❌ Error: Invalid JSON after removing comments: {e}")
        return

    print("Sending to Anki...")

    # Connect to AnkiConnect
    try:
        response = requests.post("http://127.0.0.1:8765", json=payload)
    except requests.exceptions.ConnectionError:
        print(
            "❌ Could not connect to AnkiConnect.\n"
            "👉 Please start Anki and ensure the AnkiConnect add-on is enabled."
        )
        return

    if response.status_code != 200:
        print(f"❌ HTTP {response.status_code} from AnkiConnect:")
        print(response.text)
        return

    # Parse JSON response
    try:
        data = response.json()
    except Exception:
        print("❌ Invalid JSON response from AnkiConnect:")
        print(response.text)
        return

    # High-level error (rare)
    if data.get("error"):
        print("❌ AnkiConnect reported an error:")
        print(json.dumps(data, indent=2))
        return

    results = data.get("result")
    if not isinstance(results, list):
        print("⚠ Unexpected response structure:")
        print(json.dumps(data, indent=2))
        return

    # Check each note result for errors
    errors = []
    successes = []

    for i, entry in enumerate(results):
        if entry.get("error"):
            errors.append((i, entry["error"]))
        else:
            successes.append(entry.get("result"))

    # Reporting
    if errors:
        print("❌ Some cards could not be added:")
        for idx, err in errors:
            print(f"   • Card #{idx + 1}: {err}")
        print(f"➡ Successfully added {len(successes)} cards, {len(errors)} failed.")
    else:
        print(f"✔ All {len(successes)} cards added successfully!")
        print("   New note IDs:")
        for nid in successes:
            print(f"   • {nid}")

if __name__ == "__main__":
    main()
