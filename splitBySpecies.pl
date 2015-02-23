#RNP 06 Feb 2015
# splitBySpecies.pl takes a large sequence file and splits the reads into files
#	based on the first four characters of the fasta header.  Used for L1
#	amplicon sequencing in Spermophilus affilated species.  Kind of a 	
#	specialized instance and may not be useful in many instances.  
#
# usage: splitBySpecies.pl -fasta_in <req> -file_ext <optional>
# 
# the sequences will be printed to a file that corresponds to the first four 
#	characers of the header.  Use the -file_ext option to add the desired
#	file extension.

use Bio::SearchIO; 
use Bio::SeqIO;
use Getopt::Long;



#sets all input values to undef
my $fasta_in	= undef;
my $file_ext	= undef;
my $help	= undef;

GetOptions('fasta_in=s'   => \$fasta_in,
	   'file_ext=s'   => \$file_ext,
           'h'	          => \$help );


#if input values not appropriate print usage statement.
if(defined $help){
	usage();
}

if( ! defined $fasta_in ){
	print "\nERROR: No fasta sequence file given\n";
	usage();
}

#build the bioperl object
my $inseq = Bio::SeqIO->new( 	-file => "<$fasta_in", 
				-format =>"fasta", 
				-alphabet => 'dna');

#cycle through the sequence file
while (my $seq = $inseq->next_seq) {
	$fasta_header = $seq->display_id;
	$sequence = $seq->seq;
		
	#identifiy the species based on the first four characters 
	#  in the sequence header
	$species = substr($fasta_header, 0, 4);
	
	#open and print to the file based on the species (W/ $file_ext appended)
	open (OUT, ">>$species$file_ext") or die "$species.$file_ext cannot be opened to insert new sequence to file.\n";
        print OUT ">$fasta_header\n$sequence\n";


}


################################################################################
sub usage
{
    print "\n";
	print " #################################################################\n";
	print " #                                                               #\n";	
	print " #  splitBySpecies.pl - seperate species specific sequences      #\n";
	print " #                from larger fasta file			        #\n";
	print " #                                                               #\n";
	print " #  Required value:                                              #\n";                                              
	print " #    -fasta_in   input fasta file of sequences6                 #\n"; 
	print " #                                                               #\n";	
	print " #  Questions: neal.platt at gmail.com                           #\n";
	print " #                                                               #\n";	
	print " #                                                   6 Feb 2015  #\n";	
	print " #################################################################\n";
	
	exit;
}
		
