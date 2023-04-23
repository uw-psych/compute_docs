# Apptainer

Apptainer (formerly Singularity) is a simple container platform enabling users to install and run
software that would otherwise be unsupported by the host environment.

## Checking available versions

```bash
module avail apptainer
```

## Using Apptainer

:::{note}
In general, do not use the default version of Apptainer if within an Apptainer environment. Load a
module with a version specified instead.
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

## Pulling an Apptainer image from docker.io registry

apptainer pull docker://<image_name>[:<tag>]

## Writing and building Apptainer recipes

https://apptainer.org/docs/user/main/definition_files.html

## Scripting with Apptainer

TODO

To run a python script called my_script.py from within the container, run the following:

```bash
apptainer exec <path_to_container.sif> python3 ./my_script.py
```

## Clearing Apptainer cache



## Changing Apptainer cache

Set APPTAINER_CACHEDIR environment variable to a different cache path.

## References

TODO