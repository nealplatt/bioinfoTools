use Getopt::Long;

#sets all input values to undef
my $rawreads_in 	= undef;
my $blast_in 	= undef;
my $help	= undef;

GetOptions('raw_reads=s' => \$rawreads_in,
	       'blast=s'	 => \$blast_in,
           'out=s'	     => \$fastq_out,
           'h'	         => \$help );


#if input values not appropriate print usage statement.
if(defined $help){
	usage();
}

if( ! defined $rawreads_in ){
	print "\nERROR: No read file given\n";
	usage();
}

if( ! defined $fastq_out ){
	print "\nERROR: No output file given\n";
	usage();
}

if( ! defined $blast_in ){
	print "\nERROR: No blast file given\n";
	usage();
}

#read in raw reads
open(RAWREADS_IN, "<$rawreads_in") or 
                                die "Can't open $rawreads_in to read in\n";
                                
open(BLAST_HITS_IN, "<$blast_in") or 
                                die "Can't open $blast_in to read in\n";

open(FASTQ_OUT, ">$fastq_out") or 
                                die "Can't open $fastq_out to read in\n";

$i=0;
print "Reading in BLAST file: $blast_in\n";
print "--------Progress------------\n";
while(<BLAST_HITS_IN>) {
        chomp; 
        
	    ($query,        $subject,       $percent_id, 
         $align_length, $mismatches,    $gap_openings, 
         $query_start,  $query_end,     $subj_start, 
         $subj_end,     $e_value,       $bit_score    ) = split;
    
    $fastq_name=join('', '@', $query);
    
    $blast_hits{$fastq_name}++;
    
    #progress tracker
    if($i == 100000){
        print ".";
        $i=0;
    }#closes if
  
    $i++;    

}

print "\n";

$i=0;
print "Parsing reads (fastq) from $rawreads_in.\n";
print "--------Progress------------\n";
while( ($read_name=<RAWREADS_IN>) && ($sequence=<RAWREADS_IN>) && ($comment=<RAWREADS_IN>) && ($quality=<RAWREADS_IN>) ){

    chomp $read_name;
    chomp $sequence;
    chomp $comment;
    chomp $quality;
    
    if ($blast_hits{$read_name} >= 1){
     
        print FASTQ_OUT "$read_name\n$sequence\n+\n$quality\n";
        
    }#closes if loop
    
    #progress tracker
    if($i == 100000){
        print ".";
        $i=0;
    }#closes if
  
    $i++;    

}#closes while loop





################################################################################
sub usage
{
    print "\n";
	print " #################################################################\n";
	print " #                                                               #\n";	
	print " #  extract_fastq_reads_from_blast.pl - a program to extract an  #\n";
        print " #      entire fastq read from a blast.out file                  #\n";
	print " #                                                               #\n";
	print " #  Required values:                                             #\n";  
	print " #    --raw_reads input read file  (in fastq format)             #\n";
	print " #    --blast     input blast file (tab format [6])              #\n"; 
        print " #    --out       output file (fastq format )                    #\n"; 
	print " #                                                               #\n";
	print " # Questions: neal.platt at gmail.com		  	     	#\n";
	print " #################################################################\n";
	
	exit;
}

