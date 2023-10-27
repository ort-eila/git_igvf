
// Enable DSL2
nextflow.enable.dsl=2

// kb ref \
	// -k 21 \
	// -i index.idx \
	// -g t2g.txt \
	// -f1 transcriptome.fa \
	// http://ftp.ensembl.org/pub/release-104/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz \
	// http://ftp.ensembl.org/pub/release-104/gtf/homo_sapiens/Homo_sapiens.GRCh38.104.gtf.gz


// input:
//     tuple path(idx_out), path(fastq1), path(fastq2)
process run_kb_ref {
  label 'bustool'
  debug true
  executor = 'local' // Or specify your desired executor
  disk '512 GB'
  // conda 'kb-python'
  input:
    path dna_assempbly_fa_gz
    path gtf_gz
  output:
    path "index.idx",emit: index_out
    path  "t2g.txt",emit: t2g_txt_out
    path "ls_output.txt"
  script:
  """
  echo dna_assempbly_fa_gz is $dna_assempbly_fa_gz
  echo gtf_gz is $gtf_gz
  kb info > kb_info.txt
  kb ref -k 21 -m 256G -i index.idx -g t2g.txt -f1 transcriptome.fa $dna_assempbly_fa_gz $gtf_gz
  ls > ls_output.txt
  echo finished callling kb ref
  """
}


process run_download_kb_idx {
  label 'bustool'
  debug true
  executor = 'local' // Or specify your desired executor
  disk '512 GB'
  input:
    val org
  output:
    path "index.idx",emit: index_out
    path  "t2g.txt",emit: t2g_txt_out
  script:
  """
  echo "kb ref -d $org  -i index.idx -g t2g.txt --verbose"
  kb ref -d $org -i index.idx -g t2g.txt --verbose
  ls -l 
  """
}

// !time kb count -i ref_cDNA/transcriptome.idx 
// -g ref_cDNA/transcripts_to_genes.txt 
// -x $(seqspec index -t kb -m RNA -r RNA-R1.fastq.gz,RNA-R2.fastq.gz broad_human_jamboree_test_spec-eugenio-fix.yaml)
//  -o out/ 
// -w sai_192_whitelist.txt 
// rna/BMMC_single_donor_RNA_L001_R1.fastq.gz rna/BMMC_single_donor_RNA_L001_R2.fastq.gz


// read the technology 
// TODO: check if it possible to have 3 RNA seq?
// #technology.map{ $technology -> file.text.trim() } .set {technology_values} 
//   #echo $technology_values
//   #kb count -i $index_file -g $t2g_txt -x $technology_values -o out --h5ad -t $task.cpus $fastq1 $fastq2
//input_files.map{ file -> file.text.trim() } .set { input_values } 
// kb count -i index.idx -g t2g.txt -x 0,0,16:0,16,28:1,0,102 -w RNA-737K-arc-v1.txt -o rna_cellatlas_out --h5ad -t 2 fastqs/rna_R1_SRR18677629.fastq.gz fastqs/rna_R2_SRR18677629.fastq.gz
process run_kb_count {
  label 'bustool'
  debug true
  executor = 'local' // Or specify your desired executor
  cpus 8
  // conda 'kb-python'
  input:
    path index_file
    path t2g_txt
    path gtf_gz
    tuple path(fastq1), path(fastq2), path(fastq3), path(spec_yaml)
    path technology
  output:
    path out, emit: kb_count_out
  script:
  """
  echo start run_kb_count !!!
  echo $index_file
  echo $t2g_txt
  echo $fastq1
  echo $fastq2
  echo $technology
  content=\$(cat $technology)
  echo \$content
  mkdir out
  echo kb count -i $index_file -g $t2g_txt -x \$content -o out --h5ad -t $task.cpus $fastq1 $fastq2
  kb count -i $index_file -g $t2g_txt -x \$content -o out --h5ad -t $task.cpus $fastq1 $fastq2
  ls 
  ls out
  echo finished run_kb_count
  """
}