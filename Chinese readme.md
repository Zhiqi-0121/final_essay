# final_essay （Chinese）
## Snail mtDNA Workflow 

Here is a Chinese version of the explanation, for those who, like the author, have poor English skills but excellent Chinese proficiency.  

The content is consistent with `README.md`.

---

## Friendly Note
Since the content is identical, people who cannot read Chinese can simply ignore this document.  

If a more formal explanation is needed, or for GitHub grading purposes, please just refer to the English `README.md`.  

---
## 中文说明：（下面就全是中文了）
这是一个中文版的说明，提供给那些跟我一样，英文不好，但是中文很好的人。

这个文档的内容与正式版的readme.md一致
如果不认识中文的人或者想看语气更正式版本的readme请跳过此文档，不影响阅读

（在正式文本后面会有我自己的笔记。如果学术的，正式的说明看不懂，可以直接看那个）

## 项目介绍
该项目开发了一种模块化且可重复的操作流程，用于组装蜗牛的线粒体基因组，并从全基因组的 Illumina 数据中识别出**非蜗牛的 DNA 序列**（例如饮食、寄生虫、微生物）。

该流程被应用于濒危的夏威夷淡水蜗牛（*Pseudisidora*属）中，成功生成了完整的环状线粒体基因组，并揭示了来自不同来源（藻类、细菌、真菌、寄生虫）的额外非蜗牛的 COX1 序列。

这种方法为饮食和寄生虫相互作用提供了分子证据，同时为非模式物种的生态和保护研究提供了一个可重复使用的流程。

---

这个项目的目的是为了，从一堆混在一起的DNA序列中，**识别蜗牛吃啥**（研究对象是濒危的夏威夷淡水蜗牛（*Pseudisidora*属）

为了批量化的研究蜗牛吃啥，开发了一个**自动化的脚本**

---

## 项目目标
- **短期目标**：在夏威夷蜗牛体内检测出源自食物的 DNA，以了解其天然食物来源（这对于可能进行的圈养繁殖工作至关重要）。

- **长期目标**：建立一个可重复使用的流程体系，能够轻松应用于多个基因组项目，重点在于清晰度和自动化。 

---
目标两个

1.这个项目跑通，**识别出蜗牛吃啥**

2.**自动化**的跑脚本，长期的
总的来说就是一些毕业项目的目标。

---
## 使用方法

整个工作流程都可以通过一个单一的封装脚本来完成：

 all.sh

all.sh 会自动依次调用每个子脚本（fastp → NOVOPlasty → MITOS → MITOZ → BAM 对比映射 → 未映射数据提取 → BLAST 搜索 → 分类学分析）。

中间输出结果被存储在编号目录（1/、2/、……10/）中，以便于清晰区分。

日志文件会被写入“output/”目录中，用于监控和调试之用。

单独的子脚本（例如“novoplasty.array”、“blastn.array”）如果需要的话也可以单独运行，但对于标准流程而言，这并非必要步骤。

注意：可视化和后续的绘图操作（例如群落分析、系统发育树、条形图、UpSet 图）不包含在自动工作流程中。这些步骤必须在主流程完成后，在 R 或 Python 中单独进行。

---

（该流程不包括可视化相关的r代码与hpc脚本）

(就是，在all.sh完成以后，**只有一个文档结果，没有图**)

首先，在hpc上运行大脚本 **all.sh**

（运行代码是sbatch all.sh）

然后 all.sh就会依次运行小脚本：0.sh, 1.sh, 2.sh等等，直到运行完最后一个10_1.sh

（写这行的时候脚本们还没正式命名。但总之序号就是顺序。正式版也会加序号的）

最后，在最后的文件夹10-1里，输出的文件是一个.csv

**文件包含了什么？**

跑完整个流程以后，你会得到一个 tsv 表格文件。里面的内容大概就是：

每一行 = 一条非蜗牛的 COX1 序列

有哪个样本来的（Sample）

这条序列的编号（SequenceID）

它在数据库里最像谁（TopHit，物种名字）

属于哪个门/纲/目（Phylum / Class / Order）

---
举个例子

Filename	Accession	Phylum	Class	Order

a11_seq10_blastn.txt	CP029985.1	Pseudomonadota Alphaproteobacteria Sphingomonadales		

（从excel直接复制的，将就看吧）


## 流程概览 (Workflow Outline)

0. **质控和去接头**：使用 fastp  
1. **组装蜗牛线粒体基因组**：使用 NOVOPlasty 
2. **找到 COX1 起点**：MITOS → 把基因组重排，让 COX1 在最前面  
3. **确认组装结果**：取大约 600 bp 的 COX1 片段，用 BLAST 检查是不是蜗牛  
4. **索引基因组**：为后续比对做准备（`index.array`）  
5. **比对测序数据**：把 reads 对齐到线粒体基因组，生成 BAM 文件，并统计蜗牛 mtDNA 占比（`align.bam.array`）  
6. **导出未比对序列**：得到所有非蜗牛线粒体的 reads（`export unmapped sequences`）  
7. **建 BLAST 数据库**：用 `makeblastdb`  
8. **找非蜗牛 COX1**：`tblastn` 对未比对 reads 搜索  
9. **拆分并重命名结果**：整理成单个 FASTA 文件  
10. **物种分类注释**：`blastn.array` 对 reduced NCBI mtDNA 数据库（保留最佳匹配）  
11. **整合和筛选**：只保留最佳比对结果，生成汇总表  
12–13. **下游分析**：用 Excel / R 脚本做分类统计、群落分析、系统发育树等  

---
用人话总结一下，这部分很长。当时做笔记的时候做了半个星期

**目标：从一堆DNA中找到蜗牛吃啥**

怎么实现？

获取整只蜗牛的所有dna。这些dna包含蜗牛本体的，蜗牛未消化食物的，蜗牛体内寄生虫的dna

再分别**分析dna都是源自什么物种的**

这些物种里面就有蜗牛（体内未消化）的食物了

步骤如下：

1.提取dna(这个是在实验室做的)

2.拿到完整的dna（做完这一步后，dna才能进行分析）

3.分析dna来自什么物种

**具体解释一下**，从2开始

>**2.拿到完整的dna**

有个前提，只有完整的，一整条dna才能拿去分析

众所周知，dna很长，巨长。由于现代生物学发展限制，**没办法一次性在实验室拿到一整条完整的dna链**

所以在步骤1完成后，我们现在拿到的是**一段一段的碎片dna**

现在要做的是**把这些碎片dna拼成一条**

怎么做到把这些碎片dna拼成一条？

对所有dna进行**全基因组测序**（WGS）

（什么是全基因组测序：

为了**拿到一个完整的基因组序列**，而进行的工作

因为 DNA 太长，机器一次读不了全长，所以要靠 把无数小片段拼起来，最后才能还原出整个基因组的样子。

把一个生物（比如人、蜗牛、细菌）的 整条 DNA 都切成很多很多小碎片，

然后用测序机器（比如 Illumina）去 读出这些碎片的碱基顺序（A、T、C、G）。

最后得出完成的基因组测序

所以全基因组测序（Whole Genome Sequencing, WGS）就是：

**把整个基因组打碎 → 读出来 → 再拼回去 → 拿到一个完整的基因组序列**

这个时候我们得到了一个完整的dna链

然后去识别这堆dna链来自哪里，也就是第三步的事

> **3.分析dna来自什么物种**

这个时候，我们手里有一堆，不知道从哪来的，混在一起的，但是是完整的，**能用来做分析**的dna序列

这些dna包括：

蜗牛

蜗牛的食物

蜗牛体内的寄生虫


**记得我们的目标：找到蜗牛吃啥**

所以要做的是

1.把蜗牛本体的dna扔出去（因为蜗牛不吃自己）

2.找到其他生物的dna（剩下的就大概率是蜗牛吃的生物了）

**3.分析dna（不含蜗牛）来自什么物种**

介绍一下第三步怎么实现：

**使用tblastn识别**

首先有一个东西，叫基因数据库。里面记录了每一种生物的基因与对应生物，相当于一本字典

（我知道很不严谨。但是未知的生物基因感觉不是这个github作者能面临的等级，你就这么理解吧）

tblastn 就像拿着放大镜去查字典，看这段 DNA 是不是跟某个已知生物的基因对得上。

我们手里有一堆dna（不含蜗牛）

使用**tblastn**，在这数据库里找到了一模一样（或者相似度高的）dna

然后再看看这个dna是什么物种的

就搞定了

这只是个开头。接下来要介绍具体步骤了

---

> 具体步骤

脚本最开始的序号，标的几对应的就是第几步的脚本

先回顾一下大的步骤：

1.组装dna，直到能分析的程度

2.分析dna

在这之前介绍一下用到的dna：**mtDNA**，和用到的基因：**cox1**

**mtDNA：线粒体DNA**

顾名思义，就是在生物细胞线粒体里的DNA

（不知道还记得多少生物知识了，大概说一下。dna，是生物的遗传物质，主要存在于真核生物，也就是有细胞核的生物的细胞核内）

（但是，所有生物的线粒体和叶绿体内，也有dna的存在）

（这部分dna就被叫做线粒体dna，这个项目主要分析的就是这个）

（这里是一些选择的原因

1.数量多，容易被检测

2.数据库也多，比对相对容易

3.不同生物的dna差别大，不容易混淆

4.不用特别完整也能用，↑因为差别大不容易混淆）

**cox1**
COX1 是线粒体里一个很常见的基因，全名叫 Cytochrome c oxidase subunit I。

它是细胞“发电厂”（线粒体）里呼吸链的一个零件，负责帮忙把氧气用掉、产生能量。

因为这个基因在几乎所有动物里都有，而且差别刚好够大（能区分不同物种），又差别不至于太小（不至于全都一样），所以特别适合用来当“身份证”。

科学界经常把它当作“DNA 条形码”，用来判断一条 DNA 到底是哪个物种的。

简单比喻：
COX1 就像动物身上的身份证号码，拿来比对一下，就能知道这段 DNA 来自哪种生物。

**具体步骤分为四个部分：**

一.组装蜗牛的mtDNA，和识别的准备工作：（步骤1-4）

二.过滤蜗牛本身的mtDNA(5-8)

剩下食物的DNA，寄生虫，细菌等等

三.找出其他生物的mtDNA(9-10)
就是开始比对了

四.可视化（这个看最后有没有心情写吧哈哈哈）

具体步骤就不介绍软件了，后面再单独介绍，没解释的名词啥的就是不太重要的。可以自行谷歌

再声明一次：很不严谨，只是个人笔记。不要把这些写进严谨的科研论文里面

**一.组装蜗牛的mtDNA，和识别的初步工作**

- 0.清理原始数据（用fastq）

一些前期工作，去除质量差的片段和接头→做完后数据就可以进行组装了

- 1.组装dna（NOVOPlasty）

对dna进行组装，这个时候就有一条长的，完整的dna链了

此时得到的是初始的.fasta文件

只有dna链，没有哪些部分是哪些基因

- 2.定位COX1启动子（MITOS）  


>**这个有点重要。前面怕理解不了所以没深入**
>
>前面提到cox1基因的概念：COX1 就像动物身上的身份证号码，拿来比对一下，就能知道这段 DNA 来自哪种生物
>
>所以在后续的比对中，我们需要标记这个东西
>
>总结一下原理就是：要比对的是线粒体dna（mtDNA），更具体的是，要比对mtDNA里面的cox1基因
>
>因为只用比对cox1基因，所以在这个基因前面的东西，都算是无关的。在这一步需要全部删掉
>
>用图总结一下
>
>[一个基因][两个基因][cox1基因][三个基因][四个基因]
>
>↓我们的目的
>
>[cox1基因][三个基因][四个基因]

  确认线粒体基因的起点，把 COX1 放在开头 → 标准化后的基因组序列  

2.sh ：给dna的基因做注释：标注每一个基因的名字

2-1.py：把cox1之前的东西都剪掉

- 3. 对裁剪后的dna进行注释

第2步中进行了注释：为了找出cox1

第3步再注释：因为裁剪过dna，以防万一，再注释一遍不出错

3.sh：重新注释一遍，因为2_1.py改动过整个dna的顺序，需要重新注释一下保证无误

3_1.sh：无意义，把第四步要用的文件挑出来

- 4. 一次确认：是不是蜗牛（BLAST） 

确认线粒体基因的起点，把 COX1 放在开头 → 标准化后的基因组序列 

总的来说就是先看看这些数据是不是蜗牛dna类似物，或者生物类似物。 

这一步并不是正式的比对（正式的在第5步），目的只是**确认是不是蜗牛相关**

4.sh：用 BLAST 拿前 600bp 的 COX1 去和种子序列比对，确认是不是蜗牛。

4_1.sh：过滤 BLAST 结果，把拼的实在不靠谱的序列给拎出来

> 此时，我们有了确认过没问题的“蜗牛线粒体基因组”，是我们自己的数据得出来的，确认是蜗牛的基因组

总结一下干了啥：

1.组装了dna，得到了完整的，可以用来比对的dna

2.确认了组装的dna都是来自蜗牛的，没有什么大问题

3.建立了这一批蜗牛的基因组数据库。方便后续比对原始数据里，哪些不是蜗牛

**二.过滤蜗牛本身的mtDNA(5-8)**

- 5. 比对测序数据（BWA / samtools）  

正式的比对。**找找哪些是蜗牛**

比对的目的文件是：原始的所有文件（未组装）

比对的数据库是，自己建立的数据库

 → 得到 BAM 文件

- 6. 导出没对上的 reads  

总之就是把蜗牛挑出来，这些不要

**这个时候获得了一堆，乱七八糟的，不是蜗牛的dna**

- 7. 建 BLAST 数据库（makeblastdb）  
  
把这些剩余的序列建成本地数据库，方便后续比对  
  

- 8. 找非蜗牛的 COX1（tblastn）  
  
  **找到 不是蜗牛的dna 里的cox1 ，方便比对**
  
  用 COX1 蛋白去查，看看哪些非蜗牛的 DNA 碎片长得像 COX1  

> 此时我们得到了：确认不是蜗牛的，可以用来比对物种的 cox1 基因

**三.找出其他生物的mtDNA **

开始逼得急

- 9. 拆分和整理  
  
  把多条混在一起的序列分开，改好名字，准备做分类  

- 10. 物种分类（blastn）  

  拿这些序列去数据库里比对 → 找到最像的物种，并记录分类信息（门/纲/目）  

- 11. 整合结果  

这个的脚本是10_1.sh

  把所有样本的结果合并成一个总表，只保留最靠谱的匹配  

---

**四 可视化分析**

- 12–13. 下游分析（R/Python）  
  用结果表去做：群落组成、PCoA/NMDS、UpSet 图、系统发育树 → 看蜗牛到底吃了啥、带了啥  

这个不是标准方法里的，只是写论文时候用到的图的方法

不知道要不要记录，反正就是记录一下


- 图2｜Order 水平热图（Heatmap）  
  - 展示每个样本在不同 Order 上的非蜗牛序列丰度差异。  
  - 根据 BLASTn 注释结果，汇总成样本 × Order 矩阵，用 pheatmap 画热图（行=Order，列=Sample，颜色表示相对丰度）。  
  - 目的：直观比较不同蜗牛个体在群落组成上的差异。  

- 图3｜Alluvial 流图（Alluvial diagram）  
  - 把非蜗牛序列从样本一路连到 Phylum，再连到生态类别（食源/寄生/环境）。  
  - 从 top hit 提取分类学信息 → 映射到 Phylum 和 Category → 整理成长表 → ggplot2 画 alluvial。  
  - 目的：直观展示“样本 → 分类学层级 → 生态功能”的对应关系。  

- 图4｜UpSet 图（UpSet plot）  
  - 展示哪些非蜗牛分类群是大家都有的“核心”，哪些是少数样本独有的“特有”。  
  - 把 Order 层级的计数表转 presence/absence 矩阵 → 用 ComplexUpset 画交集 → 横条表示交集大小，竖点连线表示共享样本。  
  - 目的：突出显示共享与特有的群落组成。  

- 图5｜最大似然系统发育树（Maximum Likelihood tree）  
  - 展示非蜗牛 COX1 序列的进化位置，分布在细菌、藻类、卵菌和动物等类群中。  
  - 非蜗牛 COX1 + 参考序列 → MAFFT 比对 → IQ-TREE2 构树（ModelFinder 选模型，1000 bootstrap + 1000 SH-aLRT）→ iTOL/FigTree 可视化。  
  - 目的：揭示不同来源的非蜗牛 COX1 序列在进化上的多样性和分布情况。  







---
下面就是经典参考文献了，终于写完了
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
