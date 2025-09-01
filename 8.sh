[mbxzy2@hpclogin02(Ada) scr]$ cat 8.sh
#!/bin/bash

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --time=06:00:00
#SBATCH --job-name=8
#SBATCH --output=/share/snailomics/zhiqi/all/out/slurm-%x-%j.out
#SBATCH --error=/share/snailomics/zhiqi/all/out/slurm-%x-%j.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbxzy2@nottingham.ac.uk


source $HOME/.bash_profile



module avail seqtk
module load seqtk-uoneasy/1.4-GCC-12.3.0


query="/share/snailomics/zhiqi/sequence.fasta"
db_dir="/share/snailomics/zhiqi/all/7"
fasta_dir="/share/snailomics/zhiqi/all/6"
out_dir="/share/snailomics/zhiqi/all/8"

for dbpath in "$db_dir"/*_unmapped_db.nal; do
    base=$(basename "$dbpath" _unmapped_db.nal)
    db="${db_dir}/${base}_unmapped_db"
    echo "Running tblastn on $base..."

    # Run tblastn
    tblastn -query "$query" \
            -db "$db" \
            -evalue 1e-5 \
            -outfmt 6 \
            -out "$out_dir/${base}_tblastn.txt"

    awk '{print $2}' "$out_dir/${base}_tblastn.txt" > "$out_dir/${base}_tblastn.lst"

    seqtk subseq "$fasta_dir/${base}_unmapped.fas" "$out_dir/${base}_tblastn.lst" > "$out_dir/${base}_cox1_candidate.fas"

    grep -c "^>" "$out_dir/${base}_cox1_candidate.fas" > "$out_dir/${base}_cox1_candidate.count"
done