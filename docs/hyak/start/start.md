# Getting Started

1. Get access to Hyak:
    - Active UW students can join UW Reserach Computing Club (RCC) to gain access to STF-funded nodes.
    - PI's or labs should purchase dedicated storage and compute resources.

2. [Login to a cluster via SSH](./connect-ssh.md):

:::::{tab-set}
::::{tab-item} Klone
```bash
ssh UWNetID@klone.hyak.uw.edu
```
::::
::::{tab-item} Mox
```bash
ssh UWNetID@mox.hyak.uw.edu
```
::::
:::::

3. Navigate and understand its [compute infrastructure](../compute/compute.md):
    - Request compute jobs with [Slurm](../compute/slurm/slurm.md)
    - Access certain programs with [Lmod software modules](../compute/lmod.md)
    - Build and run software containers with [Apptainer](../compute/apptainer/apptainer.md)
    - Create and access a virtual desktop with [hyakvnc](./hyakvnc.md)

## Overview

```{tableofcontents}
```