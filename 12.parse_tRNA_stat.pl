#!/usr/bin/perl -w 

open IN, "ls tRNAscan_result/*.tRNA.stat | ";
my %stat_summmary = ();
my @tRNAlist = ('tRNAs decoding Standard 20 AA','Selenocysteine tRNAs','Possible suppressor tRNAs','tRNAs with undetermined/unknown isotypes','Predicted pseudogenes','Total tRNAs');
while (<IN>){
	chomp;
	open INN, "$_";
	my ($fa) = $_ =~ /^tRNAscan_result\/(.+?)\.tRNA\.stat/;
	while (<INN>){
		chomp;
		my $line = $_;
		if (/$tRNAlist[0]/){
			my ($num) = $line =~ /^.*\:\s*?(\d+)$/;
			$stat_summmary{$fa} = $num;
		}elsif(/$tRNAlist[1]/){
			my ($num) = $line =~ /^.*\:\s*?(\d+)$/;
			$stat_summmary{$fa} .= "\t".$num;
		}elsif(/$tRNAlist[2]/){
			my ($num) = $line =~ /^.*\:\s*?(\d+)$/;
			$stat_summmary{$fa} .= "\t".$num;
		}elsif(/$tRNAlist[3]/){
			my ($num) = $line =~ /^.*\:\s*?(\d+)$/;		
			$stat_summmary{$fa} .= "\t".$num;
		}elsif(/$tRNAlist[4]/){
			my ($num) = $line =~ /^.*\:\s*?(\d+)$/;		
			$stat_summmary{$fa} .= "\t".$num;
		}elsif(/$tRNAlist[5]/){
			my ($num) = $line =~ /^.*\:\s*?(\d+)$/;
			$stat_summmary{$fa} .= "\t".$num;
		}
	}
	close INN;
}
close IN;

#print out head
open OUT, ">tRNA_stat_summary.xls";
print OUT "bin\t$tRNAlist[0]\t$tRNAlist[1]\t$tRNAlist[2]\t$tRNAlist[3]\t$tRNAlist[4]\t$tRNAlist[5]\n";

#print out content
foreach my $key (sort keys %stat_summmary){
	print OUT "$key\t$stat_summmary{$key}\n";
}
close OUT;
