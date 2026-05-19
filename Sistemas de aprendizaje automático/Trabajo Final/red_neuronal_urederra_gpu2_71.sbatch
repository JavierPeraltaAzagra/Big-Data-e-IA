#!/bin/bash

#SBATCH --job-name=red_neuronal_gpu2
#SBATCH --partition=nvidia_h100
#SBATCH --gres=gpu:2
#SBATCH --cpus-per-task=12
#SBATCH --mem=32G
#SBATCH --time=00:10:00
#SBATCH --output=/data/scratch/008/IA_BigData/trabajo71/logs71/red_neuronal_%j.out
#SBATCH --chdir=/data/scratch/008/IA_BigData/trabajo71/src71

module purge

module load Python/3.12.3-GCCcore-13.3.0

source /data/scratch/008/IA_BigData/trabajo71/venv-ml71/bin/activate

echo "=================================="
echo "Trabajo PyTorch GPU"
echo "JOB ID: $SLURM_JOB_ID"
echo "CPUs asignadas: $SLURM_CPUS_PER_TASK"
echo "Nodo: $SLURMD_NODENAME"
echo "GPU asignada: $CUDA_VISIBLE_DEVICES"
echo "=================================="

# NVIDIA System Management Interface
nvidia-smi

time -p python red_neuronal_urederra_gpu2_71.py