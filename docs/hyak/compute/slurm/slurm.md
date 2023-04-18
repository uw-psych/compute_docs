# Slurm

Slurm is both a cluster manager and a job scheduler. When you submit a **job** to the job queue, Slurm allocates one or more **nodes** from the cluster based on computational needs and availability of resources. If the job was submitted with `srun` or `sbatch`, Slurm may also execute and watch tasks.