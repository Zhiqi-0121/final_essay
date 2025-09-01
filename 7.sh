#!/bin/bash

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --time=06:00:00
#SBATCH --job-name=7
#SBATCH --output=/share/snailomics/zhiqi/all/out/slurm-%x-%j.out
#SBATCH --error=/share/snailomics/zhiqi/all/out/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxzy2@nottingham.ac.uk

source $HOME/.bash_profile



input_dir="/share/snailomics/zhiqi/all/6"
output_dir="/share/snailomics/zhiqi/all/7"

for fas in "$input_dir"/a*_unmapped.fas; do
    sample=$(basename "$fas" _unmapped.fas)

    makeblastdb -in "$fas" \
                -dbtype nucl \
                -out "$output_dir/${sample}_unmapped_db"
done