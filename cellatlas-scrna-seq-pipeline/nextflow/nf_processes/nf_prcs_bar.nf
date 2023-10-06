// Enable DSL2
nextflow.enable.dsl=2

// parameters from the workflow

process bar {
    input:
      path x
    output: 
      path "bar.txt"
    script:
    """ 
    echo input is ${x}
    cat ${x} > bar.txt
    """   
}