#!/usr/bin/env bash
set -euo pipefail

HB_SRC="${HB_SRC:-../harbour-core}"       # onde seu fork será montado
HB_REF="${HB_REF:-master}"              # branch/tag caso precise clonar

# Opcional: para os artefatos não saírem como root no host
HOST_UID="$(id -u)"
HOST_GID="$(id -g)"

echo "==> Compilando Harbour em $HB_SRC ..."
export HB_USER_CFLAGS="-fPIC"
export HB_BUILD_CONTRIBS=
export HB_WITH_PCRE="local"
export OUT="${OUT:-./output}"  # onde os artefatos serão copiados

make -C "$HB_SRC" -j

echo "==> Copiando artefatos para $OUT ..."
mkdir -p "$OUT/bin" "$OUT/lib" "$OUT/include"

cp -a "$HB_SRC/bin/linux/gcc/"* "$OUT/bin/" 2>/dev/null || true
cp -a "$HB_SRC/lib/linux/gcc/"*.a "$OUT/lib/" 2>/dev/null || true
cp -a "$HB_SRC/include/"* "$OUT/include/" 2>/dev/null || true

if [[ -n "$HOST_UID" && -n "$HOST_GID" ]]; then
  echo "==> Ajustando ownership para ${HOST_UID}:${HOST_GID}…"
  chown -R "$HOST_UID:$HOST_GID" "$OUT"
fi

echo "==> Build finalizado. Artefatos em $OUT"
