// Enable DSL2
nextflow.enable.dsl=2

// parameters that should be piped from the workflow 

process seqspec {
    script:
      """
      seqspec
      """
}