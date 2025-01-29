#!/usr/bin/perl
use 5.010;

# Store input files
$fasta_file = @ARGV[0];
$assembly_stats = @ARGV[1];
$strain_name = @ARGV[2];
$replicon_count = @ARGV[3];

# Update the contig names
@letters = 'a' .. 'z';
open($in, '<', $fasta_file);
while(<$in>) {
  chomp;
  if(/>/) {
    $contig = $_;
    $contig =~ s/>//;
    $count = 0;
    open($in2, '<', $assembly_stats);
    while(<$in2>) {
      $count++;
      @line = split("\t", $_);
      if(/$contig\b/) {
        if($count == 1) {
          print(">$contig\ \[topology\=circular\]\ \[location\=chromosome\]\n");
        }
        else {
          $plasmid_count = $replicon_count - $count + 1;
          $replicon_name = 'p' . $strain_name . @letters[$plasmid_count - 1];
          print(">$contig\ \[topology\=circular\]\ \[location\=plasmid\]\ \[plasmid-name\=$replicon_name\]\n");
        }
      }
    }
  }
  else {
    print("$_\n");
  }
}
close($in);

