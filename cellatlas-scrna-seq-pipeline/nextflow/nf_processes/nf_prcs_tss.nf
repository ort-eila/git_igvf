// Enable DSL2
nextflow.enable.dsl=2
    
process run_tss {
  debug true
  label 'tss'
  input:
    path tbi_fragments
  output:
    path "${tbi_fragments}.tss", emit: tss_fragments_out
  script:
  """
    echo 'start run_tss'
    ls /usr/local/bin/
    
    echo 'finished run_tss'
  """
}