import pytest

from Bio import SeqIO

def check_fastqIds(r1, r2):
  id_list_r1=[]
  id_list_r2=[]
  # read Ids from r1 
  with open(r1) as handle:
    for record in SeqIO.parse(handle, "fastq"):
        id_list_r1.append(record.id)
  # read Ids from r2      
  with open(r2) as handle:
    for record in SeqIO.parse(handle, "fastq"):
        id_list_r2.append(record.id)
        
  return id_list_r1, id_list_r2


id_list_r1, id_list_r2 = check_fastqIds(r1 = './data/downsampled_ERR2984773_R1.fastq', r2 = './data/downsampled_ERR2984773_R2.fastq')

# if needs to fail both tests 
#id_list_r1, id_list_r2 = check_fastqIds(r1 = './data/downsampled_ERR2984773_R1.fastq', r2 = './tests/data/downsampled_ERR2984773_R2_fail.fastq')


def test_exact_match():
  assert id_list_r1 == id_list_r2


def test_filter_sort_match():
  r1_edit = sorted([sub[: -2] for sub in id_list_r1])
  r2_edit = sorted([sub[: -2] for sub in id_list_r2])
  assert r1_edit == r2_edit
  


  
    
    
