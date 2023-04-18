# Apptainer

## Checking available versions

```bash
module avail apptainer
```

## Using Apptainer

:::{note}
In general, do not use the default version of Apptainer within an Apptainer environment.
Specify a versioned module instead.
:::

Load the default version with `module load apptainer`,

or load a specific version with `module load apptainer/<version>`.

### Interactive session

1. Set required bind paths. These paths allow you to interact with local storage from within a container.
We recommend setting the following binds before running a container:

```bash
export APPTAINER_BINDPATH="/tmp,$HOME,/mmfs1,/sw,/scr,/gscratch,/opt,/:/hyak_root"
```

2. To start an Apptainer container interactively, run the following:

```bash
apptainer shell <path_to_container>
```

## Building Apptainer from docker.io registry

TODO

## Writing and building Apptainer recipes

TODO

## Scripting with Apptainer

TODO

To run a python script called my_script.py from within the container, run the following:

```bash
apptainer exec <path_to_container.sif> python3 ./my_script.py
```

## References

TODO