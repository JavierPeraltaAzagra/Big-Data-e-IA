#!/bin/bash

#SBATCH --job-name=red_neuronal_pima
#SBATCH --partition=intel_skylake
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --time=00:10:00
#SBATCH --output=/data/scratch/008/IA_BigData/u0080011/logs/red_neuronal_%j.out
#SBATCH --chdir=/data/scratch/008/IA_BigData/u0080011/src

# Limpiamos módulos cargados previamente
module purge

# Cargamos Python
module load Python/3.12.3-GCCcore-13.3.0

# Activamos el entorno virtual donde están instalados:
# torch, pandas, scikit-learn, etc.
source /data/scratch/008/IA_BigData/venv-ml/bin/activate

# Mostramos información en el fichero .out
echo "Trabajo Slurm para red neuronal PyTorch"
echo "JOB ID: $SLURM_JOB_ID"
echo "Nodo de ejecución: $SLURMD_NODENAME"
echo "CPU asignados: $SLURM_CPUS_PER_TASK"
echo "Directorio de trabajo: $(pwd)"
echo "Python usado:"
which python
python --version
echo "======================================"

# Ejecutamos el programa Python
python red_neuronal_urederra.py
echo "Trabajo finalizado"
