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

source $HOME/.bash_profile

blast_dir="/share/snailomics/zhiqi/all/10"
outdir="/share/snailomics/zhiqi/all/10_1"
mkdir -p "$outdir"
output_file="$outdir/taxonomy_summary.tsv"

taxpy=$(mktemp)
cat << 'EOF' > "$taxpy"
from Bio import Entrez
import sys
Entrez.email = "mbxzy2@nottingham.ac.uk"
acc = sys.argv[1]
try:
    search = Entrez.esearch(db="nucleotide", term=acc)
    rec = Entrez.read(search)
    search.close()
    if not rec["IdList"]:
        print("NA", "NA", "NA")
        sys.exit()
    nid = rec["IdList"][0]
    summary = Entrez.esummary(db="nucleotide", id=nid)
    sm = Entrez.read(summary)
    summary.close()
    taxid = sm[0].get("TaxId", None)
    if not taxid:
        print("NA", "NA", "NA")
        sys.exit()
    fetch = Entrez.efetch(db="taxonomy", id=taxid, retmode="xml")
    taxdata = Entrez.read(fetch)
    fetch.close()
    lineage = taxdata[0]["LineageEx"]
    phylum = next((x["ScientificName"] for x in lineage if x["Rank"] == "phylum"), "NA")
    _class = next((x["ScientificName"] for x in lineage if x["Rank"] == "class"), "NA")
    order = next((x["ScientificName"] for x in lineage if x["Rank"] == "order"), "NA")
    print(phylum, _class, order)
except:
    print("NA", "NA", "NA")
EOF

echo -e "Filename\tAccession\tPhylum\tClass\tOrder" > "$output_file"

for file in "$blast_dir"/*_blastn.txt; do
    [ ! -s "$file" ] && continue
    acc=$(awk 'NR==1 {match($2, /\|gb\|([^.]+\.[^|]+)\|/, m); if (m[1]) print m[1]}' "$file")
    [ -z "$acc" ] && continue
    tax_info=$(python "$taxpy" "$acc")
    echo -e "$(basename "$file")\t$acc\t$tax_info" >> "$output_file"
done

rm "$taxpy"