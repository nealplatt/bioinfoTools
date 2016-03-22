use Bio::SearchIO; 
use Bio::SeqIO;
use Getopt::Long;


#sets all input values to undef
my $genome_in       = undef;
my $sizeLimit_in 	= undef;
my $baseName_in     = undef;
my $help	        = undef;

GetOptions( 'genome=s'	 => \$genome_in,
	        'size=i'	 => \$sizeLimit_in,
            'baseName=s' => \$baseName_in,
            'h'	         => \$help );


#if input values not appropriate print usage statement.
if(defined $help){
	usage();
}

if( ! defined $genome_in ){
	print "\nERROR: No genome file given\n";
	usage();
}

if( ! defined $sizeLimit_in ){
	print "\nERROR: No size given to split genome\n";
	usage();
}

if( ! defined $baseName_in ){
	print "\nERROR: No basename given for output files\n";
	usage();
}


my $inseq = Bio::SeqIO->new(-file   => "<$genome_in", -format =>"fasta");


$sizeOfSplit=0;
$splitNumber=0;

#open basename file
open (OUT, ">$baseName_in$splitNumber.fas") or die "$baseName_in$splitNumber.fas cannot be opened to insert new sequence to file.\n";

while (my $seq = $inseq->next_seq) {
	    my $fastaHeader = $seq->display_id;
	    my $sequence = $seq->seq;


    
    print OUT ">$fastaHeader\n$sequence\n"; 

    $sizeOfSplit+=length($sequence);   

    if ($sizeOfSplit > $sizeLimit_in){
            $sizeOfSplit=0;            
            $splitNumber++;
            open (OUT, ">$baseName_in$splitNumber.fas") or die "$baseName$splitNumber.fas cannot be opened to insert new sequence to file.\n";
              
        }
     

	}



################################################################################
sub usage
{
    print "\n";
	print " #################################################################\n";
	print " #                                                               #\n";	
	print " #  splitFastaBySize.pl - splits fasta/genome file into smaller  #\n";
	print " #                        files of specified length              #\n";
	print " #                                                               #\n";
	print " #  Required values:                                             #\n";                                              
	print " #    --genome    input genome file (in fasta format)            #\n";
	print " #    --size      size of desired output (fasta) files           #\n"; 
	print " #    --base      base name given to output files                #\n";
	print " #                                                               #\n";
	print " # Questions: neal.platt at gmail.com		  	                #\n";
	print " #################################################################\n";
	
	exit;
}
