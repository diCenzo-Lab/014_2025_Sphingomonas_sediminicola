#!/bin/bash

# Inputs are:
# $1 - tab delimited file with strain name (column 1) and file name (column 2)
# $2 - full path of the folder holding the nanopore data
# $3 - number of threads to use for all steps
# $4 - estimated genome size
# $5 - coverage for disjointing assembly
# $6 - minimum contig size to keep

# Run Flye and medaka for each of the samples
mkdir 1_Working_assemblies/ # Make directory to hold all intermediate assembly data
mkdir 2_Draft_assemblies/ # Make directory to hold polished assemblies
while IFS=$'\t' read -r strain_name file_name
do
  flye --nano-hq "$2/$file_name" -o "1_Working_assemblies/$strain_name" -t $3 -m 1000 --genome-size $4 --asm-coverage $5 # Run Flye
  medaka_consensus -i "$2/$file_name" -d "1_Working_assemblies/$strain_name/assembly.fasta" -o "1_Working_assemblies/$strain_name/medaka_polishing" -t $3 -m r1041_e82_400bps_sup_v4.3.0 # Run medaka
  mkdir "1_Working_assemblies/$strain_name/fcs"
  run_fcsadaptor.sh --fasta-input "./1_Working_assemblies/$strain_name/medaka_polishing/consensus.fasta" --output-dir "./1_Working_assemblies/$strain_name/fcs" --prok
  cat "./1_Working_assemblies/$strain_name/medaka_polishing/consensus.fasta" | python3 /home/Bioinformatics_programs/fcs/dist/fcs.py clean genome --action-report "./1_Working_assemblies/$strain_name/fcs/fcs_adaptor_report.txt" --output "1_Working_assemblies/$strain_name/fcs/$strain_name.fasta" --contam-fasta-out "1_Working_assemblies/$strain_name/fcs/contam.fasta"
  grep '~' "1_Working_assemblies/$strain_name/fcs/$strain_name.fasta" > "1_Working_assemblies/$strain_name/fcs/contig_names.txt"
  cut -f1 -d'~' "1_Working_assemblies/$strain_name/fcs/contig_names.txt" | sed 's/>//' | sort -u > "1_Working_assemblies/$strain_name/fcs/contig_names_original.txt"
  grep -v -f "1_Working_assemblies/$strain_name/fcs/contig_names_original.txt" "1_Working_assemblies/$strain_name/assembly_info.txt" > "1_Working_assemblies/$strain_name/assembly_info.reduced.txt"
  max_contig=$(cut -f1 1_Working_assemblies/$strain_name/assembly_info.txt | grep -v 'seq_name' | cut -f2 -d'_' | sort -g | tail -1)
  fix_contig_names.pl "1_Working_assemblies/$strain_name/fcs/$strain_name.fasta" "1_Working_assemblies/$strain_name/assembly_info.reduced.txt" "1_Working_assemblies/$strain_name/fcs/contig_names.txt" $max_contig
  mv "1_Working_assemblies/$strain_name/assembly_info.txt" "1_Working_assemblies/$strain_name/assembly_info.backup.txt"
  mv assembly_info.new.txt "1_Working_assemblies/$strain_name/assembly_info.txt"
  cp "1_Working_assemblies/$strain_name/fcs/$strain_name.fasta" "1_Working_assemblies/$strain_name/$strain_name.fasta"
  cat "1_Working_assemblies/$strain_name/assembly_info.txt" | awk -F " " '{if ($2>='"$6"') print $1}' | grep -v 'seq_name' > "1_Working_assemblies/$strain_name/long_contigs.txt" # Get list of contigs of atleast minimum length specified
  pullseq -i "1_Working_assemblies/$strain_name/$strain_name.fasta" -n "1_Working_assemblies/$strain_name/long_contigs.txt" > "2_Draft_assemblies/$strain_name.fasta"
  pigz -p 16 -r "1_Working_assemblies/$strain_name"
done < "$1"
gunzip 1_Working_assemblies/*/assembly_info.txt.gz # Unzip the assembly_info.txt files as they may be needed later
find ./2_Draft_assemblies/ -type f -empty -print -delete

# Run GTDB-tk and CheckM
mkdir 3_GTDB-tk_output/ # Make directory to hold the GTDB-tk classifications
mkdir 4_CheckM_output/ # Make directory to hold the CheckM QC data
gtdbtk classify_wf --genome_dir 2_Draft_assemblies/ --out_dir 3_GTDB-tk_output/ --cpus $3 --mash_db /databasedisk1/GTDB-tk/gtdb.mash.msh --extension fasta # Run GTDB-tk
checkm lineage_wf -t $3 -x fasta -f checkm_output.txt 2_Draft_assemblies/ 4_CheckM_output/
mv checkm_output.txt 4_CheckM_output

# Get just the good assemblies and rename based on taxonomy
mkdir 5_Good_assemblies/ # Make directory for assemblies that pass QC
cp 4_CheckM_output/checkm_output.txt 4_CheckM_output/checkm_output_2.txt
sed -i 's/  / /g' 4_CheckM_output/checkm_output_2.txt
sed -i 's/  / /g' 4_CheckM_output/checkm_output_2.txt
sed -i 's/  / /g' 4_CheckM_output/checkm_output_2.txt
sed -i 's/  / /g' 4_CheckM_output/checkm_output_2.txt
sed -i 's/  / /g' 4_CheckM_output/checkm_output_2.txt
get_good_assemblies.pl # Collect the good assemblies and rename them


