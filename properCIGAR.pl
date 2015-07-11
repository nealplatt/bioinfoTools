while(<>){
    chomp;
    ($QNAME,    $FLAG,  $RNAME,     $POS,   $MAPQ,  $CIGAR, 
    $RNEXT,     $PNEXT, $TLEN,      $SEQ,   $QUAL) = split(/\t/);

    if ($CIGAR =~ /^[1|2|3]S\d+M$/ || $CIGAR =~ /^\d+M[1|2|3]S$/ || $CIGAR =~ /^\d+M$/ ){
        print "$_\n";
    }
}
