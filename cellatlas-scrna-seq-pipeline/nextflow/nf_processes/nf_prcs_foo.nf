// Enable DSL2
nextflow.enable.dsl=2

// parameters that should be piped from the workflow 

process foo {
    input:
      path x
    output:
      path 'foo.txt'
    script:
      """
      cat ${x} > foo.txt
      """
}