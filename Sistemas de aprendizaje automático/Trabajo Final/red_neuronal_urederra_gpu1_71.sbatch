#!/bin/bash

#SBATCH --job-name=red_neuronal_gpu1
#SBATCH --partition=nvidia_h100
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=12
#SBATCH --mem=120G
#SBATCH --time=00:10:00
#SBATCH --output=/data/scratch/008/IA_BigData/logs/red_neuronal_%j.out
#SBATCH --chdir=/data/scratch/008/IA_BigData/src

module purge

module load Python/3.12.3-GCCcore-13.3.0

source /data/scratch/008/IA_BigData/venv-ml/bin/activate

echo "=================================="
echo "Trabajo PyTorch GPU"
echo "JOB ID: $SLURM_JOB_ID"
echo "CPUs asignadas: $SLURM_CPUS_PER_TASK"
echo "Nodo: $SLURMD_NODENAME"
echo "GPU asignada: $CUDA_VISIBLE_DEVICES"
echo "=================================="

# NVIDIA System Management Interface
nvidia-smi

time -p python red_neuronal_urederra_gpu1.py