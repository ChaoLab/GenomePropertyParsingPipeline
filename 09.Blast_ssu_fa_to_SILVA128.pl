#!/usr/bin/perl

use strict;
use warnings;

my $input = "Bin_ssu.fa";
my $db = 128;
my $TarSeq = 1;

`blastn -db /slowdata/databases/SILVA/SILVA_128_SSUParc/SILVA_128_SSUParc_tax_silva.fasta -query $input -out $input.SILVA${db}.e10.blastn -evalue 1e-10 -max_target_seqs ${TarSeq} -num_threads 80 -outfmt 6`;
`perl /slowdata/scripts/scripts/BlastTools/silvaTaxonAppend.pl -blast $input.SILVA${db}.e10.blastn -out $input.silva_tax.txt -db /slowdata/databases/SILVA/SILVA_128_SSUParc/SILVA_${db}_SSUParc_tax_silva.fasta`;
`perl /slowdata/scripts/scripts/ChaoScripts/extract_fas_from_blast_re_v2.0_byZhichaoZhou.pl  -i $input.SILVA${db}.e10.blastn -q $input -x F`;
`cat Bin_ssu.fa.silva_tax.txt | cut -f 1,3 >  Bin_ssu_taxonomy.xls`;

