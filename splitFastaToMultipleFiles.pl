use Bio::SearchIO; 
use Bio::SeqIO;
use Getopt::Long;
use POSIX;


#sets all input values to undef
my $fasta_in        = undef;
my $numFiles_in 	= undef;
my $baseName_in     = undef;
my $help	        = undef;

GetOptions( 'fasta=s'	 => \$fasta_in,
	        'num=i'	     => \$numFiles_in,
            'baseName=s' => \$baseName_in,
            'h'	         => \$help );


#if input values not appropriate print usage statement.
if(defined $help){
	usage();
}

if( ! defined $fasta_in ){
	print "\nERROR: No fasta file given\n";
	usage();
}

if( ! defined $numFiles_in ){
	print "\nERROR: No number of files designated\n";
	usage();
}

if( ! defined $baseName_in ){
	print "\nERROR: No basename given for output files\n";
	usage();
}


my $inseq = Bio::SeqIO->new(-file   => "<$fasta_in", -format =>"fasta");




$count=0;

while (my $seq = $inseq->next_seq) {
    $count++;
}

$numSeqsPerFile=ceil($count/$numFiles_in);


$splitNumber=1;

open (OUT, ">$baseName_in$splitNumber.fasta") or die "$baseName_in$splitNumber.fasta cannot be opened to insert new sequence to file.\n";

my $inseq = Bio::SeqIO->new(-file   => "<$fasta_in", -format =>"fasta");
while (my $seq = $inseq->next_seq) {
	    my $fastaHeader = $seq->display_id;
	    my $sequence = $seq->seq;
 
        if($numSeq >= $numSeqsPerFile){
            $splitNumber++;
                open (OUT, ">$baseName_in$splitNumber.fasta") or die "$baseName_in$splitNumber.fasta cannot be opened to insert new sequence to file.\n";
        $numSeq=0;
        }
        print OUT ">$fastaHeader\n$sequence\n";
        $numSeq++;

}        


################################################################################
sub usage
{
    print "\n";
	print " ##################################################################\n";
	print " #                                                                #\n";	
	print " #  splitFastaToMultipleFiles.pl - splits fasta file into smaller #\n";
	print " #                        files of with ~ same num of sequences   #\n";
	print " #                                                                #\n";
	print " #  Required values:                                              #\n";                                              
	print " #    --fasta    input fasta file (in fasta format)               #\n";
	print " #    --num      number of desired output (fasta) files           #\n"; 
	print " #    --baseName      base name given to output files             #\n";
	print " #                                                                #\n";
	print " # Questions: neal.platt at gmail.com		  	                 #\n";
	print " ##################################################################\n";
	
	exit;
}
