#!/usr/bin/perl
use 5.010;

# Store input files
$fasta_file = @ARGV[0];
$assembly_stats = @ARGV[1];

# Update the contig names
open($in, '<', $fasta_file);
while(<$in>) {
  chomp;
  if(/>/) {
    $contig = $_;
    $contig =~ s/>//;
    open($in2, '<', $assembly_stats);
    while(<$in2>) {
      if(/$contig\b/) {
        @line = split("\t", $_);
        if(@line[3] eq 'Y') {
          print(">$contig\ \[topology\=circular\]\n");
        }
        else {
          print(">$contig\ \[topology\=linear\]\n");
        }
      }
    }
  }
  else {
    print("$_\n");
  }
}
close($in);

