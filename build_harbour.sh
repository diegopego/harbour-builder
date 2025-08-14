#!/usr/bin/env bash
set -euo pipefail

# ---- Configs via env ------------------------------------------
HB_SRC="${HB_SRC:-/work/harbour}"       # onde seu fork será montado
HB_REF="${HB_REF:-master}"              # branch/tag caso precise clonar
HB_GIT_URL="${HB_GIT_URL:-https://github.com/diegopego/harbour-core}"  # mude p/ seu fork
CLONE_IF_MISSING="${CLONE_IF_MISSING:-1}"                    # 1 = clona se vazio

# Opcional: para os artefatos não saírem como root no host
HOST_UID="${HOST_UID:-}"
HOST_GID="${HOST_GID:-}"

OUT="/output"
mkdir -p "$OUT" "$HB_SRC"

# ---- Workaround dos headers do curl (igual ao workflow) -------
if [ -d /usr/include/x86_64-linux-gnu/curl ] && [ ! -d /usr/include/curl ]; then
  cp -r /usr/include/x86_64-linux-gnu/curl /usr/include/
fi

# ---- Se o mount estiver vazio e permitido, clona --------------
if [ ! -d "$HB_SRC/.git" ] && [ "${CLONE_IF_MISSING}" = "1" ]; then
  echo "==> Diretório $HB_SRC vazio. Clonando ${HB_GIT_URL} (${HB_REF})..."
  rm -rf "$HB_SRC" && mkdir -p "$HB_SRC"
  git clone --depth=1 --branch "$HB_REF" "$HB_GIT_URL" "$HB_SRC"
else
  echo "==> Usando código existente em $HB_SRC"
fi

# ---- Build ----------------------------------------------------
echo "==> Compilando Harbour em $HB_SRC ..."
export HB_USER_CFLAGS="-fPIC"
export HB_BUILD_CONTRIBS=
export HB_WITH_PCRE="local"

make -C "$HB_SRC" -j"$(nproc)"

# ---- Copia artefatos (mesma estrutura do workflow) ------------
echo "==> Copiando artefatos para $OUT ..."
mkdir -p "$OUT/bin" "$OUT/lib" "$OUT/include"

# Alguns diretórios podem não existir dependendo do build; ignore erros
cp -a "$HB_SRC/bin/linux/gcc/"* "$OUT/bin/" 2>/dev/null || true
cp -a "$HB_SRC/lib/linux/gcc/"*.a "$OUT/lib/" 2>/dev/null || true
cp -a "$HB_SRC/include/"* "$OUT/include/" 2>/dev/null || true

# ---- Ajusta ownership no host, se solicitado ------------------
if [[ -n "$HOST_UID" && -n "$HOST_GID" ]]; then
  echo "==> Ajustando ownership para ${HOST_UID}:${HOST_GID}…"
  chown -R "$HOST_UID:$HOST_GID" "$OUT"
fi

echo "==> Build finalizado. Artefatos em $OUT"
