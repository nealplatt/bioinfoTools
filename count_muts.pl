#script to cycle through an alignment and count the number of base changes
# at each position.  Takes an aligned fasta file.  Sequences must be the same
# length.

use Bio::SearchIO; 
use Bio::SeqIO;
use Getopt::Long;

#sets all input values to undef
my $align_in 	= undef;
my $counts_out 	= undef;
my $help	= undef;

GetOptions('in=s'	 => \$align_in,
           'h'	     => \$help );

#if input values not appropriate print usage statement.
if(defined $help){
	usage();
}

if( ! defined $align_in, ){
	print "\nERROR: No genome file given\n";
	usage();
}


#load seqeunces into an array
my $inseq = Bio::SeqIO->new(-file   => "<$align_in", -format =>"fasta");
my %genome;

#set variable to count num of seqeunces in the file
$i=0;
	
#import the fasta sequences one-by-one	
while (my $seq = $inseq->next_seq) {
	$seq_header = $seq->display_id;
	$sequence = $seq->seq;
	
	#make all positions uppercase
	$sequence=uc $sequence;
	
	#go through the sequence position-by-position and build 2d array
	for ($nuc_position=0; $nuc_position<length($sequence); $nuc_position++){
	
	    $sequence[$i][$nuc_position]=substr $sequence, $nuc_position, 1;
	
	}

    #iterate the count of sequences by one	
	$i++;
}	
	
#the length of the sequences is queal to the last nucleotide position
$maxLength=$nuc_position;

#prints headers to output file
print "position\tsubstitutions\n";

#iterate throught the length of the alignment to id uniq nucs at each position
for ($nuc_position=0; $nuc_position<$maxLength; $nuc_position++){
    
    #initialize a hash to store nucs at each position
    my %nucs;
    
    #for each position, cycle through all sequences in the file
    for ($j=0; $j < $i; $j++){
    
        #extract the nucleotide at the position in this sequence
        $nucleotide=$sequence[$j][$nuc_position];
        
        #add it to a hash (which will only store uniq keys)
        $nucs{$nucleotide}++;
           
    }
    
    #identify the number of unique nucleotides by counting keys in the hash
    $count=keys %nucs;
    
    #the number of substitutions (the more uniq nucs=more subs)
    $substitutions=$count-1;
    
    #print the position and subs to an output file
    print "$nuc_position\t$substitutions\n";
}



















################################################################################
sub usage
{
    print "\n";
	print " #################################################################\n";
	print " #                                                               #\n";	
	print " #  count_muts.pl - a program to extract TEs from a genome       #\n";
	print " #                                                               #\n";
	print " #  Required values:                                             #\n";  
	print " #    --in    input fasta alignment (in fasta format)            #\n";
	print " #                                                               #\n";	
	print " #  Optional values:                                             #\n";
	print " #    --h     prints help                                        #\n";
	print " #                                                               #\n";
	print " # Questions: neal.platt at gmail.com		  	            	#\n";
	print " #################################################################\n";
	
	exit;
}	
