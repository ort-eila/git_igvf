// TODO
// 1. how to run the docker from the http://github and not from the local machine copy
// 2. run on Anvil
// 3. add configuration under each task and then the workflow can call each one of them

// Enable DSL2
nextflow.enable.dsl=2

include {foo} from './../../nf_processes/nf_prcs_foo.nf'
include {bar} from './../../nf_processes/nf_prcs_bar.nf'

data = channel.fromPath('./../../nf_data/nf_data_workflow_1/*.txt')

// will run the default workflow. if we have name to the workflow, we need to add an entry point
workflow {
    // option 1:
    // foo(data)
    // bar(data)

    // option 2:
    // bar(foo(data))

    // option 3:
    foo(data)
    foo.out.view()
    bar(foo.out)
    bar.out.view()
}
