#RNP 06 Feb 2015
# randomlySampleSameFile.pl will take a large fasta file and randomly sample
#	fasta sequences based on a given sample size and species ID.  Species
#	ID's come from the first four characters in the fasta header.  As each
#	sequence is sampled, they are printed to STDOUT
#	file.    
#
# usage: randomlySampleIndivFile.pl -fasta_in <req> -sample_size <required>
#				   
# 

use Bio::SearchIO; 
use Bio::SeqIO;
use Getopt::Long;



#sets all input values to undef
my $fasta_in	= undef;
my $file_ext	= undef;
my $help	= undef;

#get ARGV options
GetOptions('fasta_in=s'   => \$fasta_in,
	   'sample_size=n'  => \$sample_size,
           'h'	          => \$help );


#if input values not appropriate print usage statement.
if(defined $help){
	usage();
}

if( ! defined $fasta_in ){
	print "\nERROR: No fasta sequence file given\n";
	usage();
}

if( ! defined $sample_size ){
	print "\nERROR: Number of sequencs to sample must be given\n";
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
		
	#generate a random number for seq
	$random_number=rand(1000);

	#cat random number, header, and seq to same line and put in array
	$seqLine = "$random_number#-#$fasta_header#-#$sequence";
	push @unSorted, $seqLine;

}

#sort the array
@sorted = sort @unSorted;

#cycle through the array and print out the random samples
$n=0;
while($n<=$#sorted){
	
	#parse the header and sequences
	($random_number, $header, $sequence) = split "#-#", $sorted[$n]; 

	#identify the species from the header info
	$species = substr($header, 0, 4);	
	$count{$species}++;	
	
	#if less than desired sample size print to file
	if ($count{$species}<=$sample_size){
		print ">$header\n$sequence\n";
	}
$n++;
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
	print " #    -fasta_in       input fasta file of sequences              #\n"; 
	print " #    -sample_size    number of sequences to randomly sample     #\n";	
	print " #                                                               #\n";	
	print " #  Questions: neal.platt at gmail.com                           #\n";
	print " #                                                               #\n";	
	print " #                                                   6 Feb 2015  #\n";	
	print " #################################################################\n";
	
	exit;
}





