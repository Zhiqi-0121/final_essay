#!/bin/bash

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --time=06:00:00
#SBATCH --job-name=3
#SBATCH --output=/share/snailomics/zhiqi/all/out/slurm-%x-%j.out
#SBATCH --error=/share/snailomics/zhiqi/all/out/slurm-%x-%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxzy2@nottingham.ac.uk

source $HOME/.bash_profile



input_dir="/share/snailomics/zhiqi/all/2.5"
output_dir="/share/snailomics/zhiqi/all/3"
cd "$output_dir"

for i in {1..21}; do
    fasta="$input_dir/Circularized_assembly_1_a${i}_cox1start.fasta"
    prefix="a${i}"

    echo "Running mitoz annotate for $prefix..."

    mitoz annotate \
        --genetic_code 5 \
        --clade Mollusca \
        --outprefix "$prefix" \
        --thread_number 4 \
        --fastafile "$fasta"

    echo "Done: $prefix"
done