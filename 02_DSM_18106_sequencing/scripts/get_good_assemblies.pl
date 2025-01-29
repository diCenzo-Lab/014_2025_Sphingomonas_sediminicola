#!/usr/bin/perl
use 5.010;

# Copy the good assemblies
$input = '4_CheckM_output/checkm_output_2.txt';
open($in, '<', $input);
while(<$in>) {
    @line = split(' ', $_);
    $name = @line[0];
    if(@line[12] > 95 && @line[13] < 5) {
        system("cp 2_Draft_assemblies/$name.fasta 5_Good_assemblies/");
    }
}
close($in);

# Rename the good assemblies
$input = '3_GTDB-tk_output/gtdbtk.bac120.summary.tsv';
open($in, '<', $input);
while(<$in>) {
    @line = split("\t", $_);
    @lineage = split(';', @line[1]);
    if(length(@lineage[6]) == 3) {
        if(length(@lineage[5]) == 3) {
            if(length(@lineage[4]) == 3) {
                if(length(@lineage[3]) == 3) {
                    if(length(@lineage[2]) == 3) {
                        if(length(@lineage[1]) == 3) {
                        }
                        else {
                            @lineage[1] =~ s/p__//;
                            @lineage[1] =~ s/ /_/;
                            system("mv 5_Good_assemblies/@line[0].fasta 5_Good_assemblies/@lineage[1]_sp_@line[0].fasta");
                        }
                    }
                    else {
                        @lineage[2] =~ s/c__//;
                        @lineage[2] =~ s/ /_/;
                        system("mv 5_Good_assemblies/@line[0].fasta 5_Good_assemblies/@lineage[2]_sp_@line[0].fasta");
                    }
                }
                else {
                    @lineage[3] =~ s/o__//;
                    @lineage[3] =~ s/ /_/;
                    system("mv 5_Good_assemblies/@line[0].fasta 5_Good_assemblies/@lineage[3]_sp_@line[0].fasta");
                }
            }
            else {
                @lineage[4] =~ s/f__//;
                @lineage[4] =~ s/ /_/;
                system("mv 5_Good_assemblies/@line[0].fasta 5_Good_assemblies/@lineage[4]_sp_@line[0].fasta");
            }
        }
        else {
            @lineage[5] =~ s/g__//;
            @lineage[5] =~ s/_/ /;
            @organism = split(' ', @lineage[5]);
            if(@organism[0] =~ m/[0-9]/) {
                @lineage[4] =~ s/f__//;
                @lineage[4] =~ s/ /_/;
                system("mv 5_Good_assemblies/@line[0].fasta 5_Good_assemblies/@lineage[4]_sp_@line[0].fasta");
            }
            else {
                @lineage[4] =~ s/f__//;
                @lineage[4] =~ s/ /_/;
                if(length(@organism[-1]) == 1) {
                    system("mv 5_Good_assemblies/@line[0].fasta 5_Good_assemblies/@lineage[4]_sp_@line[0].fasta");
                }
                else {
                    system("mv 5_Good_assemblies/@line[0].fasta 5_Good_assemblies/@lineage[5]_sp_@line[0].fasta");
                }
            }
        }
    }
    else {
        @lineage[6] =~ s/s__//;
        @lineage[6] =~ s/_/ /g;
        @organism = split(' ', @lineage[6]);
        if(@organism[-1] =~ m/[0-9]/) {
            system("mv 5_Good_assemblies/@line[0].fasta 5_Good_assemblies/@organism[0]_sp_@line[0].fasta");
        }
        else {
            if(length(@organism[-1]) == 1) {
                system("mv 5_Good_assemblies/@line[0].fasta 5_Good_assemblies/@organism[0]_sp_@line[0].fasta");
            }
            else {
                system("mv 5_Good_assemblies/@line[0].fasta 5_Good_assemblies/@organism[0]_@organism[-1]_@line[0].fasta");
            }
        }
    }
}

