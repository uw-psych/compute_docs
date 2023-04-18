# FreeSurfer

::::{important}
Currently, FreeSurfer must run from a container with sufficient library dependencies.

:::{tip}
We recommend using FreeSurfer from a VNC session with `rockylinux8` container from
https://github.com/uw-psych/hyak_vnc_apptainer
:::
::::

FreeSurfer is an open source neuroimaging toolkit and is available as an Lmod module on Klone.

## Checking available versions

```bash
module avail freesurfer
```

## Using FreeSurfer (from escience)

Load the default version with `module load escience/freesurfer`,

or load a specific version with `module load escience/freesurfer/<version>`.

After loading the module, FreeSurfer should have its environment setup for normal use.

## Installing a different version

:::{note}
This is provided as reference material.
:::

:::{note}
This is tested from a VNC Apptainer environment with sufficient dependencies.
:::

TODO: provide steps to prepare Apptainer environment to run installer.

1. Go to https://surfer.nmr.mgh.harvard.edu/fswiki/DownloadAndInstall and download the latest FreeSurfer tar archive for CentOS 8

2. Extract the .tar.gz archive to `/sw/contrib/labname-src/freesurfer/<version>/`.

For example, if installing version 7.3.2 of FreeSurfer, then run the following:

```bash
export LABNAME=escience
export VERSION=7.3.2
mkdir -p /sw/contrib/"$LABNAME"-src/freesurfer/"$VERSION"
tar -xzf freesurfer-linux-centos8_x86_64-"$VERSION".tar.gz \
    --strip-components=1 \
    -C /sw/contrib/"$LABNAME"-src/freesurfer/"$VERSION"
```

3. Create an Lmod .lua module file for the new release with a text editor:

::::{card}
`/sw/contrib/modulefiles/labname/freesurfer/7.3.2.lua`
^^^
```lua
help([[freesurfer-7.3.2]])

local labname = "escience"
local version = "7.3.2"
local base = pathJoin("/sw/contrib/" .. labname .. "-src/freesurfer/", version)

append_path("MATLABPATH", pathJoin(base, "fsfast/toolbox"))
append_path("MATLABPATH", pathJoin(base, "matlab"))
setenv("FREESURFER_HOME", base)
prepend_path("PATH", pathJoin(base, "bin"))
source_sh("bash", pathJoin(base, "SetUpFreeSurfer.sh"))
whatis("Name: FreeSurfer")
whatis("Version: " .. version)
```
::::

4. Request a free license from https://surfer.nmr.mgh.harvard.edu/registration.html if not already.

:::{note}
This license is not tied to a specific version of FreeSurfer and can be copied from a previous
installation.
:::

5. Download license.txt from the registration email and copy it to
`/sw/contrib/labname-src/freesurfer/<version>/license.txt`.