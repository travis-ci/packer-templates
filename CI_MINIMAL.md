Travis CI minimal build env template
====================================

This template is used to generate images for CI job execution based on Ubuntu
trusty for both Docker and VMware.

## Building and promoting the VMware image

The VMware image currently uses the `vmware-vmx` builder, which is not supported
on Atlas.  It depends on the presence of the build artifact from the [VMware
trusty base image](./VMWARE_UBUNTU_TRUSTY_BASE.md).  While use of the `vsphere`
post-processor technically works, the size of the final image is still fairly
big (&gt; 700MB) and failure to upload the image will cause the entire build to
abort.  Instead, it is recommended to build the VMX artifact, convert it to an
OVA with `ovftool`, and then deploy the OVA via the VSphere extended web client:

### build the VMX

(Depends on `packer` &gt;= v0.7.5)

``` bash
packer build -only=ci-minimal-vmx ci-minimal.json
```

### convert the VMX to an OVA

(Depends on `ovftool` ~&gt; 4.0.0)

``` bash
ovftool ./output-ci-minimal-vmx/ci-minimal.vmx ./output-ci-minimal-vmx/ci-minimal.ova
```

### deploy the OVA

This step may be done with `ovftool` or through the web with VSphere.
