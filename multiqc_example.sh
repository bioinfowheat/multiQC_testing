



# go to directory with bam files
cd /cerberus/projects/chrwhe/Pieris_rapae_WGS/bamfiles

# make new directory for stats
mkdir multiqc
cd multiqc/

# get list of bam files from previous directory and save as list
# here I'm just taking the first 3 of these
ls ../*.rg.bam | head -3 > testset_bamfiles

# test a command that tries to use these in parallel
cat testset_bamfiles | parallel --dryrun '/data/programs/samtools-1.9/samtools idxstats {} > {/.}.samtools_idxstat.log'
# gives back
# /data/programs/samtools-1.9/samtools idxstats ../SRR6837585.sorted.rg.bam > SRR6837585.sorted.rg.samtools_idxstat.log
# /data/programs/samtools-1.9/samtools idxstats ../SRR6837586.sorted.rg.bam > SRR6837586.sorted.rg.samtools_idxstat.log
# /data/programs/samtools-1.9/samtools idxstats ../SRR6837587.sorted.rg.bam > SRR6837587.sorted.rg.samtools_idxstat.log

# note how the use of the {} and {./} in the paralle command parses the piped input to parallel
# allowing for efficient outfile naming

# run this test set of bam files
cat testset_bamfiles | parallel '/data/programs/samtools-1.9/samtools idxstats {} > {/.}.samtools_idxstat.log'
cat testset_bamfiles | parallel '/data/programs/samtools-1.9/samtools flagstat {} > {/.}.samtools_flagstat.log'
cat testset_bamfiles | parallel '/data/programs/samtools-1.9/samtools stats {} > {/.}.samtools_stats.log'

# then collect all the output files using multiqc
multiqc .

# download the resulting multiqc_report.html and view it
scp ....
