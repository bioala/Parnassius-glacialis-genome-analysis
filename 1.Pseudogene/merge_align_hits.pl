#perl merge_align_hits.pl ppoly_gr.tblastn.sort 1 8 9 5000 0
#perl $_ $sortcsv,$hstart,$hend,$overlen,$splitchar
#perl $_.pl blast 1 8 9 5000 0
#XP_014354710.1	NW_013525024.1	66.667	24	6	1	1	24	1917695	1917760	6.22e-29	29.3
#
my ($blast,$chrcol,$hstart,$hend,$linklen,$gidcol,$schar)=@ARGV;
if($schar){}else{$schar="\t";}
if($linklen){}else{$linklen=5000;}
if($gidcol){}else{$gidcol=0;}
if($chrcol){}else{$chrcol=1;}
if($hstart){}else{$hstart=8;}
if($hend){}else{$hend=9;}


mergecsv();

sub mergecsv(){
	my $m,$n,$i,$j,$flag;
	$m=$hstart;$n=$hend;$j=$chrcol;$i=$gidcol;
	my @tmp,$name;
	open(OUT,'>',"$blast.merge");
	open(IN,'<',$blast);
	$chr='';$hmin=0;
	while($_=<IN>){
		@arr=split(/$schar/,$_);
		if($arr[$j] eq $chr){
			@tmp=overlap($arr[$m],$arr[$n],$hmin,$hmax);
			if($tmp[0]>0){
				#$flag=()?$flag:$arr[$i];
				$hmin=$tmp[1];$hmax=$tmp[2];
				$flag=($tmp[3]>0)?$flag:$arr[$i];
			}else{
				if($hmin>=0&& ($chr ne '')){print  "$chr,$hmin,$hmax,$flag\n";}
				$chr=$arr[$j];$hmin=min($arr[$m],$arr[$n]);$hmax=max($arr[$m],$arr[$n]);$flag=$arr[$i];
			}
		}else{
			if($hmin>=0&& ($chr ne '')){print "$chr,$hmin,$hmax,".$flag."\n";}
			#print "$chr,$hmin,$hmax";
			$chr=$arr[$j];$hmin=min($arr[$m],$arr[$n]);$hmax=max($arr[$m],$arr[$n]);$flag=$arr[$i];
		}

	}
	
	if($hmin>=0&& ($chr ne '')){print  "$chr,$hmin,$hmax,$flag\n";}

	close(IN);
	close(OUT);

}
sub overlap(){
	my ($h1,$h2,$h3,$h4)=@_;
	my $h5,$h6,$h7,$h8; 
	$h5=(min($h1,$h2)-$linklen>=0)?(min($h1,$h2)-$linklen):0;
	$h6=max($h1,$h2)+$linklen;
	$h7=(min($h3,$h4)-$linklen>=0)?(min($h3,$h4)-$linklen):0;
	$h8=max($h3,$h4)+$linklen;

	my @hout;
	if(($h8-$h5)*($h8-$h6)<=0 or ($h7-$h5)*($h7-$h6)<=0 or ($h5-$h7)*($h5-$h8)<=0 or($h6-$h7)*($h6-$h8)<=0) {
		$hout[0]=1;
		$hout[1]=min($h1,$h2,$h3,$h4);
		$hout[2]=max($h1,$h2,$h3,$h4);
		$hout[3]=(abs($h4-$h3)>abs($h2-$h1))?1:0;
	}else{
		$hout[0]=0;
	}
	return @hout;
}

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
