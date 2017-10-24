# frozen_string_literal: true

# NOTE: The presence of systemd in an upstart-tastic docker container env
# results postgresql failing to come up, as the pg_ctlcluster script expects to
# be able to forward some actions to systemd.  We do not guarantee the presence
# of systemd, so forcefully removing and purging these packages is considered
# safe.
package %w[
  libpam-systemd
  libsystemd-daemon0
  libsystemd-journal0
  libsystemd-login0
  systemd
  systemd-services
  systemd-shim
] do
  action %i[remove purge]
  only_if { node['travis_packer_templates']['env']['PACKER_BUILDER_TYPE'] == 'docker' }
end
