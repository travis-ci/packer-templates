#!/usr/bin/env bash

set -o errexit

main() {
  set -o xtrace

  export DEBIAN_FRONTEND='noninteractive'
  __install_elixir

}

__install_elixir() {
  set -o xtrace

  \curl -sSL https://raw.githubusercontent.com/taylor/kiex/master/install | bash -s

  tee /home/travis/.bash_profile.d/kiex.bash <<\EOF
test -s "$HOME/.kiex/scripts/kiex" && source "$HOME/.kiex/scripts/kiex"
EOF

  elixir="1.9.1"
  curl -sL -o /tmp/v${elixir}.zip https://github.com/elixir-lang/elixir/releases/download/v${elixir}/Precompiled.zip

  mkdir -p ${HOME}/.kiex/elixirs
  unzip -d ${HOME}/.kiex/elixirs/elixir-${elixir} /tmp/v${elixir}.zip

  tee ${HOME}/.kiex/elixirs/elixir-${elixir}.env <<EOF
export ELIXIR_VERSION=${elixir}
export PATH=${HOME}/.kiex/elixirs/elixir-${elixir}/bin:$PATH
export MIX_ARCHIVES=${HOME}/.kiex/mix/elixir-${elixir}
EOF

  rm -f /tmp/v${elixir}.zip

  ${HOME}/.kiex/bin/kiex default ${elixir}
}

main "$@"
