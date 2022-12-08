

if [ ! -f ./work/downsampled_ERR2984773_filtered_R1.fastq ]  || [ ! -f ./work/downsampled_ERR2984773_filtered_R2.fastq ] ; then
    echo "File not found"
    exit 2
fi

echo 'Files exist'

fastp_out1=$(wc -c ./work/downsampled_ERR2984773_filtered_R1.fastq | awk '{print $1}')

fastp_out2=$(wc -c ./work/testFastp.fasta | awk '{print $1}')

checkNumb=50

if [ $fastp_out2 -lt $checkNumb ] || [ $fastp_out1 -lt $checkNumb ]  ; then
echo 'File is too small'
    exit 22
fi

echo 'Continue with alignment'

