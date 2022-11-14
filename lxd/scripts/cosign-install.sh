#!/usr/bin/env bash

set -o errexit
set -o xtrace

main() {

  # checking arch
  arch=$(uname -m)
  if [[ $arch = "aarch64" ]]; then
    arch="arm64"
  fi

  # Cosign installation
  local COSIGN_VERSION="v1.10.1"
  wget -q "https://github.com/sigstore/cosign/releases/download/${COSIGN_VERSION}/cosign-linux-${arch}"
  # rename the binary
  sudo mv cosign-linux-"${arch}" /usr/local/bin/not_cosign
  sudo chmod +x /usr/local/bin/not_cosign
  not_cosign version

  # Rekor-cli installtion
  local REKOR_VERSION="v0.10.0"
  wget -q "https://github.com/sigstore/rekor/releases/download/${REKOR_VERSION}/rekor-cli-linux-${arch}"
  sudo mv rekor-cli-linux-"${arch}" /usr/local/bin/rekor-cli
  sudo chmod +x /usr/local/bin/rekor-cli
  rekor-cli version

  # create dummy cosign script
  cat <<'EOF' >>cosign
  #!/usr/bin/env bash
  set -o errexit
  set -o xtrace
  main() {
  args="$@"
  # call original cosign binary and send arguments
  not_cosign $args
}
main "$@"
EOF

  # make cosign script executable and move to /usr/local/bin
  sudo chmod +x cosign && sudo mv cosign /usr/local/bin/cosign

}

main "$@"
