#!/bin/bash
# Builds libsid64.dylib (reSID + reSID-fp wrapper) for the macOS project and
# drops it into C64Devmachine/extensions/sid64/. Universal: Apple Silicon + Intel.
# Needs the Xcode command line tools once:  xcode-select --install
set -e
cd "$(dirname "$0")"
OUT="../../C64Devmachine/extensions/sid64/libsid64.dylib"
SRC="sid64.cpp"
for f in resid/*.cpp resid-fp/*.cpp; do
  case "$f" in
    */version.cpp|*/versionfp.cpp) ;;
    *) SRC="$SRC $f" ;;
  esac
done
clang++ -O3 -std=c++11 -w -dynamiclib -fvisibility=hidden \
  -arch arm64 -arch x86_64 -mmacosx-version-min=10.15 \
  -install_name @rpath/libsid64.dylib \
  -o "$OUT" $SRC
echo "Built $OUT"
lipo -info "$OUT"
nm -gU "$OUT" | grep sid64_
