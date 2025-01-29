#!/bin/bash

# Inputs are:
# $1 - file (with full path unless in current directory) of the pgap.yaml template file
# $2 - file (with full path unless in current directory) of the pgap_submol.yaml tempalte file
# $3 - full path of the home folder containing the output of the nanopore_batch_assembly.sh pipeline
# $4 - number of threads to use for PGAP annotation

# Prepare the PGAP input files and run PGAP
ls -1 $3/5_Good_assemblies/ | grep 'fasta' | sed "s/\.fasta//" | sed "s/_/\t/g" > sample_list.txt # Prepare a list of assemblies to annotate
touch run_pgap.sh 
while IFS=$'\t' read -r genus species strain
do
  grep '>' "$3/5_Good_assemblies/$genus""_$species""_$strain.fasta" | sed 's/>//' > $strain.file.txt # Get replicon names
  grep -w -f $strain.file.txt "$3/1_Working_assemblies/$strain/assembly_info.txt" | sort -k2 -gr  > $strain.assembly_info.txt # Get info for replicons
  test=$(cut -f4 $strain.assembly_info.txt | sort -k4 | uniq -c | sed 's/  / /g' | sed 's/  / /g' | sed 's/  / /g' | sed 's/  / /g' | sed 's/  / /g' | cut -f3 -d' ')
  replicon_count=$(wc -l $strain.assembly_info.txt)
  if [ "Y" = "$test" ]; then
    add_topology_nonWGS.pl "$3/5_Good_assemblies/$genus""_$species""_$strain.fasta" $strain.assembly_info.txt $strain $replicon_count > $strain.pgap.fasta # Add topology to each replicon
  else
    add_topology_WGS.pl "$3/5_Good_assemblies/$genus""_$species""_$strain.fasta" $strain.assembly_info.txt > $strain.pgap.fasta # Add topology to each replicon
  fi
  cp $1 $strain.pgap.yaml # Get the main yaml file
  cp $2 $strain.pgap.submol.yaml # Get the submol yaml file that will be modified to have genome specific information
  if [ "sp" = "$species" ]; then # Check if classified to the species level
    sed -i "s/XXX/$genus/" $strain.pgap.submol.yaml # If not, give just the lowest classification
  else
    sed -i "s/XXX/$genus $species/" $strain.pgap.submol.yaml # If yes, then give the genus and species
  fi
  sed -i "s/YYY/$strain/" $strain.pgap.submol.yaml # Add the strain name
  sed -i "s/XXX/$strain/" $strain.pgap.yaml # Get the correct file
  echo "pgap.py --no-self-update --report-usage-false --no-internet -o ""$genus""_$species""_$strain"" -c $4 -m 100g $strain.pgap.yaml" >> run_pgap.sh
done < "sample_list.txt"
#split -n l/4 run_pgap.sh run_pgap_ --additional-suffix=.sh --numeric-suffixes=1
#sh run_pgap_01.sh & # Run annotation for all genomes
#sh run_pgap_02.sh & # Run annotation for all genomes
#sh run_pgap_03.sh & # Run annotation for all genomes
#sh run_pgap_04.sh & # Run annotation for all genomes
#wait
sh run_pgap.sh # Run annotation for all genomes
