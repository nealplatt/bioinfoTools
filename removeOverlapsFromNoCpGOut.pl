# RNP 05nov2014

###############################################

# program sorts through original RM.out files and removes hits/overlaps 

#  added to the RM.out file after going through calcDivergenceFromAlign.pl





my $usage= 

	"USAGE: removeOverlapsFromNoCpGOut.pl <original RM.out> <noCpG RM.out>\n";

my $originalRM = shift or die $usage;

my $modifiedRM = shift or die $usage;





#open all relevant files for reading in and printing out

open(ORIGINAL, "<$originalRM") or 

    	die "Can't open the original RM.out file $originalRM) to read in\n";







while($line = <ORIGINAL>){

	chomp($line);

	$line =~ s/^\s+//gi; 	#remove leading spaces

	$line =~ s/\s+/\t/gi;	#replace all spaces (multiple) with tabs

	$line =~ s/kimura=//gi;	#remove kimura=



	#split line into RM fields (tab delimted)

	(my $a,				my $b,				my $c,				my $d,		

	 my $contig,		my $contig_start, 	my $contig_end, 	my $contig_left, 	

	 my $orient, 		my $TE, 			my $TE_coord1, 		my $TE_coord2, 	

	 my $TE_coord3, 	my $unk, 			my $id_num,			my $k2p) 

	 = split('\t', $line);

	



	#create key

	$key = "$contig:$contig_start-$contig_end";

	$originalAnnotations{$key}++;

	$originalTE{$key}=$TE;



}





open(MODIFIED, "<$modifiedRM") or 

		die "Can't open modified Rm file ($modifiedRM) read in\n";



while($line = <MODIFIED>){

	chomp($line);

	$line =~ s/^\s+//gi; 	#remove leading spaces

	$line =~ s/\s+/\t/gi;	#replace all spaces (multiple) with tabs

	$line =~ s/kimura=//gi;	#remove kimura=





	#split line into modified RM fields (tab delimted)

	(my $contig,		my $contig_start,	my $contig_end,		my $length,		

	 my $TE,			my $TE_type, 		my $TE_family,	 	my $K2P) 

	 = split('\t', $line);



	#create subkey	

	$subkey = "$contig:$contig_start-$contig_end";

	

	#if the subkey is found in the original RM file print out the data, but 

	#  with the original TE annotation.

	if($originalAnnotations{$subkey}>=1){

		print "$contig\t$contig_start\t$contig_end\t$length\t$originalTE{$subkey}\t$TE_type\t$TE_family\t$K2P\n";

	}

}

























