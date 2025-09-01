#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --time=06:00:00
#SBATCH --job-name=5
#SBATCH --output=/share/snailomics/zhiqi/all/out/slurm-%x-%j.out
#SBATCH --error=/share/snailomics/zhiqi/all/out/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxzy2@nottingham.ac.uk

source $HOME/.bash_profile
conda activate cox1_all

reads_dir="/share/snailomics/zhiqi/forzhiqi/hawaii"
ref_list="/share/snailomics/zhiqi/all/ref_list.txt"
out_dir="/share/snailomics/zhiqi/all/5"

mkdir -p "$out_dir"

while IFS= read -r ref_file; do
    sample=$(basename "$ref_file" _cox1_600bp.fasta)

    bwa index "$ref_file"
    bwa mem -t 8 "$ref_file" "$reads_dir/${sample}_1.trimmed.fq.gz" "$reads_dir/${sample}_2.trimmed.fq.gz" > "$out_dir/${sample}.sam"
    samtools view -bS "$out_dir/${sample}.sam" > "$out_dir/${sample}.bam"
    samtools sort "$out_dir/${sample}.bam" -o "$out_dir/${sample}_sorted.bam"
    samtools index "$out_dir/${sample}_sorted.bam"
    rm "$out_dir/${sample}.sam" "$out_dir/${sample}.bam"
done < "$ref_list"