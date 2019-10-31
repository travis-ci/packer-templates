#!/usr/bin/env bash

set -o errexit

main() {
  set -o xtrace

  export DEBIAN_FRONTEND='noninteractive'
  __install_nvm
}

__install_nvm() {
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

  echo '#!/usr/bin/env bash
export NVM_DIR="/home/travis/.nvm"

if [[ -s "${NVM_DIR}/nvm.sh" ]]; then
  source "${NVM_DIR}/nvm.sh"
fi
'  > $HOME/.bash_profile.d/nvm.bash
  chmod 644 $HOME/.bash_profile.d/nvm.bash

  nvm install 8.12.0
}
main "$@"
