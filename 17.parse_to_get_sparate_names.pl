#!/usr/bin/perl

use strict;
use warnings;


open IN, "strain_name.xls";
while (<IN>){
	chomp;
	my @tmp = split (/\t/,$_);
	my ($item1,$item2) = $tmp[1] =~ /^(.+)\s(.+?)\s.+?\s\[.+?\]$/;
	print $item1."\t".$item2."\n";
}
close IN;