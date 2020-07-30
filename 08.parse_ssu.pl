#!/usr/bin/perl -w 

my %tax = ();
open IN, "Bin_tax.list";
while (<IN>){
	chomp;
	my @tmp = split (/\t/,$_);
	$tax{$tmp[0]} = $tmp[1];
}
close IN;

%out = ();
open IN, "ls checkm_result/ssu_finder/*/ssu_summary.tsv | ";
while (<IN>){
	chomp;
	my ($fa) = $_ =~ /ssu_finder\/(.+?)\_result/;
	my $dir = $_; $dir =~ s/\/ssu_summary\.tsv//g;
	my %hit = ();
	open INN, "$_";
	OUTTER1: while (<INN>){
		chomp;
		if (!/^Bin/){
			my @tmp = split (/\t/,$_) or last OUTTER1;
			if (uc ($tmp[2]) eq uc($tax{$fa}) and !exists $hit{$fa} ){
				$hit{$fa}[0] = $tmp[1]; #scaffold id
				$hit{$fa}[1] = $tmp[6]; # 16S hit length
			}elsif(uc ($tmp[2]) eq uc($tax{$fa}) and exists $hit{$fa}){
				if ($tmp[6] > $hit{$fa}[1]){
					$hit{$fa}[0] = $tmp[1];
					$hit{$fa}[1] = $tmp[6];
				}
			}
		}

	}
	close INN;
	if (%hit){
		#Store ssu.fna
		my %ssu = ();my $head = "";
		open _IN, "$dir/ssu.fna" or die ; 
		while (<_IN>){
			chomp;
			if (/>/){
				$head = $_;
				$ssu{$head} = "";
			}else{
				$ssu{$head} .= $_;
			}
		}
		close _IN;
		#filter %ssu, print hit into OUT
		foreach my $key (sort keys %ssu){
			#print "$key\n";
			my $key_new = $key;
			$key_new =~ s/>//g;$key_new =~ s/$fa//;$key_new =~ s/\&\&//g;
			#print "$key_new\n";
			if ($key_new eq $hit{$fa}[0] and length ($ssu{$key}) >= 300){
				$out{">".$fa} = $ssu{$key};
			}
		} 
	}
}
close IN;

open OUT, ">Bin_ssu.fa";
foreach my $key (sort keys %out){
	print OUT "$key\n$out{$key}\n";
}
close OUT;
