# Neal Platt

# neal.platt@gmail.com

# 29 January 2014

# 

# This program takes a fasta file from the input and converts it to single

#   line fasta.







#import the file line by line

while($incomingLine = <>){

    chomp $incomingLine;

    

    #if the line begins with a ">" it is a sequence header

    if ($incomingLine =~ m/^>/){

        



        #if the line is the first in the file --go ahead and print it out

        if($. == 1){

           print "$incomingLine\n";

        }

        

        #if not the first line, print a new line, then the incomingLine        

        else{

            print "\n$incomingLine\n";

        }



    }



    #if line does not begin with a ">" it must be part of the sequence..print

    else{

        print $incomingLine;

    }

}
