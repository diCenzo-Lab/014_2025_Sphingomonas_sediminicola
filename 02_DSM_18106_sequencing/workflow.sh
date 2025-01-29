# Get the sequencing data
mkdir basecalled_data/ # Make directory to hold data
cp /datadisk1/Sequencing_data/Nanopore_data/Open_Plastic_Microbes/Aug2_OPplate2/20240802_1312_P2S-01256-A_PAW43427_9cacba41/basecalled_data/SQK-RBK114-96_barcode63.fastq.gz basecalled_data/DSM18106.fastq.gz # Get ONT data

# Perform genome assembly with an automated pipeline that includes CheckM QC and GTDB-tk classification
ls -1 basecalled_data/ > temp1.txt # Make input file for genome assembly pipeline
ls -1 basecalled_data/ | sed 's/.fastq.gz//' > temp2.txt # Make input file for genome assembly pipeline
paste temp2.txt temp1.txt > sample_list.txt # Make input file for genome assembly pipeline
rm temp1.txt temp2.txt # Make input file for genome assembly pipeline
sed -i 's/_nanopore\t/\t/' sample_list.txt # Make input file for genome assembly pipeline
nanopore_batch_assembly.sh sample_list.txt /workingdisk1/genomes/George/Sphingomonas_sediminicola/02_DSM_18106_sequencing/basecalled_data/ 16 2.8m 100 200 # Run genome assembly pipeline
mv 5_Good_assemblies/Sphingomicrobium_sediminicola_DSM18106.fasta 5_Good_assemblies/Sphingomonas_sediminicola_DSM18106.fasta # Rename output file

# Make home assembly directory and switch into it
mkdir 6_PGAP_annotations/  # Make directory to hold data
cd 6_PGAP_annotations/ # Change directory

# Make template.yaml file
echo 'fasta:' > pgap.yaml
echo '    class: File' >> pgap.yaml
echo '    location: XXX.pgap.fasta' >> pgap.yaml
echo 'submol:' >> pgap.yaml
echo '    class: File' >> pgap.yaml
echo '    location: XXX.pgap.submol.yaml' >> pgap.yaml

# Make template.submol.yaml file
echo "organism:" > pgap.submol.yaml
echo "    genus_species: 'XXX'" >> pgap.submol.yaml
echo "    strain: 'YYY'" >> pgap.submol.yaml
echo "contact_info:" >> pgap.submol.yaml
echo "    last_name: 'diCenzo'" >> pgap.submol.yaml
echo "    first_name: 'George'" >> pgap.submol.yaml
echo "    email: 'george.dicenzo@queensu.ca'" >> pgap.submol.yaml
echo "    organization: 'Queens University'" >> pgap.submol.yaml
echo "    department: 'Department of Biology'" >> pgap.submol.yaml
echo "    street: '116 Barrie Street'" >> pgap.submol.yaml
echo "    city: 'Kingston'" >> pgap.submol.yaml
echo "    state: 'ON'" >> pgap.submol.yaml
echo "    postal_code: 'K7P0S7'" >> pgap.submol.yaml
echo "    country: 'Canada'" >> pgap.submol.yaml
echo "authors:" >> pgap.submol.yaml
echo "    - author:" >> pgap.submol.yaml
echo "        last_name: 'Esme'" >> pgap.submol.yaml
echo "        first_name: 'Oona'" >> pgap.submol.yaml
echo "    - author:" >> pgap.submol.yaml
echo "        last_name: 'diCenzo'" >> pgap.submol.yaml
echo "        first_name: 'George'" >> pgap.submol.yaml
echo "        middle_initial: 'C'" >> pgap.submol.yaml

# Run genome annotation
genome_annotation_batch.sh pgap.yaml pgap.submol.yaml /workingdisk1/genomes/George/Sphingomonas_sediminicola/02_DSM_18106_sequencing/ 16 # Run genome annotation pipeline
pigz -p 16 -r * # Zip files to save space
cd ../ # Change directory

# Prepare the metadata
prepare_metadata_file.pl sample_list.txt # Generate metadata.txt file
mv 6_PGAP_annotations/ temp/ # Rename the PGAP output files
rename_pgap_files.pl metadata.txt # Rename the PGAP output files
mv temp/ 6_PGAP_annotations/ # Rename the PGAP output files
cd 6_PGAP_annotations/Sphingomonas_sediminicola_DSM18106/ # Change directory
rename 's/DSM18106/DSM_18106/' Sphingomonas_sediminicola_DSM18106* # Fix file names
cd .. # Change directory
pigz -p 16 -r * # Compress all files to save space

# Search for Nod proteins in the annotated proteomes
mkdir 7_sym_protein_analysis/ # Make folder to hold the data
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
mv sym_proteins.fasta 7_sym_protein_analysis/ # Create query file with Nod protein sequences
blastp -query 7_sym_protein_analysis/sym_proteins.fasta -subject 6_PGAP_annotations/Sphingomonas_sediminicola_DSM18106/Sphingomonas_sediminicola_DSM_18106.faa > 7_sym_protein_analysis/blast_results.full.txt # Run BLASTp to search for the Nod proteins
blastp -query 7_sym_protein_analysis/sym_proteins.fasta -subject 6_PGAP_annotations/Sphingomonas_sediminicola_DSM18106/Sphingomonas_sediminicola_DSM_18106.faa -outfmt '6 qseqid sseqid pident length mismatch gapopen qlen qstart qend slen sstart send bitscore evalue sstrand' > 7_sym_protein_analysis/blast_results.table.txt # Run BLASTp to search for the Nod proteins



