#!/usr/bin/perl -w 

my $work_dir = "/slowdata/data1/SWIR/RefineM";
my @arr = qw/SWIR/; 

foreach (@arr){
	system ("cp $work_dir/$_/refinem_VB_mean_coverage.txt tmp_${_}_refinem_VB_mean_coverage.txt");
}
system ("cat tmp_*_refinem_VB_mean_coverage.txt > bin_mean_coverage.txt");
system ("rm tmp_*_refinem_VB_mean_coverage.txt");

%Map = (); #Store Map
open IN, "Map.txt";
while (<IN>){
	chomp;
	$_ =~ s/\.fa//g; #delete .fa 
	my @tmp = split (/\t/,$_);
	$Map{$tmp[0]} = $tmp[1];
}
close IN;

%Bin_mean_coverage = (); 
open IN, "bin_mean_coverage.txt";
while(<IN>){
	chomp;
	my @tmp = split (/\t/,$_);
	if (exists $Map{$tmp[0]}){
		$Bin_mean_coverage{$Map{$tmp[0]}} = $tmp[1];
	}
}
close IN;

open OUT, ">bin_mean_coverage.xls";
foreach my $key (sort keys %Bin_mean_coverage){
	my $Bin_mean_coverage_Value = $Bin_mean_coverage{$key};
	my $Bin_mean_coverage_Value_2digits = sprintf "%.2f",$Bin_mean_coverage_Value;
	print OUT "$key\t$Bin_mean_coverage_Value_2digits\n";
}
close OUT;

system ("rm bin_mean_coverage.txt");

