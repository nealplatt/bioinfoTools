while (<>) {
    ($queryId,      $subjectId,     $percIdentity,  $alnLength,     $mismatchCount, 
    $gapOpenCount,  $queryStart,    $queryEnd,      $subjectStart, 
    $subjectEnd,    $eVal,          $bitScore) = split(/\t/);

    
    if($subjectEnd>$subjectStart){
 
        print "$subjectId\t$subjectStart\t$subjectEnd\t$queryId\t$percIdentity\t-\n";        

    }else{

        print "$subjectId\t$subjectEnd\t$subjectStart\t$queryId\t$percIdentity\t+\n";
   
    }

}
