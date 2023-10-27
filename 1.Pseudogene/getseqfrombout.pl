
my $ref=$ARGV[0];
my $bout=$ARGV[1];
my $len=5000;
my $sid;
my %seq;
my %flag;
my @arr;
open(IN,'<',"$ref");
while($_=<IN>){
    chomp($_);
    if(index($_,">")>=0){
        @arr=split(/ /,$_);
        $sid=substr($arr[0],1,length($arr[0])-1);
        $flag{$sid}=$_;
        #print "$sid\n".$flag{$sid}."\n";
    }else{
        $seq{$sid}.=$_;
    }
}
close(IN);
#print  "$sid\n".$flag{$sid}."\n".$seq{$sid}."\n";

my $shit,$ehit;
open(IN,'<',"$bout");
while($_=<IN>){
    chomp($_);
    @arr=split(/,/,$_);
    $shit=min($arr[1],$arr[2])-$len;
    $ehit=max($arr[1],$arr[2])+$len;
    print ">$arr[0]-$shit-$ehit $arr[3]\n".substr($seq{$arr[0]},$shit-1,$ehit-$shit+1)."\n";
}
close(IN);

sub max{
	my $mx = $_[0];
	for my $e(@_) {$mx = $e if ($e > $mx);}
	return $mx;
}
sub min{
	my $mn = $_[0];
	for my $e(@_) {$mn = $e if ($e < $mn);}
	return $mn;
}


