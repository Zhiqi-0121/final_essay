#!/bin/bash

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --time=06:00:00
#SBATCH --job-name=3_1
#SBATCH --output=/share/snailomics/zhiqi/all/out/slurm-%x-%j.out
#SBATCH --error=/share/snailomics/zhiqi/all/out/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxzy2@nottingham.ac.uk

src="/share/snailomics/zhiqi/all/3"
dst="/share/snailomics/zhiqi/all/3.5"
mkdir -p "$dst"

find "$src" -name "*.gbf.fasta" | while read filepath; do
    filename=$(basename "$filepath")
    sample=$(echo "$filename" | cut -d_ -f1)
    cp "$filepath" "$dst/${sample}.fasta"
done