#!/usr/bin/perl
use 5.010;

# Get list of samples, which is the file produced by prepare_metadata_file.pl
$metadata = @ARGV[0];
open($in, '<', $metadata);
while(<>) {
    chomp;
    @line = split("\t", $_);
    $cmd = 'rename s/annot/' . @line[1] . '_' . @line[0] . '/ temp/' . @line[1] . '_' . @line[0] . '/annot*';
    system("$cmd");
}

