#!/usr/bin/perl

use strict;
use warnings;

my %GTDB2NCBI_tax = (); # GTDB g__XXX => [0] NCBI g__XXX; [1] percentage 
open IN, "NCBIvsR86_Bacteria.txt";
while (<IN>){
	chomp;
	if (!/^#/){
		my @tmp = split (/\t/);
		if ($tmp[3] =~ /\,/){
			my @tmp_tmp3 = split (/\,\s/,$tmp[3]);
			foreach my $key (@tmp_tmp3){
				my ($GTDB_tax,$perc) = $key =~ /^(.+?)\s\((.+?)\%\)$/; $perc = $perc / 100;
				$GTDB2NCBI_tax{$GTDB_tax}[0] = $tmp[0];
				$GTDB2NCBI_tax{$GTDB_tax}[1] = $perc;
				
			}	
		}else{
			my ($GTDB_tax,$perc) = $tmp[3] =~ /^(.+?)\s\((.+?)\%\)$/; $perc = $perc / 100;
			$GTDB2NCBI_tax{$GTDB_tax}[0] = $tmp[0];
			$GTDB2NCBI_tax{$GTDB_tax}[1] = $perc;
		}
	}
}
close IN;

open IN, "NCBIvsR86_Archaea.txt";
while (<IN>){
	chomp;
	if (!/^#/){
		my @tmp = split (/\t/);
		if ($tmp[3] =~ /\,/){
			my @tmp_tmp3 = split (/\,\s/,$tmp[3]);
			foreach my $key (@tmp_tmp3){
				my ($GTDB_tax,$perc) = $key =~ /^(.+?)\s\((.+?)\%\)$/; $perc = $perc / 100;
				$GTDB2NCBI_tax{$GTDB_tax}[0] = $tmp[0];
				$GTDB2NCBI_tax{$GTDB_tax}[1] = $perc;
				
			}	
		}else{
			my ($GTDB_tax,$perc) = $tmp[3] =~ /^(.+?)\s\((.+?)\%\)$/; $perc = $perc / 100;
			$GTDB2NCBI_tax{$GTDB_tax}[0] = $tmp[0];
			$GTDB2NCBI_tax{$GTDB_tax}[1] = $perc;
		}
	}
}
close IN;

foreach my $key (sort keys %GTDB2NCBI_tax){
	if ($GTDB2NCBI_tax{$key}[1] eq "0"){
		$GTDB2NCBI_tax{$key}[1] = "0.00";
	}
	if ($GTDB2NCBI_tax{$key}[1] eq "1"){
		$GTDB2NCBI_tax{$key}[1] = "1.00";
	}
}

my %Bin2GTDB_tax = (); #M_DeepCast_65m_m1_070  => d__Archaea;p__Crenarchaeota;c__Nitrososphaeria;o__Nitrososphaerales;f__Nitrosopumilaceae;g__Nitrosotenuis;s__
my $pwd = `pwd`; chomp $pwd;
open IN, "$pwd/gtdbtk_output_dir/gtdbtk.ar122.classification_pplacer.tsv";
while (<IN>){
	chomp;
	my @tmp = split (/\t/);
	$Bin2GTDB_tax{$tmp[0]} = $tmp[1];
}
close IN;

open IN, "$pwd/gtdbtk_output_dir/gtdbtk.bac120.classification_pplacer.tsv";
while (<IN>){
	chomp;
	my @tmp = split (/\t/);
	$Bin2GTDB_tax{$tmp[0]} = $tmp[1];
}
close IN;

#use the hash of  : my %GTDB2NCBI_tax = (); # GTDB g__XXX => [0] NCBI g__XXX; [1] percentage 
my $cut_v =  0.5; # the cut value for determine of taxa level
my %Bin2NCBI_tax = ();
foreach my $bin (sort keys %Bin2GTDB_tax){
	my @NCBI_tax = ();
	my $GTDB_tax = $Bin2GTDB_tax{$bin};
	my @Rank_GTDB_tax = split (/\;/,$GTDB_tax);
	foreach my $rank (@Rank_GTDB_tax){
		if ($rank =~ /d\_\_/){
			push @NCBI_tax, $rank;
		}elsif($rank =~ /^p\_\_\S/ and !exists $GTDB2NCBI_tax{$rank}[1]){
			push @NCBI_tax, "p\_\_";
		}elsif($rank =~ /^c\_\_\S/ and !exists $GTDB2NCBI_tax{$rank}[1]){
			push @NCBI_tax, "c\_\_";
		}elsif($rank =~ /^o\_\_\S/ and !exists $GTDB2NCBI_tax{$rank}[1]){
			push @NCBI_tax, "o\_\_";
		}elsif($rank =~ /^f\_\_\S/ and !exists $GTDB2NCBI_tax{$rank}[1]){
			push @NCBI_tax, "f\_\_";
		}elsif($rank =~ /^g\_\_\S/ and !exists $GTDB2NCBI_tax{$rank}[1]){
			push @NCBI_tax, "g\_\_";
		}elsif($rank =~ /^s\_\_\S/ and !exists $GTDB2NCBI_tax{$rank}[1]){
			push @NCBI_tax, "s\_\_";
		}elsif($rank =~ /^p\_\_/ and !exists $GTDB2NCBI_tax{$rank}[1]){
			push @NCBI_tax, "p\_\_";
		}elsif($rank =~ /^c\_\_/ and !exists $GTDB2NCBI_tax{$rank}[1]){
			push @NCBI_tax, "c\_\_";
		}elsif($rank =~ /^o\_\_/ and !exists $GTDB2NCBI_tax{$rank}[1]){
			push @NCBI_tax, "o\_\_";
		}elsif($rank =~ /^f\_\_/ and !exists $GTDB2NCBI_tax{$rank}[1]){
			push @NCBI_tax, "f\_\_";
		}elsif($rank =~ /^g\_\_/ and !exists $GTDB2NCBI_tax{$rank}[1]){
			push @NCBI_tax, "g\_\_";
		}elsif($rank =~ /^s\_\_/ and !exists $GTDB2NCBI_tax{$rank}[1]){
			push @NCBI_tax, "s\_\_";
		}elsif($rank =~ /^p\_\_\S/ and $GTDB2NCBI_tax{$rank}[1] >= $cut_v){
			push @NCBI_tax, $rank;
		}elsif($rank =~ /^p\_\_\S/ and $GTDB2NCBI_tax{$rank}[1] < $cut_v || $rank eq "p\_\_" ){
			push @NCBI_tax, "p\_\_";
		}elsif($rank =~ /^c\_\_\S/ and $GTDB2NCBI_tax{$rank}[1] >= $cut_v){
			push @NCBI_tax, $rank;
		}elsif($rank =~ /^c\_\_\S/ and $GTDB2NCBI_tax{$rank}[1] < $cut_v || $rank eq "c\_\_" ){
			push @NCBI_tax, "c\_\_";
		}elsif($rank =~ /^o\_\_\S/ and $GTDB2NCBI_tax{$rank}[1] >= $cut_v){
			push @NCBI_tax, $rank;
		}elsif($rank =~ /^o\_\_\S/ and $GTDB2NCBI_tax{$rank}[1] < $cut_v || $rank eq "o\_\_" ){
			push @NCBI_tax, "o\_\_";
		}elsif($rank =~ /^f\_\_\S/ and $GTDB2NCBI_tax{$rank}[1] >= $cut_v){
			push @NCBI_tax, $rank;
		}elsif($rank =~ /^f\_\_\S/ and $GTDB2NCBI_tax{$rank}[1] < $cut_v || $rank eq "f\_\_" ){
			push @NCBI_tax, "f\_\_";
		}elsif($rank =~ /^g\_\_\S/ and $GTDB2NCBI_tax{$rank}[1] >= $cut_v){
			push @NCBI_tax, $rank;
		}elsif($rank =~ /^g\_\_\S/ and $GTDB2NCBI_tax{$rank}[1] < $cut_v || $rank eq "g\_\_" ){
			push @NCBI_tax, "g\_\_";
		}elsif($rank =~ /^s\_\_\S/ and $GTDB2NCBI_tax{$rank}[1] >= $cut_v){
			push @NCBI_tax, $rank;
		}elsif($rank =~ /^s\_\_\S/ and $GTDB2NCBI_tax{$rank}[1] < $cut_v || $rank eq "s\_\_" ){
			push @NCBI_tax, "s\_\_";
		}
	}
	$Bin2NCBI_tax{$bin} = join ("\;",@NCBI_tax);
}

open OUT, ">Bin2NCBI_tax.result.txt";
foreach my $bin (sort keys %Bin2NCBI_tax){
	print OUT "$bin\t$Bin2NCBI_tax{$bin}\n";
}
close OUT;

open OUT, ">Bin2GTDB_tax.result.txt";
foreach my $bin (sort keys %Bin2GTDB_tax){
	print OUT "$bin\t$Bin2GTDB_tax{$bin}\n";
}
close OUT;
