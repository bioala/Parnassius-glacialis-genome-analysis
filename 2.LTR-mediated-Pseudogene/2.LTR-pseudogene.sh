#get up-8kb and down-8kb of RPLP2 genes
perl get-updown-seqfromloc.pl ../0.genome/hic-genome-v2.fa rplp2.pglac434.loc.csv 8000 rplp2-8k

#RepeatMasker
RepeatMasker -nolow -pa 12 -lib Hic_asm_15-Gypsy-8551066-1339-5650.fa -dir gypsy-8k-rmout600 -cutoff 600 rplp2-8k-updown.fa

