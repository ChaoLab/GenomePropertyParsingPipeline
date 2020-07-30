#!/usr/bin/perl -w 

open IN, "checkm_result/storage/bin_stats.analyze.tsv";
%hash = ();
while (<IN>){
	chomp;
	my @tmp = split (/\t/,$_);
	my $bin = $tmp[0];
	my ($tmp1) = $tmp[1] =~ /^\{(.+?)\}$/;
	my @content = split (/\,\s/, $tmp1);
	foreach my $key (@content){
		my @tmp = split (/\:\s/,$key);
		my ($element) = $tmp[0] =~ /\'(.+?)\'/;
		my $value = $tmp[1];
		$hash{$bin}{$element} = $value;
		$gh{$element} = "1";
	}
}
close IN;

open OUT, ">bin_stats_info.xls";
my $row=join("\t", sort keys %gh);
print OUT "bin\t$row\n";
foreach my $tmp1 (sort keys %hash)
{
	print OUT $tmp1."\t";
	foreach my $tmp2 (sort keys %gh)
	{
		if (exists $hash{$tmp1}{$tmp2})
		{
			print OUT $hash{$tmp1}{$tmp2}."\t";
		}
		else
		{
			print OUT "NA";
		}
	}
	print OUT "\n";
}
close OUT;

