// Enable DSL2
nextflow.enable.dsl=2

// parameters that should be piped from the workflow 

process run_seqspec {
    container 'eilalan/igvf-seqspec-cellatlas:latest'

    input:
    val spec_yaml
    output:
    path "seqspec.print.out" , emit: seqspec_out
    script:
    """
      cd /cellatlas/examples/multi-dogmaseq-lll
      seqspec print $spec_yaml > seqspec.print.out
    """


}