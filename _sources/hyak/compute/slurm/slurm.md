# Slurm Basics

UW Hyak clusters use [Slurm](https://slurm.schedmd.com/) to manage access to compute resources and
schedule user-submitted jobs.

Users can submit a batch job for scripted parallel tasks or an interactive job for manual tasks or
GUI programs.

## Checking access to compute resources

Use `groups` command to see which groups you are a member of.

Use `hyakalloc` command to check availability of compute resources.

## Submitting an interactive job with salloc

```bash
salloc -A <lab> -p <node_type> -N <NUM_NODES> -c <NUM_CPUS> --mem=<MEM>[UNIT] --time=DD-HH:MM:SS
```

Add `--no-shell` flag if you plan to enter/exit the node without losing the job allocation.

Use `scancel <job_id>` to terminate the job allocation.

Use `squeue --me` to check information about active or pending job allocations (including job ID).

## Submitting an interactive job with srun

From the login node, run the following:

```bash
srun -A <lab> -p <node_type> -N <NUM_NODES> -c <NUM_CPUS> --mem=<MEM>[UNIT] --time=DD-HH:MM:SS --pty /bin/bash
```

## Submitting a batch job

::::{card}
`mybatch.job`
^^^
```bash
#!/bin/bash

#SBATCH --job-name=<name> # optional
#SBATCH --mail-type=<status> # optional
#SBATCH --mail-user=<email> # optional

#SBATCH --account=<lab>
#SBATCH --partition=<node_type>
#SBATCH --nodes=<num_nodes>
#SBATCH --ntasks-per-node=<cores_per_node>
#SBATCH --mem=<size[unit]>
#SBATCH --gpus=<type:quantity>
#SBATCH --time=<time> # Max runtime in DD-HH:MM:SS format.

#SBATCH --chdir=<working directory> # default: current working directory
#SBATCH --export=all
#SBATCH --output=<file> # where STDOUT goes
#SBATCH --error=<file> # where STDERR goes

# Your program goes here...
my_program
```
::::


```bash
sbatch mybatch.job
```