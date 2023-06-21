fastp --in1 "./data/downsampled_ERR2984773_R1.fastq" --in2 "./data/downsampled_ERR2984773_R2.fastq" \
--detect_adapter_for_pe \
--adapter_fasta ./data/NexteraPE-PE.fa \
--cut_front \
--out1 "./work/downsampled_ERR2984773_filtered_R1.fastq" \
--out2 "./work/downsampled_ERR2984773_filtered_R2.fastq"

rm fastp.html ./work/
rm fastp.json ./work/