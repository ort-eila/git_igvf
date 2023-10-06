// Enable DSL2
nextflow.enable.dsl=2

include {seqspec} from './../../nf_processes/nf_seqspec.nf'

// will run the default workflow. if we have name to the workflow, we need to add an entry point
workflow {
    seqspec()

}
