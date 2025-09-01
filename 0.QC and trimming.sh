#!/bin/bash

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --time=24:00:00
#SBATCH --job-name=0_1
#SBATCH --output=/share/snailomics/zhiqi/all/out/slurm-%x-%j.out
#SBATCH --error=/share/snailomics/zhiqi/all/out/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxzy2@nottingham.ac.uk
#SBATCH --array=1-4,6-13,15-19,21


DATA=/share/snailomics/zhiqi/forzhiqi/hawaii/

FILER1=/share/snailomics/zhiqi/forzhiqi/hawaii/a${SLURM_ARRAY_TASK_ID}_1.trimmed.fq.gz
FILER2=/share/snailomics/zhiqi/forzhiqi/hawaii/a${SLURM_ARRAY_TASK_ID}_2.trimmed.fq.gz

mkdir -p /share/snailomics/zhiqi/all/1
mkdir -p /share/snailomics/zhiqi/all/1/novoplasty

echo "Project:
-----------------------
Project name          = L${SLURM_ARRAY_TASK_ID}
Type                  = mito
Genome Range          = 12000-26000
K-mer                 = 39
Max memory            = 55
Extended log          = 0
Save assembled reads  = no
Seed Input = /share/snailomics/zhiqi/all/cox1_seed.fas

Extend seed directly  = no
Reference sequence    =
Variance detection    =
Chloroplast sequence  =

Dataset 1:
-----------------------
Read Length           = 150
Insert size           = 300
Platform              = illumina
Single/Paired         = PE
Combined reads        =
Forward reads         = $FILER1
Reverse reads         = $FILER2

Heteroplasmy:
-----------------------
MAF                   =
HP exclude list       =
PCR-free              =

Optional:
-----------------------
Insert size auto      = yes
Insert Range          = 1.9
Insert Range strict   = 1.3
Use Quality Scores    = yes
Output path           = /share/snailomics/zhiqi/all/1/
" > /share/snailomics/zhiqi/all/1/novoplasty/a${SLURM_ARRAY_TASK_ID}.txt