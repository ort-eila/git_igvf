// Enable DSL2
nextflow.enable.dsl=2

include {downloadGenome} from './../../nf_processes/nf_prcs_download_genome.nf'
include {downloadGTF} from './../../nf_processes/nf_prcs_download_gtf.nf'
include {run_seqspec} from './../../nf_processes/nf_seqspec.nf'


workflow {
    downloadGenome (Channel.of(params.GENOME_FASTA))
    // this will print the full path. to access the value downloadGenome.out.genome will be enough
    // seqspec 
    run_seqspec(params.SPEC_YAML)
    run_seqspec.out.seqspec_out.view()
    // worked 
    // downloadGenome.out.genome.view()
    
    // fa_path = downloadGenome.out
    // Didnt work
    // downloadGTF(params.GENOME_GZ_GTF)
    // downloadGTF.out.gtf.view()
    // gtf_path = downloadGTF.out
}
