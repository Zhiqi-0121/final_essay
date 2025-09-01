[mbxzy2@hpclogin02(Ada) scr]$ cat  2_1.py
import glob, os, re
from Bio import SeqIO
from Bio.SeqRecord import SeqRecord

input_dir  = "/share/snailomics/zhiqi/all/1"
output_dir = "/share/snailomics/zhiqi/all/2.5"
cox1_seq   = "ttgcgttgattattttct"

def get_index(path):
    m = re.search(r"_L(\d+)\.fasta$", path)
    return int(m.group(1)) if m else 0

for fasta_path in sorted(glob.glob(os.path.join(input_dir, "Circularized_assembly_1_L*.fasta")), key=get_index):
    fasta_name = os.path.basename(fasta_path)
    m = re.search(r"_L(\d+)\.fasta$", fasta_name)
    if not m:
        continue
    idx = m.group(1)                              # ← 用 L 号做输出名

    try:
        recs = list(SeqIO.parse(fasta_path, "fasta"))
        if len(recs) != 1:
            print(f"Error: {fasta_name} contains {len(recs)} sequences, skipping.")
            continue

        seq = str(recs[0].seq).lower()
        start = seq.find(cox1_seq)
        if start == -1:
            print(f"COX1 sequence not found in {fasta_name}")
            continue

        new_seq = recs[0].seq[start:] + recs[0].seq[:start]
        new_rec = SeqRecord(new_seq, id=recs[0].id, description="COX1-first rearranged")

        output_name = f"Circularized_assembly_1_a{idx}_cox1start.fasta"   # ← 现在一定是 a21
        SeqIO.write(new_rec, os.path.join(output_dir, output_name), "fasta")
        print(f"Done: {output_name}")

    except Exception as e:
        print(f"Error processing {fasta_name}: {e}")