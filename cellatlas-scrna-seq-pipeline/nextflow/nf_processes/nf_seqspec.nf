// Enable DSL2
nextflow.enable.dsl=2

// parameters that should be piped from the workflow 

process run_seqspec {
  debug true
  container 'eilalan/igvf-seqspec-cellatlas:latest'
  input:
    path spec_yaml
  output:
    path "seqspec.print.out" , emit: seqspec_out
  script:
  """
    # ls > seqspec.print.out
    seqspec print $spec_yaml > seqspec.print.out
  """
}