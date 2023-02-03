from Bio import SeqIO


id_list_r1=[]
with open("./data/downsampled_ERR2984773_R1.fastq") as handle:
    for record in SeqIO.parse(handle, "fastq"):
        id_list_r1.append(record.id)
        
print(id_list_r1[1])

id_list_r2=[]
with open("./data/downsampled_ERR2984773_R2.fastq") as handle:
    for record in SeqIO.parse(handle, "fastq"):
        id_list_r2.append(record.id)

        
if id_list_r1 == id_list_r2:
    print("The lists are identical")


r1_edit = [sub[: -2] for sub in id_list_r1]

r2_edit = [sub[: -2] for sub in id_list_r2]


if r1_edit == r2_edit:
    print("The lists are identical")
    


