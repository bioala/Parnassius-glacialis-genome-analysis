
#1 makeblastdb
makeblastdb -in genome.fa -dbtype nucl -parse_seqids  -out genome.fa

#2 tblastn
tblastn -query rplp2.fa -out tblastn.out -db genome.fa -outfmt 6 -evalue 1e-5 -num_threads 6

#3 merge blastout
sort -k2,2 -k9,9n tblastn.out >tblastn.sort
perl merge_align_hits.pl tblastn.sort >tblastn.sort.merge

#4 get sequence
perl getseqfrombout.pl genome.fa tblastn.sort.merge >tblastn.sort.merge.fa

#5 exonerate
exonerate  --percent 20 --model protein2genome --bestn 1000 --showquerygff no --showtargetgff yes --maxintron 20000 --showvulgar yes --ryo "%ti\t%qi\t%tS\t%qS\t%tl\t%ql\t%tab\t%tae\t%tal\t%qab\t%qae\t%qal\t%pi\n" rplp2.fa tblastn.sort.merge.fa >rplp2.exonate.out
more rplp2.exonate.out|grep vul|awk  '{print $2,$3,$4,$5,$6,$7,$8,$9,$10}'|sort -k5,5 -k6,6 >rplp2.exonate.out.csv

#6 genewise
perl getseq_bygenewise.pl tblastn.sort.merge.fa rplp2.exonate.out.csv 1000 rplp2.fa >rplp2.exonate.out.csv.fa
