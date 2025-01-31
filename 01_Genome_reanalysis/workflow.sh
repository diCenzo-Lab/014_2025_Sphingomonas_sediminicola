# Download the sequencing data
mkdir 01_fastq_files/ # Make folder to hold the data
fastq-dump --accession SRR18460304 --outdir 01_fastq_files --split-3 # Get data for SRR18460304 (Ssedi5)
fastq-dump --accession SRR18460303 --outdir 01_fastq_files --split-3 # Get data for SRR18460303 (Ssedi4)
fastq-dump --accession SRR18460305 --outdir 01_fastq_files --split-3 # Get data for SRR18460305 (Ssedi3)
fastq-dump --accession SRR18460306 --outdir 01_fastq_files --split-3 # Get data for SRR18460306 (Ssedi2)
fastq-dump --accession SRR18460307 --outdir 01_fastq_files --split-3 # Get data for SRR18460307 (Ssedi1)

# Perform QC on the sequencing data
mkdir 02_cleaned_reads/ # Make folder to hold the data
bbduk.sh in=01_fastq_files/SRR18460304_1.fastq in2=01_fastq_files/SRR18460304_2.fastq out=02_cleaned_reads/SRR18460304_1.bbduk.fastq out2=02_cleaned_reads/SRR18460304_2.bbduk.fastq # Run BBduk on the sample
bbduk.sh in=01_fastq_files/SRR18460303_1.fastq in2=01_fastq_files/SRR18460303_2.fastq out=02_cleaned_reads/SRR18460303_1.bbduk.fastq out2=02_cleaned_reads/SRR18460303_2.bbduk.fastq # Run BBduk on the sample
bbduk.sh in=01_fastq_files/SRR18460305_1.fastq in2=01_fastq_files/SRR18460305_2.fastq out=02_cleaned_reads/SRR18460305_1.bbduk.fastq out2=02_cleaned_reads/SRR18460305_2.bbduk.fastq # Run BBduk on the sample
bbduk.sh in=01_fastq_files/SRR18460306_1.fastq in2=01_fastq_files/SRR18460306_2.fastq out=02_cleaned_reads/SRR18460306_1.bbduk.fastq out2=02_cleaned_reads/SRR18460306_2.bbduk.fastq # Run BBduk on the sample
bbduk.sh in=01_fastq_files/SRR18460307_1.fastq in2=01_fastq_files/SRR18460307_2.fastq out=02_cleaned_reads/SRR18460307_1.bbduk.fastq out2=02_cleaned_reads/SRR18460307_2.bbduk.fastq # Run BBduk on the sample
java -jar /home/Bioinformatics_programs/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 16 02_cleaned_reads/SRR18460304_1.bbduk.fastq 02_cleaned_reads/SRR18460304_2.bbduk.fastq 02_cleaned_reads/SRR18460304_1.trimmed.fastq 02_cleaned_reads/SRR18460304_1.unpaired.fastq 02_cleaned_reads/SRR18460304_2.trimmed.fastq 02_cleaned_reads/SRR18460304_2.unpaired.fastq LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 # Run trimmomatic on the sample
java -jar /home/Bioinformatics_programs/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 16 02_cleaned_reads/SRR18460303_1.bbduk.fastq 02_cleaned_reads/SRR18460303_2.bbduk.fastq 02_cleaned_reads/SRR18460303_1.trimmed.fastq 02_cleaned_reads/SRR18460303_1.unpaired.fastq 02_cleaned_reads/SRR18460303_2.trimmed.fastq 02_cleaned_reads/SRR18460303_2.unpaired.fastq LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 # Run trimmomatic on the sample
java -jar /home/Bioinformatics_programs/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 16 02_cleaned_reads/SRR18460305_1.bbduk.fastq 02_cleaned_reads/SRR18460305_2.bbduk.fastq 02_cleaned_reads/SRR18460305_1.trimmed.fastq 02_cleaned_reads/SRR18460305_1.unpaired.fastq 02_cleaned_reads/SRR18460305_2.trimmed.fastq 02_cleaned_reads/SRR18460305_2.unpaired.fastq LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 # Run trimmomatic on the sample
java -jar /home/Bioinformatics_programs/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 16 02_cleaned_reads/SRR18460306_1.bbduk.fastq 02_cleaned_reads/SRR18460306_2.bbduk.fastq 02_cleaned_reads/SRR18460306_1.trimmed.fastq 02_cleaned_reads/SRR18460306_1.unpaired.fastq 02_cleaned_reads/SRR18460306_2.trimmed.fastq 02_cleaned_reads/SRR18460306_2.unpaired.fastq LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 # Run trimmomatic on the sample
java -jar /home/Bioinformatics_programs/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 16 02_cleaned_reads/SRR18460307_1.bbduk.fastq 02_cleaned_reads/SRR18460307_2.bbduk.fastq 02_cleaned_reads/SRR18460307_1.trimmed.fastq 02_cleaned_reads/SRR18460307_1.unpaired.fastq 02_cleaned_reads/SRR18460307_2.trimmed.fastq 02_cleaned_reads/SRR18460307_2.unpaired.fastq LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 # Run trimmomatic on the sample
cat 02_cleaned_reads/*_1.trimmed.fastq > combined_1.trimmed.fastq # Combine the reads
cat 02_cleaned_reads/*_2.trimmed.fastq > combined_2.trimmed.fastq # Combine the reads
mv *.fastq 02_cleaned_reads/ # Combine the reads

# Assemble the genomes using unicycler
mkdir 03_unicycler_output/ # Make folder to hold the data
unicycler -1 02_cleaned_reads/SRR18460304_1.trimmed.fastq -2 02_cleaned_reads/SRR18460304_2.trimmed.fastq -o 03_unicycler_output/SRR18460304 -t 16 # Assemble this read set
unicycler -1 02_cleaned_reads/SRR18460303_1.trimmed.fastq -2 02_cleaned_reads/SRR18460303_2.trimmed.fastq -o 03_unicycler_output/SRR18460303 -t 16 # Assemble this read set
unicycler -1 02_cleaned_reads/SRR18460305_1.trimmed.fastq -2 02_cleaned_reads/SRR18460305_2.trimmed.fastq -o 03_unicycler_output/SRR18460305 -t 16 # Assemble this read set
unicycler -1 02_cleaned_reads/SRR18460306_1.trimmed.fastq -2 02_cleaned_reads/SRR18460306_2.trimmed.fastq -o 03_unicycler_output/SRR18460306 -t 16 # Assemble this read set
unicycler -1 02_cleaned_reads/SRR18460307_1.trimmed.fastq -2 02_cleaned_reads/SRR18460307_2.trimmed.fastq -o 03_unicycler_output/SRR18460307 -t 16 # Assemble this read set
unicycler -1 02_cleaned_reads/combined_1.trimmed.fastq -2 02_cleaned_reads/combined_2.trimmed.fastq -o 03_unicycler_output/combined -t 16 # Assemble this read set
pigz -p 16 -r 01_fastq_files # Compress fastq files
pigz -p 16 -r 02_cleaned_reads # Compress fastq files
mkdir 03_unicycler_output/final_assemblies/ # Make folder to hold the final unicycler assemblies
cp 03_unicycler_output/SRR18460304/assembly.fasta 03_unicycler_output/final_assemblies/SRR18460304.assembly.fasta # Copy the assembly to the desired folder and rename the assembly
cp 03_unicycler_output/SRR18460303/assembly.fasta 03_unicycler_output/final_assemblies/SRR18460303.assembly.fasta # Copy the assembly to the desired folder and rename the assembly
cp 03_unicycler_output/SRR18460305/assembly.fasta 03_unicycler_output/final_assemblies/SRR18460305.assembly.fasta # Copy the assembly to the desired folder and rename the assembly
cp 03_unicycler_output/SRR18460306/assembly.fasta 03_unicycler_output/final_assemblies/SRR18460306.assembly.fasta # Copy the assembly to the desired folder and rename the assembly
cp 03_unicycler_output/SRR18460307/assembly.fasta 03_unicycler_output/final_assemblies/SRR18460307.assembly.fasta # Copy the assembly to the desired folder and rename the assembly
cp 03_unicycler_output/combined/assembly.fasta 03_unicycler_output/final_assemblies/combined.assembly.fasta # Copy the assembly to the desired folder and rename the assembly

# Perform some analyses on the assemblies
mkdir 04_assembly_analyses # Make folder to hold the data
mkdir 04_assembly_analyses/gtdbtk/ # Make directory to hold the GTDB-tk classifications
gtdbtk classify_wf --genome_dir 03_unicycler_output/final_assemblies/ --out_dir 04_assembly_analyses/gtdbtk/ --cpus 16 --mash_db /databasedisk1/GTDB-tk/gtdb.mash.msh --extension fasta # Run GTDB-tk
mkdir 04_assembly_analyses/checkm/ # Make directory to hold the CheckM QC data
checkm lineage_wf -t 16 -x fasta -f checkm_output.txt 03_unicycler_output/final_assemblies/ 04_assembly_analyses/checkm/ # Run CheckM
mv checkm_output.txt 04_assembly_analyses/checkm/ # Run CheckM
mkdir 04_assembly_analyses/fastani/ # Make directory to hold the FastANI output
find 03_unicycler_output/final_assemblies/*.fasta > 04_assembly_analyses/fastani/file_paths.txt # Get paths to genomes
fastANI --ql 04_assembly_analyses/fastani/file_paths.txt --rl 04_assembly_analyses/fastani/file_paths.txt -o 04_assembly_analyses/fastani/fastani_output.txt -t 16 # Run FastANI
mkdir 04_assembly_analyses/stats/ # Make directory to hold assembly statistics
stats.sh 03_unicycler_output/final_assemblies/SRR18460304.assembly.fasta > 04_assembly_analyses/stats/SRR18460304.assembly.stats.txt # Get assembly stats for this assembly
stats.sh 03_unicycler_output/final_assemblies/SRR18460303.assembly.fasta > 04_assembly_analyses/stats/SRR18460303.assembly.stats.txt # Get assembly stats for this assembly
stats.sh 03_unicycler_output/final_assemblies/SRR18460305.assembly.fasta > 04_assembly_analyses/stats/SRR18460305.assembly.stats.txt # Get assembly stats for this assembly
stats.sh 03_unicycler_output/final_assemblies/SRR18460306.assembly.fasta > 04_assembly_analyses/stats/SRR18460306.assembly.stats.txt # Get assembly stats for this assembly
stats.sh 03_unicycler_output/final_assemblies/SRR18460307.assembly.fasta > 04_assembly_analyses/stats/SRR18460307.txassembly.stats.txt # Get assembly stats for this assembly
stats.sh 03_unicycler_output/final_assemblies/combined.assembly.fasta > 04_assembly_analyses/stats/combined.assembly.stats.txt # Get assembly stats for this assembly

# Annotate the genomes with PGAP
mkdir 05_pgap_annotation/ # Make folder to hold the data
pgap.py --no-self-update --report-usage-false --no-internet --ignore-all-errors -c 16 -m 100g -g 03_unicycler_output/final_assemblies/SRR18460304.assembly.fasta -s 'Sphingomonas sediminicola' -o 05_pgap_annotation/SRR18460304/ # Annotate the genome
pgap.py --no-self-update --report-usage-false --no-internet --ignore-all-errors -c 16 -m 100g -g 03_unicycler_output/final_assemblies/SRR18460303.assembly.fasta -s 'Sphingomonas sediminicola' -o 05_pgap_annotation/SRR18460303/ # Annotate the genome
pgap.py --no-self-update --report-usage-false --no-internet --ignore-all-errors -c 16 -m 100g -g 03_unicycler_output/final_assemblies/SRR18460305.assembly.fasta -s 'Sphingomonas daechungensis' -o 05_pgap_annotation/SRR18460305/ # Annotate the genome
pgap.py --no-self-update --report-usage-false --no-internet --ignore-all-errors -c 16 -m 100g -g 03_unicycler_output/final_assemblies/SRR18460306.assembly.fasta -s 'Sphingomonas sediminicola' -o 05_pgap_annotation/SRR18460306/ # Annotate the genome
pgap.py --no-self-update --report-usage-false --no-internet --ignore-all-errors -c 16 -m 100g -g 03_unicycler_output/final_assemblies/SRR18460307.assembly.fasta -s 'Sphingomonas sediminicola' -o 05_pgap_annotation/SRR18460307/ # Annotate the genome
pgap.py --no-self-update --report-usage-false --no-internet --ignore-all-errors -c 16 -m 100g -g 03_unicycler_output/final_assemblies/combined.assembly.fasta -s 'Sphingomonas sediminicola' -o 05_pgap_annotation/combined/ # Annotate the genome
rm -f *.yaml # Remove unwanted files
rm *.fasta # Remove unwanted files

# Search for Nod and Nif proteins in the annotated proteomes
mkdir 06_sym_protein_analysis/ # Make folder to hold the data
echo '>Q1M7W9_RHIJ3_NodA' > sym_proteins.fasta # Create query file with Nod and Nif protein sequences
echo 'MSSEVRWKICWENELEASDHAELADFFCKTYGPTGAFNAKPFETGRSWGGARPERRAIAYDSHGVASHMGLLRRFIKVGTTDLLVAELGLYGVRPDLEGLGIAHSVRAMFPILRELSVPFAFGTVRHAMRNHMERYCRDGTANIMTGLRVRSTLPDAHSDLPATRTEDVLVLVVPVDRPMTEWPAGSLIERNGSEL' >> sym_proteins.fasta # Create query file with Nod and Nif protein sequences
echo '>Q1M7W8_RHIJ3_NodB' >> sym_proteins.fasta # Create query file with Nod and Nif protein sequences
echo 'MKRPAYMSEVPVNHTSGQEARCVYLTFDDGPNPFCTPQILDVLAEHRVPATFFAIGSYVKDHPELIRRLVAEGHDVANHTMTHPDLATCDPKDVKREIDEAHQAIVSACPQALVRHLRAPYGVWTEDVLSASVRAGLGAVHWSADPRDWSCPGVDVIVDEVLAAARPGAIVLLHDGCPPDEVEQCSLAGLRDQTLIALSRIIPALHSRGFEIRSLP' >> sym_proteins.fasta # Create query file with Nod and Nif protein sequences
echo '>Q1M7W7_RHIJ3_NodC' >> sym_proteins.fasta # Create query file with Nod and Nif protein sequences
echo 'MTLLATTSIAAISLYAMLATVYKSAQVFHARRTTISTTPAKDIETNPVPSVDVIVPCFNEDPIVLSECLASLAEQDYAGKLRIYVVDDGSKNRDAVVAQRAAYADDERFNFTILPKNVGKRKAQIAAITQSSGDLILNVDSDTTIAPDVVSKLAHKMRDPAVGAAMGQMKASNQADTWLTRLIDMEYWLACNEERAAQARFGAVMCCCGPCAMYRRSAMLSLLDQYETQLYRGKPSDFGEDRHLTILMLSAGFRTEYVPSAIAATVVPDTMGVYLRQQLRWARSTFRDTLLALPVLPGLDRYLTLDAIGQNVGLLLLALSVLTGIGQFALTATLPWWTILVIGSMTLVRCSVAAYRARELRFLGFALHTLVNIFLLIPLKAYALCTLSNSDWLSRGSVAIAPTVGQQGATKMPGRATSEIAYSGE' >> sym_proteins.fasta # Create query file with Nod and Nif protein sequences
echo '>Sphingomonas_NodA' >> sym_proteins.fasta # Create query file with Nod and Nif protein sequences
echo 'MSLKVQWKLCWENQLEAADHEELSEFFRKSYGPTGAFHAKPFEGGRSWAGARPERRAIAYDSQTKDVIGIASHMGVLRRYIKVGPTDLLVAELGLYAVRPDLENQGIAHSVGALIPHLQELGVPFGFGAVRSALERVAHRLYERGMASILTGVRVRSSIAEVNPDLPSTRTEDPLVVVFPVGQPMSDWPPGTLIERNGMEL' >> sym_proteins.fasta # Create query file with Nod and Nif protein sequences
echo '>Sphingomonas_NodB' >> sym_proteins.fasta # Create query file with Nod and Nif protein sequences
echo 'MLDALDEARLPVLDLDELLADPDANSVYLTFDDGPSPVCTPTILDVLAERKVPATFFVIGNYAGGDPELLEAIQSEGHRIANHTMTHPDLSKLGDAQIDREMEEADSAIESALPQAAVRFFRAPYGYWDEEVRAISASARYRGVHWSADDPRDYLRPRSAADAIVDAVLASVRPGAIVLLHDGCPPDESGALTSLRDQTLMAISRIIPALHERGFAIRPLPPHH' >> sym_proteins.fasta # Create query file with Nod and Nif protein sequences
echo '>Sphingomonas_NodC' >> sym_proteins.fasta # Create query file with Nod and Nif protein sequences
echo 'MTELLGTTSTLSISLYAALSTAYKGVQAIYALPTNTTAASTPVKDGAEVPSVDVIVPCYNEDPRVLLCCLASIANQDYAGELRVYVIDDGSGNRAALTTAHDHFAPDPRFIFILLPKNVGKRKAQIQAIRRSVGDLILNVDSTTIAPDVVTKLALKMYSPAVGAAMGQLTASSARNWLTRLIDMEYWLACNEERAAQARFGAVMCCCGPCAMYRRSALLLLLDQYESQTFRGKPSDFGEDRHLTILMLKAGLRTEYVPDAIAATVVPDSLGPYLRQQLRWARSTFRDTLLALRLLPGLDRYLTLDVIGQNGGLLLLALSVLTGIGQFALTATVPWWTILMIASMTMVRCGVAAFRARELRFLGFSSLLVPPLLLARKKRAYALCTLSNSDWLSRG' >> sym_proteins.fasta # Create query file with Nod and Nif protein sequences
echo '>Q1M7Z2_RHIJ3_NifH' >> sym_proteins.fasta # Create query file with Nod and Nif protein sequences
echo 'MAALRQIAFYGKGGIGKSTTSQNTLAALVDHGQKILIVGCDPKADSTRLILNSKAQDTVLDLAATRGSVEDLELEDVLKVGYKGIKCVESGGPEPGVGCAGRGVITSINFLEENGAYNDVDYVSYDVLGDVVCGGFAMPIRENKAQEIYIVMSGEMMALYAANNIARGILKYAAGGSVRLGGLICNERQTDRELDLAEALAAKLNSKLIHFVPRDNIVQHAELRKMTVIQYAPDSQQAAEYRTLAQRIHDNSGKGTIPTPITMEELEDMLLDFGIMKTDEQMLAELQARDAKLKAAQ' >> sym_proteins.fasta # Create query file with Nod and Nif protein sequences
echo '>Q1M7Z3_RHIJ3_NifD' >> sym_proteins.fasta # Create query file with Nod and Nif protein sequences
echo 'MTFKYANDSDLHAKLIADVLSQYPDKAAKRRSKHLSLATSEKDAGEDPNAISECEVKSNIKSVPGVMTIRGCAYAGSKGVVWGPIKDMVHISHGPVGCGQYSWSQRRNYYVGLTGIDTFVTMQFTSDFQEKDIVFGGDKKLENVIDEIAELFPLSNGVTLQSECPIGLIGDDIEAVARKKAKEHATTVVPVRCEGFRGVSQSLGHHIANDAIRDWVFDKKDIKFDPGPYDVNVIGDYNIGGDAWASRILLEEIGLRVVGNWSGDATLAEVERAPRAALNLIHCYRSMNYISRHMEEKYGIPWMEYNFFGHSQIDASLRDIAKHFGPEIQEKAEKVIAKYQPLVWAVIDKYWQRLSGKRVMLYVGGLRPRHVVTAYEDLGMEIVGTGYEFGHGDDYQRTGHYVKEGTLIYDDVTGYELEKFIEGIRPDLVGSGVKEKYPVQKMGIPFRQMHSWDYSGPYHGYDGFSIFARDMDMAINNPVWGLYDAPWKNDRASADGSSMRT' >> sym_proteins.fasta # Create query file with Nod and Nif protein sequences
echo '>Q1M7Z4_RHIJ3_NifK' >> sym_proteins.fasta # Create query file with Nod and Nif protein sequences
echo 'MPQSAEKALDHAPLFCEPEYRQMLAEKKLNFERPHPEKVVSDQREFTKTWEYREKNLARKALVVNPAKACQPLGAVFAAAGFERTMSFVHGSQGCVAYYRSHLSRHFKEPSSVVSSSMTEDAAVFGGLKNMVDGLANTYKLYNPNMIAVSTTCMAEVIGDDLHGFIENAKSEGSVPRDFDVPFAHTPAFVGSHVDGYDSMVKGVLENFWKGTARNEATATINIIPGFDGFCVGNNRELKRLLDLMQVTYMFIQDASDQFDTPSDGKFRMYDGGTSINDVKAALNAEWTLSLQYYNTRKTLDYCRDVGQAATSFHYPLGVEATDELLMVISEISSREIPEAIRLERGRLIDAMADSQAWLYGKKYAIYGDPDFVYAMARFIMETGGEPTHCLATNGTSAWEDEMKELLASSPFGKNAQVWPGKDLWALRSLLFTEPVDLLIGNSYGKYLERDTGTPLVRLMFPIFDRHHHHRFPLMGYQGGLRLLTSILDKIFDNLDRETMHAGVTDYSYDLTR' >> sym_proteins.fasta # Create query file with Nod and Nif protein sequences
echo '>Sphingomonas_NifH' >> sym_proteins.fasta # Create query file with Nod and Nif protein sequences
echo 'MSSLRQIAFYGKGGIGKSTTCQNTLAALAELGHRMLIAGCDPKADSTRLMLHAKAQDSILSLAAEAGSVEDLELEDVMKIGPKDIRCVDSGGPLPIASGKGRVGKTSINLLEGDGAGEDRANVSYDVLGDVYCYGFAMPIRIHDLQEIYIVMSGEMMASYGANVISKGILKYANSGGVRLGKLVCTERQNDVELGPLEFIAKKLGTQLIHFVLQNSAVQQCWTTPHDRDPLCAGQQAGRRISRGRPQRRRSAGGQRPRADQHGRARRPADGARHHEERRREPGRPDRRRPRHGL' >> sym_proteins.fasta # Create query file with Nod and Nif protein sequences
echo '>DOA9_SctQ' >> sym_proteins.fasta # Create query file with Nod and Nif protein sequences
echo 'MGEPALFQPAAKLSHEVVSWLNETAAPRTVLQSRIGDKPLSIRMSRLVWQAEPYATSVLDCVFCAEGETAVLSLPRLLVEALISTAQYGLTLPSDPTRSLLLELALEPWLAALEIVLARNLQLIRVEDATANDPYLEFDVTFGPLAAKARLFLFAPLDGLVPSAFRVLGELIGQSPRELGEISSELPVVIAGEIGSLRAPIKLLRQAQPGDALLPEVIPFAHGQLILAADKLWAPAQVAGDRLILRGPFRLQSHPLRYANMTISPQAEQAISPSEADIDSVEITLVFECGRWPIPLGTLRSINEGHVFELGRQVDGPVDIVANGQLIGRGDIVRVGEALGIRLLSKLAVNG' >> sym_proteins.fasta # Create query file with Nod and Nif protein sequences
echo '>Sphingomonas_SctQ' >> sym_proteins.fasta # Create query file with Nod and Nif protein sequences
echo 'MIVLSLSRREIEALISTVQSGLALPKEPTQSLILELALEPLIARLESQLRTFVQILRVGVAITPAPYDEFIRSIGPVSGKVRLFLFSPLDGRVPSAFRALDELLGQLGNLPSKINSKLPITTIMEIGFLSAFESLLRNARTGDALLPRVSPFGRGQISLSAGDTWTAANLCGDHLVLRPPFSKLSAHLENAHMTSVPEEQQAESLKNRISQAKLSMIAELGESYISVSEFLGLNVGDVISLAKPVHSGLKIKVGDRLKFIGSPGTVKDRVAVQIDEIVSEGAEELDE' >> sym_proteins.fasta # Create query file with Nod and Nif protein sequences
mv sym_proteins.fasta 06_sym_protein_analysis/ # Create query file with Nod and Nif protein sequences
cat 05_pgap_annotation/SRR18460303/annot.faa | sed 's/>/>SRR18460303_/' > 06_sym_protein_analysis/combined_proteomes.fasta # Combine the proteomes into a single file
cat 05_pgap_annotation/SRR18460304/annot.faa | sed 's/>/>SRR18460304_/' >> 06_sym_protein_analysis/combined_proteomes.fasta # Combine the proteomes into a single file
cat 05_pgap_annotation/SRR18460306/annot.faa | sed 's/>/>SRR18460306_/' >> 06_sym_protein_analysis/combined_proteomes.fasta # Combine the proteomes into a single file
blastp -query 06_sym_protein_analysis/sym_proteins.fasta -subject 06_sym_protein_analysis/combined_proteomes.fasta > 06_sym_protein_analysis/blast_results.full.txt # Run BLASTp to search for the Nod and Nif proteins
blastp -query 06_sym_protein_analysis/sym_proteins.fasta -subject 06_sym_protein_analysis/combined_proteomes.fasta -outfmt '6 qseqid sseqid pident length mismatch gapopen qlen qstart qend slen sstart send bitscore evalue sstrand' > 06_sym_protein_analysis/blast_results.table.txt # Run BLASTp to search for the Nod and Nif proteins
cut -f2 06_sym_protein_analysis/blast_results.table.txt > 06_sym_protein_analysis/hit_list.txt # Get list of hits
pullseq -i 06_sym_protein_analysis/combined_proteomes.fasta -n 06_sym_protein_analysis/hit_list.txt | tr '\n' '\t' | tr '>' '\n>' > 06_sym_protein_analysis/hit_sequences.txt # Get the sequences of the hits
sed -i 's/\t/___/' 06_sym_protein_analysis/hit_sequences.txt # Fix formatting of file
sed -i 's/\t//g' 06_sym_protein_analysis/hit_sequences.txt # Fix formatting of file
sed -i 's/___/\t/g' 06_sym_protein_analysis/hit_sequences.txt # Fix formatting of file