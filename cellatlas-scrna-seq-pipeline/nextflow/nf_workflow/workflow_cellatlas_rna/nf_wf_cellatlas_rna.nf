// TODO: rename the output with the sample_id - could be something like that path 'chunk_*'
// TODO: collate for parameters that are multiplies
// TODO: work with couple of files
// TODO: show lucas the use of the file command
// Enable DSL2
nextflow.enable.dsl=2

include {downloadGenome} from './../../nf_processes/nf_prcs_download_genome.nf'
include {downloadGTF} from './../../nf_processes/nf_prcs_download_gtf.nf'
include {run_seqspec_print} from './../../nf_processes/nf_prcs_seqspec_print.nf'
include {run_cellatlas_build} from './../../nf_processes/nf_prcs_cellatlas_build.nf'

workflow {

    // STEP 1: input processing
    modality = channel.value(params.MODALITY)
    println modality

    feature_barcodes_ch = channel.value(params.FEATURE_BARCODES)
    println feature_barcodes_ch

    fastqs_ch = Channel.fromPath(params.FASTQS_CH)
                       .splitCsv(sep: '\t',header: true)
                        | map { record -> [record.sample_id, record.fastq1,record.fastq2] }
                        | unique
                        | view

    // STEP  2 - download the genome - worked
    genome_fasta_ch = channel.value(file(${params.GENOME_FASTA}))
    println genome_fasta_ch

    // STEP 3 - download the gtf
    // println params.GENOME_GZ_GTF
    genome_gtf_ch = channel.value(file(params.GENOME_GZ_GTF))
    println genome_gtf_ch

    // STEP  4 - download the spec_yaml
    seqspec_yaml_ch = channel.value(file(params.SEQSPEC_PATH))
    println seqspec_yaml_ch

    // STEP 5 - call run_cellatlas_build
    // print implicit variable
    print "baseDir is $baseDir, launchDir is $launchDir, moduleDir is $moduleDir, nextflow is $nextflow, \
           params is $params, projectDir is $projectDir, workDir is $workDir, workflow is $workflow"
    run_cellatlas_build(modality,feature_barcodes_ch,genome_fasta_ch,genome_gtf_ch,seqspec_yaml_ch,fastqs_ch)

}
