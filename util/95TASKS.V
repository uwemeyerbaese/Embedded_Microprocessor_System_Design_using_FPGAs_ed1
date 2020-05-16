// ------------------------------------------------
// Verilog STD 1364-1995 system tasks and functions
// ------------------------------------------------

// Display tasks see LRM 14.1, p. 173
$display    $displayb   $displayh   $displayo   
$monitor    $monitorb   $monitorh   $monitoro   
$monitoroff $monitoron  $strobe     $strobeb    
$strobeh    $strobeo    $write      $writeb     
$writeh     $writeo     

// File I/O tasks, see LRM 14.2, p. 180
$fclose    $fdisplay  $fdisplayb  $fdisplayh 
$fdisplayo $fmonitor  $fmonitorb  $fmonitorh 
$fmonitoro $fopen     $fstrobe    $fstrobeb 
$fstrobeh  $fstrobeo  $fwrite     $fwriteb  
$fwriteh   $fwriteo   $readmemb   $readmemh

// Timescale tasks, see LRM 14.3, p. 183
$printtimescale      $timeformat

// Simulation control tasks, see LRM 14.4, p. 187
$finish    $stop

// Timing check tasks, see LRM 14.5, p. 187
$hold    $nochange    $period   $recovery
$setup   $setuphold   $skew     $width

// PLA modeling tasks, see LRM 14.6, p. 197
$async$and$array      $sync$and$plane
$async$nand$array     $sync$nand$plane
$async$or$array       $sync$or$plane
$async$nor$array      $sync$nor$plane
$async$and$array      $sync$and$plane
$async$nand$array     $sync$nand$plane
$async$or$array       $sync$or$plane
$async$nor$array      $sync$nor$plane

// Stochastic analysis tasks, see LRM 14.7, p. 200
$q_add    $q_initialize  $q_exam
$q_full   $q_remove      $random

// Simulation time functions, see LRM 14.8, p. 202
$realtime      $stime        $time

// Conversion functions for reals, see LRM 14.9, p. 204
$bitstoreal   $itor   $realtobits    $rtoi

// Probabilistic distribution functions, see LRM 14.10, p. 205
$dist_chi_square    $dist_erlang    $dist_exponential  
$dist_normal        $dist_poisson   $dist_t      $dist_uniform
