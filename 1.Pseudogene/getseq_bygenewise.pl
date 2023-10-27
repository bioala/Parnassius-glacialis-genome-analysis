#get sequences from merghit and genome files

my ($genome,$merghit,$linklen,$famfa)=@ARGV;
my $gid,@arr,%gseq;

open(IN,'<',$genome);
while($_=<IN>){
    chomp($_);
    if(index($_,">")>=0){
	if(index($_,' ')>0){
		@arr=split(/ /,$_);
		$gid=substr($arr[0],1,length($arr[0])-1);
	}else{
        	$gid=substr($_,1,length($_)-1);
	}
    }else{
        $gseq{$gid}.=$_;
    }
}
close(IN);


my $shit,$ehit,$str;
open(IN,'<',$merghit);
while($_=<IN>){
	chomp($_);
	@arr=split(/[, ]/,$_);
	$shit=($arr[7] eq '+')?$arr[5]:$arr[6];
	$ehit=($arr[7] eq '+')?$arr[6]:$arr[5];
	$shit=(($shit-$linklen)>0)?($shit-$linklen):0;
	$ehit=$ehit+$linklen;

	open(OUT,'>',"cds.fa");
	print OUT ">".$arr[4]."-$shit-$ehit-".$arr[0]."\n";
	$str=substr($gseq{$arr[4]},$shit,$ehit-$shit+1);
	print OUT "$str\n";
	close(OUT);

	system("perl getseqbyname.pl $famfa ".$arr[0]." >pep.fa ");
	if($arr[7] eq '+'){
	system("genewise pep.fa cds.fa -tfor -pep  -silent -quiet ");
	}else{
	system("genewise pep.fa cds.fa -trev -pep  -silent -quiet ");
	}
}
close(IN);

