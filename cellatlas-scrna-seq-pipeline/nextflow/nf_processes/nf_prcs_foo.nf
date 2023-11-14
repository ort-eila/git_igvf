// Enable DSL2
nextflow.enable.dsl=2
include { sayHello } from './../nf_modules/module1.nf'

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