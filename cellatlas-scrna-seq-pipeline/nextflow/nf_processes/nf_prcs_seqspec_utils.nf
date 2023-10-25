// Enable DSL2
nextflow.enable.dsl=2

// print
process run_seqspec_print {
  debug true
  label 'bustool'
  cpus 1
  input:
    tuple path(fastq1), path(fastq2), path(spec_yaml)
  output:
    path "seqspec.print.out" , emit: seqspec_out
  script:
  """
    echo start run_seqspec_print
    echo $spec_yaml
    seqspec print $spec_yaml > seqspec.print.out
    echo finished seqspec print $spec_yaml
  """
}

// working
// seqspec index -t kb -m rna -r $RNA_R1_fastq_gz,$RNA_R2_fastq_gz $spec_yaml
process run_seqspec_index_rna_kb {
  debug true
  label 'bustool'
  cpus 1
  input:
    tuple path(fastq1), path(fastq2), path(spec_yaml)
    path modified_spec_yaml
  output:
    path "seqspec.index.out" , emit: seqspec_index_out_file
  script:
  """
    echo spec_yaml is $modified_spec_yaml
    echo RNA_R1_fastq_gz is $fastq1
    echo RNA_R2_fastq_gz is $fastq2
    
    seqspec index -t kb -m rna -r $fastq1,$fastq2 $modified_spec_yaml > seqspec.index.out
    cat seqspec.index.out
    echo finished run_seqspec_index_rna   
  """
}

// check
process run_seqspec_check {
  debug true
  label 'bustool'
  cpus 1
  input:
    tuple path(fastq1), path(fastq2), path(spec_yaml)
  output:
    path "seqspec.check.out" , emit: seqspec_check_out
  script:
  """
    echo start run_seqspec_check
    echo $spec_yaml
    seqspec check $spec_yaml > seqspec.check.out
    echo finished seqspec check spec_yaml
  """
}


process run_seqspec_modify_rna {
  debug true
  label 'bustool'
  cpus 1
  input:
    tuple path(fastq1), path(fastq2), path(spec_yaml)
  output:
    path "nf_seqspec_modify.yaml", emit: seqspec_modify_rna_out
  script:
  """
  echo start run_seqspec_modify_rna
  echo $fastq1
  echo $fastq2
  echo $spec_yaml
  ls
  seqspec modify -m rna -o modrna1.yaml -r rna_R1.fastq.gz --region-id $fastq1 $spec_yaml
  seqspec modify -m rna -o modrna2.yaml -r rna_R2.fastq.gz --region-id $fastq2 modrna1.yaml
  seqspec modify -m rna -o nf_seqspec_modify.yaml -r rna_R2.fastq.gz --region-id $fastq2 modrna2.yaml
  echo finished seqspec modify
  """
}