#!/usr/bin/perl -w

open IN, "checkm_result.txt";
%hash = ();
while (<IN>)
{
        chomp;
        if ($_ =~ /^\s+?(\S+?)\s+?(\S+?)\s+?(\S+?)\s+?(\S+?)\s+?(\S+?)\s+?(\S+?)\s+?(\S+?)\s+?(\S+?)\s+?(\S+?)\s+?(\S+?)\s+?(\S+?)\s+?(\S+?)\s+?(\S+?)\s+?(\S+?)\s+?(\S+?)\s+?$/)
        {
                my $line = "$1\t$2\t$3\t$4\t$5\t$6\t$7\t$8\t$9\t$10\t$11\t$12\t$13\t$14\t$15";
                $hash{$line} = "0";
        }
}
close IN;

open OUT, ">bin_completeness_statistic.xls";
foreach my $key (sort keys %hash){
	my @tmp = split (/\t/,$key);
	print OUT "$tmp[0]\t$tmp[-3]\t$tmp[-2]\t$tmp[-1]\n";
}
close OUT;