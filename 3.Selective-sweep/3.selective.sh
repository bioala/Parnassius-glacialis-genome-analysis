#Pi and Fst
python genomics_general-master/popgenWindows.py -w 20000 -m 10 -g All20.snp.maf005.geno01.mis1.ld01.vcf.gz -o All20.snp.maf005.geno01.mis1.ld01.10k10snp.fst.csv -f phased -T 4 -p BQTM -p BQXL --popsFile pops20.txt

#Tajima's D
vcftools --gzvcf All20.snp.maf005.geno01.mis1.ld05.vcf.gz --TajimaD 20000 --keep keep_bqtm.txt --out bqtm-ld05_20k-td
vcftools --gzvcf All20.snp.maf005.geno01.mis1.ld05.vcf.gz --TajimaD 20000 --keep keep_bqxl.txt --out bqxl-ld05_20k-td

#XPEHH
for i in {0..28};
do 
	vcftools --vcf ../xpclr/All20.snp.maf005.geno01.mis1.ld05.chrnum.vcf --recode --recode-INFO-all --chr ${i} --out All20.snp.maf005.geno01.chrnum.chr${i}
	vcftools --vcf All20.snp.maf005.geno01.chrnum.chr${i}.recode.vcf  --plink --out All20.snp.maf005.geno01.chrnum.chr${i}
	#awk 'BEGIN{OFS=" "} {print 1,".",$4/1000000,$4}' All20.snp.maf005.geno01.chrnum.chr${i}.map > All20.snp.maf005.geno01.chrnum.chr${i}.map.distance;

	vcftools --vcf All20.snp.maf005.geno01.chrnum.chr${i}.recode.vcf  --recode --recode-INFO-all --chr ${i} --keep bqtm.pops --out All20.snp.maf005.geno01.chrnum.chr${i}.bqtm
	vcftools --vcf All20.snp.maf005.geno01.chrnum.chr${i}.recode.vcf  --recode --recode-INFO-all --chr ${i} --keep bqxl.pops --out All20.snp.maf005.geno01.chrnum.chr${i}.bqxl

	selscan --xpehh --vcf All20.snp.maf005.geno01.chrnum.chr${i}.bqtm.recode.vcf --vcf-ref All20.snp.maf005.geno01.chrnum.chr${i}.bqxl.recode.vcf --map All20.snp.maf005.geno01.chrnum.chr${i}.map.distance --out All20.snp.maf005.geno01.chrnum.chr${i} --threads 24 --ehh-win 20000

	awk  '{print '${i}',$2,$3,$4,$5,$6,$7,$8}' All20.snp.maf005.geno01.chrnum.chr${i}.xpehh.out > All20.snp.maf005.geno01.chrnum.chr${i}.xpehh.csv
	sed -i 's/ /\t/g' All20.snp.maf005.geno01.chrnum.chr${i}.xpehh.csv
	norm --xpehh --files All20.snp.maf005.geno01.chrnum.chr${i}.xpehh.csv --bp-win --winsize 20000
	#<win start> <win end> <scores in win> <gt the fraction of XP-EHH scores >2> <lt the fraction of XP-EHH scores < -2> <approx percentile for gt threshold wins> <approx percentile for lt threshold wins> <max score> <min score>

done
