#!/bin/bash

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --time=24:00:00
#SBATCH --job-name=10-1-1
#SBATCH --output=/share/snailomics/zhiqi/all/out/slurm-%x-%j.out
#SBATCH --error=/share/snailomics/zhiqi/all/out/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxzy2@nottingham.ac.uk
#SBATCH --array=0-9

source $HOME/.bash_profile
conda activate cox1_all

folders=(a11 a12 a13 a19 a2 a21 a4 a7 a8 a9)
sample=${folders[$SLURM_ARRAY_TASK_ID]}

query_dir="/share/snailomics/zhiqi/all/9/$sample"
out_dir="/share/snailomics/zhiqi/all/10"
blast_db="/share/snailomics/blast/core_nt"

mkdir -p "$out_dir"

for file in "$query_dir"/*.fas; do
    base=$(basename "$file" .fas)
    blastn -query "$file" \
           -db "$blast_db" \
           -out "$out_dir/${base}_blastn.txt" \
           -evalue 1e-10 \
           -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore staxids" \
           -max_target_seqs 1 \
           -num_threads 4
    sleep 1
done