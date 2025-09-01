#!/bin/bash

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --time=06:00:00
#SBATCH --job-name=6
#SBATCH --output=/share/snailomics/zhiqi/all/out/slurm-%x-%j.out
#SBATCH --error=/share/snailomics/zhiqi/all/out/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxzy2@nottingham.ac.uk

source $HOME/.bash_profile

mkdir -p /share/snailomics/zhiqi/all/6

bam_dir="/share/snailomics/zhiqi/all/5"
out_dir="/share/snailomics/zhiqi/all/6"


for bam in "$bam_dir"/a*_sorted.bam; do
    sample=$(basename "$bam" _sorted.bam)

    samtools view -b -f 4 "$bam" > "$out_dir/${sample}_unmapped.bam"

    samtools fastq "$out_dir/${sample}_unmapped.bam" > "$out_dir/${sample}_unmapped.fastq"

     awk 'NR%4==1 {print ">" substr($0,2)} NR%4==2 {print}' "$out_dir/${sample}_unmapped.fastq" > "$out_dir/${sample}_unmapped.fas"

done