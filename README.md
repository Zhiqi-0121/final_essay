# final_essay
# Snail mtDNA Workflow

## Project Overview
This project develops a modular and reproducible workflow to assemble snail mitochondrial genomes and identify **non-snail DNA sequences** (e.g., diet, parasites, microbes) from whole-genome Illumina data. 

The workflow was applied to endangered Hawaiian freshwater snails (*Pseudisidora* genus), producing complete circularized mitochondrial genomes and revealing additional non-snail COX1 sequences of diverse origins (algae, bacteria, fungi, parasites).  

This approach provides molecular evidence for dietary and parasitic interactions, while offering a reusable pipeline for ecological and conservation studies in non-model species.

---

## Project Aims
- **Immediate aim**: Detect food-derived DNA in Hawaiian snails to understand their natural diet (important for potential captive breeding).  

- **Larger aim**: Build a reproducible pipeline that can be easily applied to multiple genome projects, focusing on clarity and automation.  

---
## Usage

The entire workflow can be executed with a single wrapper script:

all.sh

all.sh automatically calls each sub-script in order (fastp → NOVOPlasty → MITOS → MITOZ → BAM mapping → unmapped extraction → BLAST searches → taxonomy).

Intermediate outputs are stored in numbered directories (1/, 2/, … 10/) for clarity.

Log files are written to output/ for monitoring and debugging.

Individual sub-scripts (e.g. novoplasty.array, blastn.array) can also be run separately if needed, but this is not required for the standard pipeline.

Note: Visualization and downstream plotting (e.g., community analysis, phylogenetic trees, barplots, UpSet plots) are not included in the automated workflow. These steps must be performed separately in R/Python after the main pipeline finishes.




## Workflow Outline


1. **Quality control and assembly**  
   - Raw sequencing reads were trimmed and filtered using **fastp**.  
   - Snail mitochondrial genomes were then assembled de novo with **NOVOPlasty**.  

2. **COX1 start-site standardization**  
   - Initial assemblies were annotated with **MITOS** to locate the COX1 gene.  
   - Sequences were reordered so that each genome began with the COX1 start codon.  

3. **Assembly verification**  
   - Approximately 600 bp of the COX1 region was queried with **BLASTn** to confirm species identity.  

4. **Indexing**  
   - Verified mitochondrial genomes were indexed to prepare for downstream read mapping.  

5. **Read mapping**  
   - Whole-genome reads were aligned to the assembled mtDNA to generate BAM files.  
   - Mapping rates were calculated to estimate the proportion of snail mtDNA.  

6. **Extraction of unmapped reads**  
   - Reads not aligning to snail mtDNA were exported and converted into FASTA format.  

7. **Local BLAST database construction**  
   - Unmapped reads were formatted into searchable databases using **makeblastdb**.  

8. **Identification of non-snail COX1 fragments**  
   - Known COX1 protein sequences were searched against unmapped read databases with **tblastn**.  
   - Candidate non-snail COX1-like sequences were extracted.  

9. **Sequence extraction**  
   - tblastn hits were compiled into FASTA files for downstream analysis.  

10. **Taxonomic assignment**  
    - Extracted sequences were compared against a reduced NCBI mtDNA database using **BLASTn**.  
    - The top hit for each sequence was retained for species-level classification.  

11. **Filtering and consolidation**  
    - BLAST outputs were curated to retain the best matches.  
    - Structured summary tables of sequence classifications were generated.  

12. **Taxonomic and ecological annotation**  
    - Sequences were annotated with Phylum, Class, and Order information.  
    - Each taxon was further grouped into ecological categories (e.g., dietary, parasitic, environmental).  
  

---

## Key Tools
- **QC**: fastp  
- **Assembly**: NOVOPlasty  
- **Annotation**: MITOS, MITOZ  
- **Sequence handling**: seqtk  
- **Similarity search**: BLAST+ (makeblastdb, blastn, tblastn)  
- **Phylogeny**: MAFFT, IQ-TREE2  
- **Community analysis & visualization**: R packages (vegan, ggplot2, ComplexUpset)  

---

## References
- NOVOPlasty — Dierckxsens et al., 2017. [doi:10.1093/nar/gkw955](https://doi.org/10.1093/nar/gkw955)  
- MITOS — Bernt et al., 2013. [doi:10.1016/j.ympev.2012.08.023](https://doi.org/10.1016/j.ympev.2012.08.023)  
- MitoZ — Meng et al., 2019. [doi:10.1093/nar/gkz173](https://doi.org/10.1093/nar/gkz173)  
- BLAST+ — Camacho et al., 2009. [doi:10.1186/1471-2105-10-421](https://doi.org/10.1186/1471-2105-10-421)  
- fastp — Chen et al., 2018. [doi:10.1093/bioinformatics/bty560](https://doi.org/10.1093/bioinformatics/bty560)  
- seqtk — Li, 2013. [GitHub](https://github.com/lh3/seqtk)  
- MAFFT — Katoh & Standley, 2013. [doi:10.1093/molbev/mst010](https://doi.org/10.1093/molbev/mst010)  
- IQ-TREE2 — Minh et al., 2020. [doi:10.1093/molbev/msaa015](https://doi.org/10.1093/molbev/msaa015)  
- ModelFinder — Kalyaanamoorthy et al., 2017. [doi:10.1038/nmeth.4285](https://doi.org/10.1038/nmeth.4285)  
- vegan (R) — Oksanen et al., 2020. [CRAN](https://CRAN.R-project.org/package=vegan)  
- ggplot2 (R) — Wickham, 2016. [Website](https://ggplot2.tidyverse.org/)  
- pheatmap (R) — Kolde, 2019. [CRAN](https://CRAN.R-project.org/package=pheatmap)  
- ComplexUpset (R) — Krassowski, 2022. [GitHub](https://github.com/krassowski/complex-upset)  
- UpSet plots — Lex et al., 2014. [doi:10.1109/TVCG.2014.2346248](https://doi.org/10.1109/TVCG.2014.2346248)  


---

## Notes
- Manual step: COX1 reordering (planned automation).  
- Some individuals (e.g. L11) may produce rearranged or partial assemblies.  
- Workflow designed for **HPC cluster (Slurm job arrays)** but adaptable to other environments.  
