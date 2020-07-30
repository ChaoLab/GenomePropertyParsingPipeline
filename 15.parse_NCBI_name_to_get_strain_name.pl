#!/usr/bin/perl -w 

my %rank = ();
$rank{"d"} = "Domain";
$rank{"p"} = "Phylum";
$rank{"c"} = "Class";
$rank{"o"} = "Order";
$rank{"f"} = "Family";
$rank{"g"} = "Genus";
$rank{"s"} = "Species";

%GnTax = ();
open IN, "Bin2Curated_tax.result.txt";
while (<IN>){
	chomp;
	my @tmp = split (/\t/,$_);
	$GnTax{$tmp[0]} = $tmp[1];
	}
close IN;

%out = ();
foreach my $key (sort keys %GnTax){
	my $strain_name = "";
	my $tail = ""; my $BorA = "";
	my @tmp  = split (/\;/, $GnTax{$key});
	foreach my $rank_info (@tmp){
		if ($rank_info =~ /^\S\_\_\S/){
			$tail = $rank_info;
		}
	}
	if ($GnTax{$key} =~ /^d\_\_Bacteria/){
		$BorA = "bacterium";
	}else{
		$BorA = "archaeon";
	}
	my ($rank_letter, $tail_name) = $tail =~ /^(\S)\_\_(.+)/;
	if ($rank_letter eq "g"){
		$strain_name = "$tail_name sp\. $key \[Genus\]";
	}else{
		$strain_name = "$tail_name $BorA $key \[$rank{$rank_letter}\]";
	}
	$out{$key} = $strain_name;
	
}	

open OUT, ">strain_name.xls";
foreach my $key (sort keys %out){
	print OUT "$key\t$out{$key}\n";
}
close OUT;
