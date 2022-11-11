#!/bin/bash
#set -x
#Andrei Bombin, Katrina Hofstetter, Vishnu Raghuram
#2022-11-10
#Read lab hackathon 
#Description:

version="0.1"
script_1="script_name"

USAGE=$(echo -e "\n\
READ LAB HACKATHON UPSTREAM_SCRIPT  \n\n\
VERSION: $script_1 v$version \n\n\
USAGE:   \
$script_1 [options] -x read1.fq -y read2.fq -r reference.fasta \n\n\
FLAGS: \n\
  -x | --R1           REQUIRED: Read1 in fastq\n\
  -y | --R2           REQUIRED: Read1 in fastq\n\
  -r | --reference    REQUIRED: Reference FASTA format\n\
  -a | --alt_align    DEFAULT: bwa; specify to change to bowtie2\n\
  -o | --output       Name of output directory\n\
  -f | --force        Force overwrite existing results directory\n\
  -h | --help         Print this help message and exit\n\
  -v | --version      Print version and exit\n\n\
SOURCE:  COMING SOON\n\n\
")

force=0
alt_align=0

if [[ ! $1 ]]
 then
	echo -e "$USAGE"
	exit
fi	

while :; do
	case $1 in
		-h|-\?|--help) #Print usage and exit
			echo -e "$USAGE"
			shift
			exit
			;;
			
		-x|--R1) #Save input with specified path to $fastq_1_path
			if [[ $2 && $2 != -* ]]
			 then
				fastq_1_path=$2
				bname_R1=$(basename $fastq_1_path)
				echo -e "Processing $fastq_1_path ..."
				shift
			else
				1>&2 echo -e " -x requires an argument.\n$USAGE "
				exit 1
			fi
			;;
            
		-y|--R2) #Save input with specified path to $fastq_2_path
			if [[ $2 && $2 != -* ]]
			 then
				fastq_2_path=$2
				bname_R2=$(basename $fastq_2_path)
				echo -e "Processing $fastq_2_path ..."
				shift
			else
				1>&2 echo -e " -y requires an argument.\n$USAGE "
				exit 1
			fi
			;;
            
		-r|--reference) #Save input with specified path to $fasta_path
			if [[ $2 && $2 != -* ]]
			 then
				reference_path=$2
				echo -e "Processing $reference_path ..."
				shift
			else
				1>&2 echo -e " -r requires an argument.\n$USAGE "
				exit 1
			fi
			;;

		-a|--alt_align)
			alt_align=$((alt_align + 1))
			shift
			continue
			;;
        
		-o|--output)
			outdir=$2
			shift
			continue
			;;
        
		-f|--force)
			force=$((force + 1))
			shift
			continue
			;;
		
		-v|--version)
			echo -e "$script_1 v$version"
			shift
			exit
			;;
		--)
			shift
			break
			;;
		-?*)
			1>&2 echo -e " $1 is an invalid option. \n$USAGE "
			shift
			exit 1
			;;
		*)
			shift
			break
	esac
	shift
done


#check if results directory already exists
if [[ -d $outdir ]]
then
	if [[ $force > 0 ]]
	 then
		echo "Results directory already exists, -f specified, overwriting..."
		rm -rf $outdir
		mkdir $outdir
		outdir_check="pass"
	else	
		1>&2 echo "Results directory already exists, cannot overwrite. Use option -f to force overwrite"
		#Error report file
		echo -e 
		exit 1
	fi	
else	
	mkdir $outdir
	outdir_check="pass"
fi

# validate input fasta
validate_fasta () {
	if [[ -f $1 ]] #Check if input is a file
	 then
			if [[ $(grep -q "^@" $1 ; echo $?) -eq 1 && $(seqkit seq -t dna -n --quiet $1 | wc -l) -ge 1 ]] # if file is NOT fastq and checks if seqkit can parse the file 
			 then	
				if [[ $(grep -v ">" $1 | grep -q -i "[^ATCGNWSMKRY]"; echo $?) -eq 1 ]] #check if seqence has characters other than ATGCN
				 then
					1>&2 echo -e "$1 is a valid fasta file"
				else
					1>&2 echo -e "Seqence has non-standard nucleic acid characters\n$USAGE" 
				echo -e 
					exit 1 
				fi
			else
				1>&2 echo -e "Input file not in FASTA format\n$USAGE"
				echo -e 
				exit 1
			fi
	fi	
	else
		1>&2 echo -e "Invalid input\n$USAGE"
		echo -e 
		exit 1
	fi
}

# validate input fastqs
# validate input fasta
validate_fastq () {
	if [[ -f $1 ]] #Check if input is a file
	 then
		if [[ $(grep -q "^@" $1 ; echo $?) -eq 0 && $(seqkit seq -t dna -n --quiet $1 | wc -l) -ge 1 ]] # if file is fastq and checks if seqkit can parse the file 
		 then
			1>&2 echo -e "$1 is a valid fastq file"
		else
			1>&2 echo -e "Input file not in FASTQ format\n$USAGE"
			echo -e 
			exit 1
		fi	
	else
		1>&2 echo -e "Invalid input\n$USAGE"
		echo -e 
		exit 1
	fi
}

## Fastp quality filtering
fastp --in1 $fastq_1_path --in2 $fastq_1_path \
--detect_adapter_for_pe \
--adapter_fasta ./data/NexteraPE-PE.fa \
--cut_front \
--out1 $outdir\\$bname_R1\_filtered.fastq \
--out2 $outdir\\$bname_R2\_filtered.fastq

if filesize  0; contiue
else exit 1


##alignment

if [[ $alt_align > 0 ]]
 then
    bowtie2-build $reference_path $( basename($reference_path) )
	bowtie2 -x $reference_path -1 $outdir\\$bname_R1\_filtered.fastq -2 $outdir\\$bname_R2\_filtered.fastq | samtools view -bSh - > $outdir\\$outdir-bowtie.bam
else	
	echo "Using bwa for alignment"
    bwa index $reference_path
    bwa mem $reference_path $outdir\\$bname_R1\_filtered.fastq $outdir\\$bname_R2\_filtered.fastq > $outdir\\$outdir-bwa.bam
fi	




