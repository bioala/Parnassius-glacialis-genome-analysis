#perl solo-ltr.pl genome.fasta LTR_IN.fa RepeatMasker.out 0.8 5000

my $ref=$ARGV[0];#genome.fa
my $lib=$ARGV[1];#ltr-in.fa
my $rmout=$ARGV[2];#genome.fa.out
my $lenradio=$ARGV[3];#Covering at least 80% of the LTR length
my $flanklen=$ARGV[4];#no IN within 5000bp on both sides of LTR
my $sid;
my %libseq,%refseq;

open(IN,'<',"$lib");
while($_=<IN>){
    chomp($_);
    if(index($_,">")>=0){
        $sid=$_;
	$sid=~tr/>//d;
    }else{
        $libseq{$sid}.=$_;
    }
}
close(IN);
#print  "$sid\n".$flag{$sid}."\n".$seq{$sid}."\n";
my @tmp;
open(IN,'<',"$ref");
while($_=<IN>){
	chomp($_);
    	if(index($_,">")>=0){
	@tmp=split(/[\> ]/,$_);
	$sid=$tmp[1];
	#print $sid."\n";
	}else{
	$refseq{$sid}.=$_;
	}
}
close(IN);

my @arr,$motif1,$motif2,$tsd1,$tsd2,$str,$lid;
open(IN,'<',"$rmout");
while($_=<IN>){
	chomp($_);
	@arr=split(/ +/,$_);
	#print $arr[6].",".$arr[7]."\n";
	if(index($arr[10],"_LTR")>0 && (abs($arr[7]-$arr[6])/length($libseq{$arr[10]}))>$lenradio){
	#if(index($arr[10],"_LTR")>0 ){
	#print $_;
		#print $arr[10].",".length($libseq{$arr[10]})."\n";
		$str=substr($refseq{$arr[5]},$arr[6]-1,$arr[7]-$arr[6]+1);
		$motif1=substr($refseq{$arr[5]},$arr[6]-1,2);
		$motif2=substr($refseq{$arr[5]},$arr[7]-2,2);
		$tsd1=substr($refseq{$arr[5]},$arr[6]-6,5);
		$tsd2=substr($refseq{$arr[5]},$arr[7],5);
		$lid=$arr[10];$lid=~tr/_LTR/_IN/d;

		if(($motif1 eq "TG") && ($motif2 eq "CA") && aligntsd($tsd1,$tsd2)>=3 && flankin($arr[5],($arr[6]-5000),($arr[7]+5000),$lid)<1){

		$_=~tr/*/ /d;
		print $_." $motif1 $motif2 $tsd1 $tsd2\n";;
		#print "$motif1,$motif2,$tsd1,$tsd2\n";
		#print aligntsd($tsd1,$tsd2)."\n";
		#$lid=$arr[10];$lid=~tr/_LTR/_IN/d;
		#flankin($arr[5],($arr[6]-5000),($arr[7]+5000),$lid);

		}
	}

}
close(IN);


sub aligntsd(){
my ($t1,$t2)=@_;
my $j=0;
$t1=~tr/[acgt]/[ACGT]/;
$t2=~tr/[acgt]/[ACGT]/;
for ($i=0;$i<length($t1);$i++){
	if(substr($t1,$i,1) eq substr($t2,$i,1)){
		$j++;
	}
}
return $j;
}

sub flankin(){
my ($chr,$shit,$ehit,$ltrid)=@_;
my @tmp2,$flag;
$flag=0;
#print "$chr,$shit,$ehit,$ltrid\n";
my $cmd="more $rmout|grep $chr|grep $ltrid >$ref.tmp";
system("$cmd");
open(IN2,'<',"$ref.tmp");
while($RM=<IN2>){
	@tmp2=split(/ +/,$RM);
	if(($tmp2[6]>=$shit && $tmp2[6]<=$ehit) or ($tmp2[7]>=$shit && $tmp2[7]<=$ehit)){
		if($chr eq $tmp2[5]){
		$flag=1;
		}
		#print $tmp2[6]."---------------------------".$tmp2[7]."\n";
	}
}
close(IN2);
return $flag;
}
