#!/usr/bin/perl -w 

open IN, "tRNA_stat_summary.xls";
my %tRNA = (); 
while (<IN>){
	chomp;
	if (!/^bin/){
		my @tmp = split (/\t/);
		$tRNA{$tmp[0]} = 1;
	}
}
close IN;

my %Gn_id = ();
open IN, "ls genomes/*.fasta |";
while (<IN>){
	chomp;
	my ($gn_id) = $_ =~ /genomes\/(.+?)\.fasta/;
	$Gn_id{$gn_id} = 1;
}
close IN;

foreach my $gn_id (sort keys %Gn_id){
	if (!exists $tRNA{$gn_id}){
		print "$gn_id\n";
	}
}
