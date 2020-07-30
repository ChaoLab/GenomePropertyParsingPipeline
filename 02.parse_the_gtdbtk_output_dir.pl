#!/usr/bin/perl

use strict;
use warnings;

my $pwd = `pwd`; chomp $pwd; 
print $pwd."\n";

my %Arc_bin = (); # arc_bin => taxonomy info
open IN, "gtdbtk_output_dir/gtdbtk.ar122.classification_pplacer.tsv";
while (<IN>){
	chomp;
	my @tmp = split (/\t/);
	$Arc_bin{$tmp[0]} = $tmp[1];
}
close IN;

my %Bac_bin = (); # bac_bin => taxonomy info
open IN, "gtdbtk_output_dir/gtdbtk.bac120.classification_pplacer.tsv";
while (<IN>){
	chomp;
	my @tmp = split (/\t/);
	$Bac_bin{$tmp[0]} = $tmp[1];
}
close IN;

`mkdir genomes/genomes_arc`;
foreach my $arc_bin (sort keys %Arc_bin){
	`ln -s $pwd/genomes/$arc_bin.fasta $pwd/genomes/genomes_arc/$arc_bin.fasta`;
}

`mkdir genomes/genomes_bac`;
foreach my $bac_bin (sort keys %Bac_bin){
	`ln -s $pwd/genomes/$bac_bin.fasta $pwd/genomes/genomes_bac/$bac_bin.fasta`;
}



