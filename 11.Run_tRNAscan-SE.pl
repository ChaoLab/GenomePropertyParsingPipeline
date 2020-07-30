#!/usr/bin/perl

use strict;
use warnings;

`mkdir tRNAscan_result`;
open IN, "ls genomes/*.fasta|";
open OUT, ">11.run_tmp.sh";
while (<IN>){
	chomp;
	my ($bin) = $_ =~ /genomes\/(.+?)\.fasta/;
	my $cmd = "tRNAscan-SE -G -q genomes/$bin.fasta -o tRNAscan_result/$bin.tRNA.output -m tRNAscan_result/$bin.tRNA.stat";
	print OUT "$cmd\n";
}
close IN;
close OUT;

`mkdir tmp_parallel`;
`cat 11.run_tmp.sh | parallel -j 60 --tmpdir ./tmp_parallel`;
`rm 11.run_tmp.sh`;
`rm -r tmp_parallel`;
