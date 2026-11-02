#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/env.sh"
cd "$ROOT"

REPO=din-mukhammed/tuck
TAP=din-mukhammed/homebrew-tuck
VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" Resources/Info.plist)
TAG="v$VERSION"
ZIP="dist/Tuck-$VERSION.zip"

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Working tree is not clean; commit first." >&2
  exit 1
fi
if gh release view "$TAG" --repo "$REPO" >/dev/null 2>&1; then
  echo "Release $TAG already exists; bump CFBundleShortVersionString in Resources/Info.plist." >&2
  exit 1
fi

scripts/test.sh
scripts/build-app.sh

rm -f "$ZIP"
ditto -c -k --keepParent dist/Tuck.app "$ZIP"
if [[ -n "${TUCK_SIGN_IDENTITY:-}" && -n "${TUCK_NOTARY_PROFILE:-}" ]]; then
  xcrun notarytool submit "$ZIP" --keychain-profile "$TUCK_NOTARY_PROFILE" --wait
  xcrun stapler staple dist/Tuck.app
  rm -f "$ZIP"
  ditto -c -k --keepParent dist/Tuck.app "$ZIP"
  NOTES="Signed with Developer ID and notarized by Apple."
else
  NOTES="Not notarized: macOS will say it cannot verify Tuck. See Install in the README for how to open it."
fi
SHA=$(shasum -a 256 "$ZIP" | cut -d' ' -f1)

git push origin HEAD
gh release create "$TAG" "$ZIP" --repo "$REPO" --target "$(git rev-parse HEAD)" \
  --title "Tuck $VERSION" --notes "$NOTES"

TAP_DIR=.build/tap
rm -rf "$TAP_DIR"
gh repo clone "$TAP" "$TAP_DIR" -- --quiet
sed -i '' -e "s/^  version \".*\"/  version \"$VERSION\"/" -e "s/^  sha256 \".*\"/  sha256 \"$SHA\"/" "$TAP_DIR/Casks/tuck.rb"
git -C "$TAP_DIR" commit -qam "tuck $VERSION"
git -C "$TAP_DIR" push -q
echo "Released $TAG ($SHA) and updated $TAP"
