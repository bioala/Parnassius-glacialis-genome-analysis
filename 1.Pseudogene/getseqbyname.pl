my $ref=$ARGV[0];
my $gname=$ARGV[1];
my $sid;
my %seq;
my %flag;
my @arr;
open(IN,'<',"$ref");
while($_=<IN>){
    chomp($_);
    if(index($_,">")>=0){
	#@arr=split(/ /,$_);
        $sid=$_;;
	#$flag{$sid}=$_;
        #print "$sid\n".$flag{$sid}."\n";
    }else{
        $seq{$sid}.=$_;
    }
}
close(IN);
#print  "$sid\n".$flag{$sid}."\n".$seq{$sid}."\n";


foreach $sid(keys(%seq)){
    if(index($sid,$gname)>0){
	print $sid."\n"; 
    	print $seq{$sid}."\n";
    }
}
