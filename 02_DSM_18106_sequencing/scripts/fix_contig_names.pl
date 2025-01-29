#!/usr/bin/perl
use 5.010;

$assembly_file = @ARGV[0];
$assembly_info_file = @ARGV[1];
$contig_info_file = @ARGV[2];
$max_contig = @ARGV[3];
$output = 'temp.txt';

$n = 0;
open($in, '<', $contig_info_file);
open($out, '>', $output);
while(<$in>) {
    chomp;
    $n++;
    $contig_number = $max_contig + $n;
    $contig_name = '>contig_' . $contig_number;
    system("sed -i 's/$_/$contig_name/' $assembly_file");
    $_ =~ s/>//;
    $_ =~ s/~/-$n\t/;
    $_ =~ s/\.\./\t/;
    @line = split("\t", $_);
    $length = @line[2] - @line[1] + 1;
    $line = 'contig_' . $contig_number . "\t" . $length . "\t1\tN\tN\t1\t*\t*";
    say $out ($line);
}
close($in);
close($out);
system("cat $assembly_info_file $output > assembly_info.new.txt");
unlink($output);
