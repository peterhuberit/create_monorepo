#!/bin/bash
# This script imports multiple source repositories into a monorepo using Git subtree.
# It takes two arguments:
#   1. A file containing source repository URLs (one per line)
#   2. The Git URL of the monorepo
# Usage: ./create_monorepo.sh <list of source repos> <monorepo url>
# repos.txt should contains one source repo url per line (ex. https://github.com/someusername/repo.git).

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <list of source repos> <monorepo url>"
  exit 1
fi

REPO_LIST="$1"
MONOREPO_URL="$2"
MONOREPO_DIR=$(basename "$MONOREPO_URL" .git)

git clone "$MONOREPO_URL"

cd "$MONOREPO_DIR" || exit 1

while IFS= read -r repo_url; do
  [ -z "$repo_url" ] && continue

  repo_name=$(basename "$repo_url" .git)
  echo "* $repo_name ($repo_url)"
  git subtree add --prefix="$repo_name" "$repo_url" master

  echo "done: $repo_name"
  echo "------------------------"
done < "../$REPO_LIST"

echo "all done."