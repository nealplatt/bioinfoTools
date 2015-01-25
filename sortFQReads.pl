#RNP
#15july2013
#This program takes processed fastq reads (PE) and matches them up in the same
# order into new sorted files.  Any reads that have no matches have been
# removed into a seperate sorted file.


#read in file names from the command line and if an error occurs program dies
# and prints a usage statement

my $usage= "USAGE: sort_fastq_reads.pl <read_1_unsorted> <read_2_unsorted> <read_1_sorted> <read_2_sorted> <orphan_outputfile>\n";
my $read_1_unsorted = shift or die $usage;
my $read_2_unsorted = shift or die $usage;
my $read_1_sorted = shift or die $usage;
my $read_2_sorted = shift or die $usage;
my $orphans = shift or die $usage;

#open all relevant files for reading in and printing out
open(R1_UNSORTED, "<$read_1_unsorted") or 
                                die "Can't open $read_1_unsorted to read in\n";
open(R2_UNSORTED, "<$read_2_unsorted") or 
                                die "Can't open $read_2_unsorted read in\n";
open(R1_SORTED, ">$read_1_sorted") or 
                                die "Can't open $read_1_sorted to read in\n";
open(R2_SORTED, ">$read_2_sorted") or 
                                die "Can't open $read_2_sorted to read in\n";
open(ORPHANS, ">$orphans") or 
                                die "Can't open $orphans to read in\n";


#read in from the R1 unsorted fastq file and store the information in an
# hash table.  These hash will then be searched when the R2 unsorted file
# is opened
while($R1_fastq_info = <R1_UNSORTED>){
    chomp($R1_fastq_info);
    
    #push the incoming file lines onto an array
    push(@R1_fastq_to_sort, $R1_fastq_info);

    #after reading in 4 (cause an array is 0 indexed) lines (1 fastq sequences)
    #  store information into a hash (in memory).   
    if( $#R1_fastq_to_sort == 3 ){
       
        $R1_name=substr($R1_fastq_to_sort[0], 0,-13);
        $R1_tail_info{$R1_name}=substr($R1_fastq_to_sort[0],-12);
        $R1_seq{$R1_name}=$R1_fastq_to_sort[1];
        $R1_info{$R1_name}=$R1_fastq_to_sort[2];
        $R1_qual{$R1_name}=$R1_fastq_to_sort[3];
        
        #create a list sequence headers for later use
        $R1_list_of_reads{$R1_name}=$R1_name;

        #delete the fastq information stored in the array
        shift(@R1_fastq_to_sort);
        shift(@R1_fastq_to_sort);
        shift(@R1_fastq_to_sort);
        shift(@R1_fastq_to_sort);

    }#closes if statement (line 34)
}#closes while loop (line 26)



#open the R2 file and sort through it one fastq record (4 lines) at a time.
# find the corresponding R1 seqeunce in a hash and then print them R1 and R2
# records into seperate "sorted" files
while($R2_fastq_info = <R2_UNSORTED>){
    chomp($R2_fastq_info);
   
    #push the incoming file lines onto an array
    push(@R2_fastq_to_sort, $R2_fastq_info);
       
    #after reading in 4 (array is 0 indexed) lines (1 fastq sequences)
    if( $#R2_fastq_to_sort == 3 ){
        
        #find the name of the header (and exclude the 1:0:02 info on the end
        # of the fastq header)
             $R2_short_name=substr($R2_fastq_to_sort[0], 0,-13);
            
        # see if there is an R1 sequence header (in the hash)          
        if( defined $R1_list_of_reads{$R2_short_name} ){       
           
            #if there is a corresponding R1 header, print out the R1 info to
            # the sorted R1 file
            print R1_SORTED "$R1_list_of_reads{$R2_short_name} $R1_tail_info{$R2_short_name}\n";
            print R1_SORTED "$R1_seq{$R2_short_name}\n";
            print R1_SORTED "+\n";
            print R1_SORTED "$R1_qual{$R2_short_name}\n";

            #to reduce memory requirements remove the R1 info from the hash
            delete($R1_list_of_reads{$R2_short_name});
            delete($R1_seq{$R2_short_name});
            delete($R1_qual{$R2_short_name});

            #print the R2 info into the sorted file
            print R2_SORTED "$R2_fastq_to_sort[0]\n";
            print R2_SORTED "$R2_fastq_to_sort[1]\n";
            print R2_SORTED "+\n";
            print R2_SORTED "$R2_fastq_to_sort[3]\n";
            
            #delete the R2 info from the array
            shift(@R2_fastq_to_sort);
            shift(@R2_fastq_to_sort);
            shift(@R2_fastq_to_sort);
            shift(@R2_fastq_to_sort);

        }#closes if (line 75)
        else{

            #if there is not R2 match in the R1 hash, then the R2 read is
            # considered to be an "orphaned" read and is printed in the
            # orphan file
            print ORPHANS "$R2_fastq_to_sort[0]\n";
            print ORPHANS "$R2_fastq_to_sort[1]\n";
            print ORPHANS "+\n";
            print ORPHANS "$R2_fastq_to_sort[3]\n";
    
            #delete the R2 info from the array
            shift(@R2_fastq_to_sort);
            shift(@R2_fastq_to_sort);
            shift(@R2_fastq_to_sort);
            shift(@R2_fastq_to_sort);
        }#closes else (line 101)
    }#closes if (line 68)
}#closes while (line 61)

#finally, after all the R2 reads have been parsed, there may still be some R1
# reads that do not have R2 partners.  These remaining R1 reads are printed
# into the orphan file
foreach $seq_name (sort keys %R1_seq){
    
    print ORPHANS "$seq_name\n";
    print ORPHANS "$R1_seq{$seq_name}\n";
    print ORPHANS "+\n";
    print ORPHANS "$R1_qual{$seq_name}\n";
}#closes foreach (line 124)


    
      
