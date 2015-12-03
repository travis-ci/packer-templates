describe file('/tmp'), docker: false do
  it do
    should be_mounted.with(
      device: 'none',
      type: 'tmpfs',
      options: {
        rw: true,
        noatime: true,
        size: '1024m'
      }
    )
  end
end
