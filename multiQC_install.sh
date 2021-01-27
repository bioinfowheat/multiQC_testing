# install locally
pip install multiqc

multiqc --version
# multiqc, version 1.7

wget http://multiqc.info/SBW/data/basic_RNAseq.tar.gz
tar xzf basic_RNAseq.tar.gz
cd basic_RNAseq
multiqc .
# or can run in the folder above this as well, no problems.


# https://multiqc.info/docs/#bamtools



# bamtools looks good for bam file QC
/data/programs/bamtools-2.5.1/bin/bamtools stats -in SRR6837609.sorted.rg.bam

**********************************************
Stats for BAM file(s):
**********************************************

Total reads:       23472852
Mapped reads:      22435608     (95.5811%)
Forward strand:    12275254     (52.2955%)
Reverse strand:    11197598     (47.7045%)
Failed QC:         0    (0%)
Duplicates:        0    (0%)
Paired-end reads:  23472852     (100%)
'Proper-pairs':    20505426     (87.3581%)
Both pairs mapped: 21916428     (93.3693%)
Read 1:            11736426
Read 2:            11736426
Singletons:        519180       (2.21183%)

# now scale up
cd /cerberus/projects/chrwhe/Pieris_rapae_WGS/bamfiles
mkdir multiqc
cd multiqc/

ls ../*.rg.bam | head
../SRR6837585.sorted.rg.bam
../SRR6837586.sorted.rg.bam
../SRR6837587.sorted.rg.bam
../SRR6837588.sorted.rg.bam
../SRR6837589.sorted.rg.bam
../SRR6837590.sorted.rg.bam
../SRR6837591.sorted.rg.bam
../SRR6837592.sorted.rg.bam
../SRR6837593.sorted.rg.bam
../SRR6837594.sorted.rg.bam
ls ../*.rg.bam | head -3 > testset_bamfiles
mkdir bamtools
cat testset_bamfiles | parallel --dryrun '/data/programs/bamtools-2.5.1/bin/bamtools stats -in {} > bamtools/{/.}.stats.log'
/data/programs/bamtools-2.5.1/bin/bamtools stats -in ../SRR6837585.sorted.rg.bam > bamtools/SRR6837585.sorted.rg.stats.log
/data/programs/bamtools-2.5.1/bin/bamtools stats -in ../SRR6837586.sorted.rg.bam > bamtools/SRR6837586.sorted.rg.stats.log
/data/programs/bamtools-2.5.1/bin/bamtools stats -in ../SRR6837587.sorted.rg.bam > bamtools/SRR6837587.sorted.rg.stats.log
# command line looks good, for naming output, etc.
cat testset_bamfiles | parallel '/data/programs/bamtools-2.5.1/bin/bamtools stats -in {} > {/.}.bamtools_stats.log'

head bamtools/*log
==> bamtools/SRR6837585.sorted.rg.stats.log <==

**********************************************
Stats for BAM file(s):
**********************************************

Total reads:       17682914
Mapped reads:      16907391     (95.6143%)
Forward strand:    9246731      (52.2919%)
Reverse strand:    8436183      (47.7081%)
Failed QC:         0    (0%)

==> bamtools/SRR6837586.sorted.rg.stats.log <==

**********************************************
Stats for BAM file(s):
**********************************************

Total reads:       24388376
Mapped reads:      22931632     (94.0269%)
Forward strand:    12939145     (53.0546%)
Reverse strand:    11449231     (46.9454%)
Failed QC:         0    (0%)

==> bamtools/SRR6837587.sorted.rg.stats.log <==

**********************************************
Stats for BAM file(s):
**********************************************

Total reads:       18274564
Mapped reads:      17469782     (95.5962%)
Forward strand:    9554097      (52.2808%)
Reverse strand:    8720467      (47.7192%)
Failed QC:         0    (0%)
chrwhe@duke:/cerberus/projects/chrwhe/Pieris_rapae_

# now try it
multiqc .

SRR6837585.sorted.rg.stats.log
cp SRR6837585.sorted.rg.stats.log SRR6837585.sorted.rg.stats.txt


# samtools
cat testset_bamfiles | parallel 'samtools idxstats {} > {/.}.idxstat.log'
cat testset_bamfiles | parallel 'samtools flagstat {} > {/.}.flagstat.log'

cat testset_bamfiles | parallel 'samtools stats {} > {/.}.stats.log'

# old version
head SRR6837586.sorted.rg.stats.log

**********************************************
Stats for BAM file(s):
**********************************************

Total reads:       24388376
Mapped reads:      22931632     (94.0269%)
Forward strand:    12939145     (53.0546%)
Reverse strand:    11449231     (46.9454%)
Failed QC:         0    (0%)

# new version of samtools
cat testset_bamfiles | parallel '/data/programs/samtools-1.9/samtools stats {} > {/.}.stats.log'
# This file was produced by samtools stats (1.9+htslib-1.9) and can be plotted using plot-bamstats
# This file contains statistics for all reads.
# The command line was:  stats ../SRR6837586.sorted.rg.bam
# CHK, Checksum [2]Read Names   [3]Sequences    [4]Qualities
# CHK, CRC32 of reads which passed filtering followed by addition (32bit overflow)
CHK     261d2b28        e6b3f1e7        beeb9652
# Summary Numbers. Use `grep ^SN | cut -f 2-` to extract this part.
SN      raw total sequences:    24388376
SN      filtered sequences:     0
SN      sequences:      24388376

multiqc -f -x basic* .
# new versions of software matters!!!!!
# removing old log files

# fresh run
cat testset_bamfiles | parallel '/data/programs/samtools-1.9/samtools idxstats {} > {/.}.samtools_idxstat.log'
cat testset_bamfiles | parallel '/data/programs/samtools-1.9/samtools flagstat {} > {/.}.samtools_flagstat.log'
cat testset_bamfiles | parallel '/data/programs/samtools-1.9/samtools stats {} > {/.}.samtools_stats.log'
cat testset_bamfiles | parallel '/data/programs/bamtools-2.5.1/bin/bamtools stats -in {} > {/.}.bamtools_stats.log'



scp chrwhe@duke.zoologi.su.se:/cerberus/projects/chrwhe/Pieris_rapae_WGS/bamfiles/multiqc/*html .

# feature counts looks interesting
http://bioinf.wehi.edu.au/featureCounts/

/cerberus/projects/chrwhe/software/subread-2.0.1-Linux-x86_64/bin/featureCounts -p -o counts.featurecounts.summary ../SRR6837585.sorted.rg.bam

featureCounts -p -t exon -g gene_id -a annotation.gtf -o counts.txt mapping_results_PE.bam

# as does
https://deeptools.readthedocs.io/en/develop/
