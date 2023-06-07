# SPM and CONN Toolboxes

[Statistical Parametric Mapping (SPM)](https://www.fil.ion.ucl.ac.uk/spm/) and
[CONN](https://web.conn-toolbox.org/) are available as Lmod modules on Klone.

## Checking available versions

```bash
module avail spm
module avail conn
```

## Using SPM (from escience)

Load the default version with `module load escience/spm`,

or load a specific version with `module load escience/spm/<version>`.

After loading the module, start `matlab` and run `spm` in the MATLAB command window.

## Using CONN (from escience)

Load the default version with `module load escience/conn`

or load a specific version with `module load escience/conn/<version>`.

After loading the module, start `matlab` and run `conn` in the MATLAB command window.

## Installing a different version of SPM

:::{note}
This is provided as reference material.
:::

:::{note}
This is tested from a VNC Apptainer environment with sufficient dependencies.
:::

1. Download a version of SPM from https://www.fil.ion.ucl.ac.uk/spm/software/download/.

2. Extract the .zip archive to `/sw/contrib/labname-src/spm/spm<version>/`

For example, if installing version 12 of SPM, then run the following:

```bash
export LABNAME=escience
export VERSION=12
export TARGET=/sw/contrib/"$LABNAME"-src/spm/
mkdir -p $TARGET
unzip spm$VERSION.zip -d $TARGET
```

3. Create an Lmod .lua module file for the new release with a text editor:

::::{card}
`/sw/contrib/modulefiles/labname/spm/<version>.lua`
^^^
```lua
help([[spm12]])

local labname = "escience"
local version = "12"
local base = "/sw/contrib/" .. labname .. "-src/spm/spm" .. version

depends_on("matlab")
append_path("MATLABPATH", base)
whatis("Name: spm")
whatis("Version: " .. version)
```
::::

::::{note}
Lmod takes some time to cache available modules. If a module does not appear, use the `-I` or
`--ignore_cache` flag to force Lmod to check for new modules.

```bash
module -I avail spm
module -I load labname/spm
```
::::

## Installing a different version of CONN

:::{note}
This is provided as reference material.
:::

:::{note}
This is tested from a VNC Apptainer environment with sufficient dependencies.
:::

1. Download a version of CONN from https://www.nitrc.org/frs/?group_id=279.

2. Extract the .zip archive to 

For example, if installing version `v.22.a` from `conn22a.zip`, then run the following:

```bash
export LABNAME=escience
export VERSION=v.22.a
export TARGET=/sw/contrib/"$LABNAME"-src/conn/
mkdir -p $TARGET
unzip conn22a.zip -d $TARGET
mv $TARGET/conn $TARGET/$VERSION
```

3. Create a Lmod .lua module file for the new release with a text editor:

::::{card}
`/sw/contrib/modulefiles/labname/conn/<version>.lua`
^^^
```lua
help([[conn-v.22.a]])

local labname = "escience"
local version = "v.22.a"
local base = pathJoin("/sw/contrib/" .. labname .. "-src/conn", version)

depends_on("matlab")
depends_on("escience/spm")
append_path("MATLABPATH", base)
whatis("Name: CONN")
whatis("Version: " .. version)
```
::::

::::{note}
Lmod takes some time to cache available modules. If a module does not appear, use the `-I` or
`--ignore_cache` flag to force Lmod to check for new modules.

```bash
module -I avail conn
module -I load labname/conn
```
::::