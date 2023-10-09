// Enable DSL2
nextflow.enable.dsl=2

process run_cellatlas_build {
  debug true
  cpus 4
  cache 'lenient'
  container 'eilalan/cellatlas_env:latest'

  input:
    val modality
    path spec_yaml
    path genome_fasta
    path genome_gtf
    path feature_barcodes
    path r1
    path r2
    
  output:
    path 'rna_output', emit: cellatlas_built_rna_output
    path 'rna_alignment_log', emit: cellatlas_built_rna_align_log

  script:
  """
    mkdir out
    echo $workDir
    echo "cellatlas build -o out -m $modality -s $spec_yaml -fa $genome_fasta -g $genome_gtf -fb $feature_barcodes $r1 $r2"
    ls > rna_output
    ls > rna_alignment_log
  """
}

 // echo $cellatlasBuildCmdLine > rna_alignment_log
