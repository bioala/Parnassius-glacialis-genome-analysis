#perl $0.pl test.fa loc.csv 5 outfile
#loc.csv: rplp2,t1,10,20,+
my $infile=$ARGV[0];
my $lens=$ARGV[2];
my $outfile=$ARGV[3];
my $name;
my $shit;
my $ehit;
my $str,%seq;
my $flag=0;
my @arr;

open(IN,'<',$infile);
	while($_=<IN>){
		chomp($_);
		if(index($_,'>')>=0){
		$_=~s/>//;
		#print $_."\n";		
		$str=$_;
		}else{
		$seq{$str}.=$_;
		}
	}
close(IN);

open(OUT,'>',"$outfile-updown.fa");
open(IN,'<',$ARGV[1]);
while($_=<IN>){
chomp($_);
#if(index($_,"Hic_asm")>=0){
@arr=split(/,/,$_);
$name=$arr[1];
$shit=$arr[2];
$ehit=$arr[3];
$len1=$lens;
$len2=$lens;

if($arr[4] eq "+"){
print OUT ">$name.$shit.$ehit.$lens +\n";
print OUT substr($seq{$name},$shit-$len1,$len1)."\n";
#print OUT substr($seq{$name},$shit,$ehit-$shit)."\n";
print OUT substr($seq{$name},$ehit,$len2)."\n\n";
}else{
print OUT ">$name.$shit.$ehit.$lens -\n";
print OUT seq_comp_rev(substr($seq{$name},$ehit,$len2))."\n";
#print OUT seq_comp_rev(substr($seq{$name},$shit,$ehit-$shit))."\n";
print OUT seq_comp_rev(substr($seq{$name},$shit-$len1,$len1))."\n\n";
}	
#}
}
close(IN);
close(OUT);


sub Anum(){
	my ($line)=@_;
	$m=length($line);
	$line=~s/A//g;
	$line=~s/a//g;
	$n=length($line);
	return $m-$n;
}
sub Tnum(){
	        my ($line)=@_;
	        $m=length($line);
	        $line=~s/T//g;				
		$line=~s/t//g;
	        $n=length($line);
	        return $m-$n;
}

sub seq_comp_rev{
    my $r_c_seq = &seq_com(&seq_rev(shift));
    return $r_c_seq;
}
sub seq_com{
      return shift =~ tr/AGTCagtc/TCAGtcag/r;
}
sub seq_rev{
my $temp = reverse shift;
return $temp;
}

