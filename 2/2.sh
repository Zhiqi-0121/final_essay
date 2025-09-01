#!/bin/bash

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --time=06:00:00
#SBATCH --job-name=2
#SBATCH --output=/share/snailomics/zhiqi/all/out/slurm-%x-%j.out
#SBATCH --error=/share/snailomics/zhiqi/all/out/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxzy2@nottingham.ac.uk

source $HOME/.bash_profile

mkdir -p /share/snailomics/zhiqi/all/2
cd /share/snailomics/zhiqi/all/2

for fasta in /share/snailomics/zhiqi/all/1/Circularized_assembly_1_L*.fasta
do
    filename=$(basename "$fasta" .fasta)

    mitoz annotate \
        --clade Mollusca \
        --fastafiles "$fasta" \
        --outprefix "${filename}_mitoz" \
        --thread_number 8 \
        --workdir "/share/snailomics/zhiqi/all/2"

done