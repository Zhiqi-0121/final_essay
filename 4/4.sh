#!/bin/bash

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --time=06:00:00
#SBATCH --job-name=4
#SBATCH --output=/share/snailomics/zhiqi/all/out/slurm-%x-%j.out
#SBATCH --error=/share/snailomics/zhiqi/all/out/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxzy2@nottingham.ac.uk

source $HOME/.bash_profile

input_dir="/share/snailomics/zhiqi/all/3.5"
output_dir="/share/snailomics/zhiqi/all/4"

mkdir -p "$output_dir"

seed="/share/snailomics/zhiqi/all/cox1_seed.fas"
db="$output_dir/cox1_db"
makeblastdb -in "$seed" -dbtype nucl -out "$db"

for fasta in "$input_dir"/*.fasta; do
    sample=$(basename "$fasta" .fasta)
    query="${output_dir}/${sample}_cox1_600bp.fasta"
    result="${output_dir}/${sample}_blast.txt"

    head -n 2 "$fasta" | awk 'NR==1{print $0} NR==2{print substr($0,1,600)}' > "$query"
    blastn -query "$query" -db "$db" -out "$result" -outfmt 6
done