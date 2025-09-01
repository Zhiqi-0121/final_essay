#!/bin/bash

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --time=06:00:00
#SBATCH --job-name=1
#SBATCH --output=/share/snailomics/zhiqi/all/out/slurm-%x-%j.out
#SBATCH --error=/share/snailomics/zhiqi/all/out/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxzy2@nottingham.ac.uk
#SBATCH --mail-type=begin
#SBATCH --mail-type=fail
#SBATCH --mail-type=end
#SBATCH --array=1-4,6-13,15-19,21



DATA=/share/snailomics/zhiqi/all/1

IND=a${SLURM_ARRAY_TASK_ID}

echo "Making mtDNA ${IND} assembly with Novoplasty"
perl /share/snailomics/zhiqi/novoplasty/NOVOPlasty4.3.1.pl -c $DATA/novoplasty/${IND}.txt