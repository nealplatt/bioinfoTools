#RNP 06 Feb 2015
# QC_L1.pl takes a set of seqeunces and culls those that do not have a 
#  corresponding hit in a blast table.  This is a way to verify that all
#  sequences in the final output file are expected.  Ex. This script was used
#  to verify that all the amplicons in a seqeunce file were from the region of
#  L1 that was expected.  All output goes to stdout.

# usage: QC_L1.pl --blast <req> --fasta_in <req> --min_length <optional>

# in addition this program will RC necessary sequences and removes ~10bp of
#   adapter that appear to be present on the 5' end (when RC'd).


use Bio::SearchIO; 
use Bio::SeqIO;
use Getopt::Long;

#sets all input values to undef

my $blast_in 	= undef;
my $fasta_in	= undef;
my $help	= undef;
my $min_length	= undef;


# get command line options
GetOptions('blast=s'		=> \$blast_in,
	   'fasta_in=s'  	=> \$fasta_in,
	   'min_length=n'	=> \$min_length,
           'h'	         	=> \$help );



#if input values not appropriate print usage statement.
if(defined $help){
	usage();
}

if( ! defined $blast_in ){
	print "\nERROR: No blast input file given\n";
	usage();
}

if( ! defined $fasta_in ){
	print "\nERROR: No fasta sequence file given\n";
	usage();
}


#sort through fasta file and store it in memory
my $inseq = Bio::SeqIO->new(-file   => "<$fasta_in", -format =>"fasta");

while (my $seq = $inseq->next_seq) {
	$fasta_header = $seq->display_id;
	$sequence{$fasta_header} = $seq->seq;

}

#cycle through blast file with the goal of only printing out "quality" seqs.
open (BLAST_IN, "<$blast_in") or die "(BLAST) $blast_in cannot be opened.\n";

while(<BLAST_IN>) {
	chomp;
	($query,        $subject,       $percent_id, 
         $align_length, $mismatches,    $gap_openings, 
         $query_start,  $query_end,     $subj_start, 
         $subj_end,     $e_value,       $bit_score    ) = split;
        

	# if orientied in oposite direction, reverse complement
        if( $subj_end < $subj_start ){
           $sequence{$query} =revTrans($sequence{$query});
        }        

	#get rid of that adapter looking portion AAAACAAA at the begininning
	$sequence{$query} = substr( $sequence{$query}, 9);

	# remove sequences less than $length (if specified)	
	if(length($sequence{$query}) >= $min_length){
		print ">$query\n$sequence{$query}\n"
	}
	
}



################################################################################
#			S U B R O U T I N E S				       #
################################################################################

sub revTrans
{
	local($sequence);
	
	$sequence = $_[0];	
	$sequence = reverse $sequence;
	$sequence =~ tr/ACGT/TGCA/;
	return $sequence;
}

#------------------

sub usage
{
    print "\n";
	print " #################################################################\n";
	print " #                                                               #\n";	
	print " #  QC_L1.pl - a program to clean up sequences from L1 amplicons #\n";
	print " #                                                               #\n";
	print " #  Required values:                                             #\n";                                              
	print " #    -blast     input blast file (tab format [6])               #\n"; 
	print " #    -fasta_in  input of raw fasta readsts                      #\n";
	print " #                                                               #\n";	
	print " #  Optional values:                                             #\n";
	print " #    -min_length minimum length sequence accepted               #\n";
	print " #                                                               #\n";
	print " #  Questions: neal.platt at gmail.com                           #\n";
	print " #                                                               #\n";	
	print " #                                                   6 Feb 2015  #\n";	
	print " #################################################################\n";
	
	exit;
}	

