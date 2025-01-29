#!/usr/bin/perl
use 5.010;

# Get list of samples, which is the same file used to run the bulk assembly
$sample_list = @ARGV[0];

# Make sure all necessary files are unzipped
system("gunzip 1_Working_assemblies/*/flye.log.gz");
system("gunzip 2_Draft_assemblies/*");
system("gunzip 4_CheckM_output/checkm_output_2.txt.gz");
system("gunzip 6_PGAP_annotations/*/checkm.txt.gz");
system("gunzip 6_PGAP_annotations/*/annot.gbk.gz");

# Create the desired metadata file
$metadata_file = 'metadata.txt';
open($metadata, '>', $metadata_file);
# Print headers to file
say $metadata ("Strain_name\tSpecies_classification\tGenome_size\tContigs\tProteins\tPseudogenes\tMean_sequencing_depth\tGenome_completeness\tGenome_contamination\tAnnotation_completeness\tAnotation_contamination");
open($in, '<', $sample_list);
while(<$in>) {

    # Get the genome ID (strain name)
    @line = split("\t", $_);
    $ID = @line[0];

    # Check if there is an assembly for the strain
    if(-e "2_Draft_assemblies/$ID.fasta") {

        # Get mean sequencing depth
        system("grep 'Mean coverage:' 1_Working_assemblies/$ID/flye.log | cut -f3 > tmp.txt");
        $tmp_file = 'tmp.txt';
        open($tmp, '<', $tmp_file);
        while(<$tmp>) {
            chomp;
            $mean_depth = $_;
        }
        close($tmp);

        # Get genome size after polishing
        system("stats.sh 2_Draft_assemblies/$ID.fasta | grep 'All' | cut -f4 | sed 's/ //g' > tmp.txt");
        $tmp_file = 'tmp.txt';
        open($tmp, '<', $tmp_file);
        while(<$tmp>) {
            chomp;
            $genome_size = $_;
        }
        close($tmp);

        # Get contig count
        system("stats.sh 2_Draft_assemblies/$ID.fasta | head -5 | tail -1 | cut -f2 | sed 's/ //g' > tmp.txt");
        $tmp_file = 'tmp.txt';
        open($tmp, '<', $tmp_file);
        while(<$tmp>) {
            chomp;
            $contig_count = $_;
        }
        close($tmp);

        # Get genome completeness and contamination from CheckM
        system("grep $ID 4_CheckM_output/checkm_output_2.txt | cut -f14,15 -d' ' > tmp.txt");
        $tmp_file = 'tmp.txt';
        open($tmp, '<', $tmp_file);
        while(<$tmp>) {
            chomp;
            @genome_stats = split(' ', $_);
        }
        close($tmp);

        # Check if there is an annotation for the strain
        system("ls -1 6_PGAP_annotations/ | grep $ID > tmp.txt");
        if(-s "tmp.txt") {

            # Get species classification
            system("ls -1 6_PGAP_annotations/ | grep $ID > tmp.txt");
            $tmp_file = 'tmp.txt';
            open($tmp, '<', $tmp_file);
            while(<$tmp>) {
                @species = split('_', $_);
                $species_name = "@species[0]_@species[1]";
            }
            close($tmp);

            # Get annotation completeness and contamination from PGAP
            system("cat 6_PGAP_annotations/*$ID/checkm.txt | cut -f12,13 | tail -1 > tmp.txt");
            $tmp_file = 'tmp.txt';
            open($tmp, '<', $tmp_file);
            while(<$tmp>) {
                chomp;
                @annotation_stats = split("\t", $_);
            }
            close($tmp);

            # Get gene count
            system("grep 'with protein' 6_PGAP_annotations/*$ID/annot.gbk | cut -f3 -d':' | sed 's/ //g' | sed 's/,//g' > tmp.txt");
            $tmp_file = 'tmp.txt';
            open($tmp, '<', $tmp_file);
            while(<$tmp>) {
                chomp;
                $gene_count = $_;
            }
            close($tmp);

            # Get pseudogene count
            system("grep 'Pseudo Genes (total)' 6_PGAP_annotations/*$ID/annot.gbk | cut -f3 -d':' | sed 's/ //g' | sed 's/,//g' > tmp.txt");
            $tmp_file = 'tmp.txt';
            open($tmp, '<', $tmp_file);
            while(<$tmp>) {
                chomp;
                $pseudogene_count = $_;
            }
            close($tmp);

            # Print the data to the file
            say $metadata ("$ID\t$species_name\t$genome_size\t$contig_count\t$gene_count\t$pseudogene_count\t$mean_depth\t@genome_stats[0]\t@genome_stats[1]\t@annotation_stats[0]\t@annotation_stats[1]");

        } else {

            # Print the data to the file
            say $metadata ("$ID\t\t$genome_size\t$contig_count\t\t\t$mean_depth\t@genome_stats[0]\t@genome_stats[1]\t\t");

        }

    } else {
        say $metadata ("$ID\t\t\t\t\t\t\t\t\t\t");
    }
}

# Close files
close($in);
close($metadata);
unlink($tmp_file);

# Recompress files
system("pigz -p 16 1_Working_assemblies/*/flye.log");
system("pigz -p 16 2_Draft_assemblies/*");
system("pigz -p 16 4_CheckM_output/checkm_output_2.txt");
system("pigz -p 16 6_PGAP_annotations/*/checkm.txt");
system("pigz -p 16 6_PGAP_annotations/*/annot.gbk");

