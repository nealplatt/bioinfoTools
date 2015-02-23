#RNP 06 Feb 2015
# findStop.pl takes a file of fasta sequences than translates them in 3 frames
#	and looks for stop codons in ANY frame.  If a seqeunce lacks a stop
#	codon, the nucleotide sequnces is printed to STDOUT in same frame as the
#	original input fasta file.  
#
#	**** This program DOES NOT check all six frames at the moment.
#
# usage: findStop.pl -fasta_in <required>

use Bio::Perl;
use Bio::SearchIO; 
use Bio::SeqIO;
use Getopt::Long;
use Bio::SeqUtils;


#sets all input values to undef
my $fasta_in	= undef;
my $help	= undef;

# get options from the command line
GetOptions('fasta_in=s'   => \$fasta_in,
           'h'	          => \$help );


#if input values not appropriate print usage statement.
if(defined $help){
	usage();
}

if( ! defined $fasta_in ){
	print "\nERROR: No fasta sequence file given\n";
	usage();
}
		

#build BioPerl object
my $inseq = Bio::SeqIO->new( 	-file => "<$fasta_in", 
				-format =>"fasta", 
				-alphabet => 'dna');

# cycle through fasta file
while (my $seq = $inseq->next_seq) {
	$fasta_header = $seq->display_id;
	$sequence = $seq->seq;
		
	#generate a seqeuence in all three frames
	$prot1 = translate_as_string($sequence);
	$prot2 = translate_as_string("-".$sequence);
	$prot3 = translate_as_string("--".$sequence);

	
	#if a frame lacks a stop codon, print out the original seq
	if($prot1 !~ m/\*/ || $prot2 !~ m/\*/ || $prot3 !~ m/\*/){
		print ">$fasta_header\n$sequence\n";
	}
		 
}



################################################################################
#			S U B R O U T I N E S				       #
################################################################################


sub usage
{
    print "\n";
	print " #################################################################\n";
	print " #                                                               #\n";	
	print " #  findStop.pl - find stop codons in 3 frames                   #\n";
	print " #                print to STDOUT if none found (per seq)        #\n";
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
	
