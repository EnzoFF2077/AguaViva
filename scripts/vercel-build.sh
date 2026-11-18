#!/usr/bin/env bash
set -euo pipefail

# O Vercel nao traz Flutter/Dart nativamente e limita o buildCommand a 256
# caracteres. Todo o download e compilacao ficam neste script.
FLUTTER_VERSION="3.47.4"
FLUTTER_DIR="/tmp/flutter"
TARBALL="/tmp/flutter.tar.xz"

if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
  curl -fsSL \
    "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
    -o "$TARBALL"
  tar -xf "$TARBALL" -C /tmp
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

flutter config --no-analytics
cd frontend
flutter pub get
flutter build web --release --no-tree-shake-icons
