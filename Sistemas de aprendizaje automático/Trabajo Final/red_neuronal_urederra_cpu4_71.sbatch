#!/bin/bash

#SBATCH --job-name=red_neuronal_cpu4
#SBATCH --partition=intel_skylake
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=00:10:00
#SBATCH --output=/data/scratch/008/IA_BigData/trabajo71/logs71/red_neuronal_%j.out
#SBATCH --chdir=/data/scratch/008/IA_BigData/trabajo71/src71

module purge

module load Python/3.12.3-GCCcore-13.3.0

source /data/scratch/008/IA_BigData/trabajo71/venv-ml71/bin/activate

echo "=================================="
echo "Trabajo PyTorch multicore CPU"
echo "JOB ID: $SLURM_JOB_ID"
echo "CPUs asignadas: $SLURM_CPUS_PER_TASK"
echo "Nodo: $SLURMD_NODENAME"
echo "=================================="

time -p python red_neuronal_urederra_cpu4_71.py