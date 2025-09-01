#!/bin/bash

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --time=06:00:00
#SBATCH --job-name=9
#SBATCH --output=/share/snailomics/zhiqi/all/out/slurm-%x-%j.out
#SBATCH --error=/share/snailomics/zhiqi/all/out/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxzy2@nottingham.ac.uk


source $HOME/.bash_profile


input_dir="/share/snailomics/zhiqi/all/8"
output_dir="/share/snailomics/zhiqi/all/9"

mkdir -p "$output_dir"

for fas in "$input_dir"/*_cox1_candidate.fas; do
    sample=$(basename "$fas" _cox1_candidate.fas)
    sample_out="${output_dir}/${sample}"
    mkdir -p "$sample_out"
    count=1
    awk -v out="$sample_out" -v prefix="$sample" '
        /^>/ {
            if (seq) {
                print seq > file
                close(file)
            }
            file = out "/" prefix "_seq" count ".fas"
            print $0 > file
            count++
            seq=""
        }
        /^[^>]/ {
            seq = seq $0
        }
        END {
            if (seq) {
                print seq > file
                close(file)
            }
        }
    ' "$fas"
done