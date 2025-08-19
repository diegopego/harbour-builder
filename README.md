- https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
- Tenha seu fork local em ../harbour-core
    - Ex.: git clone https://github.com/diegopego/harbour-core ../harbour-core

# 2) Build da imagem
docker compose build
<!-- docker compose build --no-cache -->

# 3) Rodar o build (artefatos em ./output)
docker compose up --abort-on-container-exit

# 4) Iteração rápida:
#    Edite o código no seu host (./harbour) e rode novamente:
docker compose run --rm harbour

# (Opcional) Para preservar owner dos arquivos de saída no host:
HOST_UID=$(id -u) HOST_GID=$(id -g) docker compose run --rm harbour

# teste básico
output/bin/hbmk2 harbour/tests/achoice.prg -run