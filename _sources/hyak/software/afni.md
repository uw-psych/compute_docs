# AFNI

## Checking available versions

```bash
module avail afni
```

## Using AFNI (from forsyth)

:::{note}
Currently, AFNI only runs in a VNC Apptainer environment with sufficient dependencies.
:::

Load AFNI with `module load forsyth/afni`.

After loading the module, all AFNI tools are made accessible in the shell session.

## Installing AFNI

:::{note}
This is provided as reference material.
:::

:::{note}
This is ran from a VNC Apptainer environment with sufficient dependencies.
:::

TODO: provide steps to prepare Apptainer environment to run installer.

1. Download AFNI installer:

```bash
curl -O https://afni.nimh.nih.gov/pub/dist/bin/misc/@update.afni.binaries
```

2. Install the CentOS 7 package to `/sw/contrib/labname-src/afni`:

```bash
export LABNAME=escience
export TARGET=/sw/contrib/"$LABNAME"-src/afni/
tcsh @update.afni.binaries -package linux_centos_7_64 -do_extras -bindir $TARGET
```

3. Install required R libraries to `/sw/contrib/labname-src/afni/Rlibs`:

```bash
export R_LIBS=$TARGET/Rlibs
mkdir -p $R_LIBS
rPkgsInstall -pkgs ALL
```

4. Create an Lmod .lua module file for AFNI with a text editor:

::::{card}
`/sw/contrib/modulefiles/labname/afni.lua`
^^^
```lua
help([[afni]])

local labname = "escience"
local base = "/sw/contrib/" .. labname .. "-src/afni"
local r_libs = pathJoin(base, "Rlibs")

append_path("PATH", base)
setenv("R_LIBS", r_libs)

if (mode() == "load") then
    LmodMessage("R_LIBS set to " .. r_libs)
    LmodMessage("------------------------------------------------------------")
    LmodMessage("On initial use, run the following:")
    LmodMessage("  suma -update_env")
end

whatis("Name: " .. name)
whatis("Version: " .. version)
```
::::

::::{note}
Lmod takes some time to cache available modules. If a module does not appear, use the `-I` or
`--ignore_cache` flag to force Lmod to check for new modules.

```bash
module -I avail afni
module -I load labname/afni
```
::::