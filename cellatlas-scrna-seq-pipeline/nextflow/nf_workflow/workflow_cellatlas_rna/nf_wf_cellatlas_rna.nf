// TODO: rename the output with the sample_id - could be something like that path 'chunk_*'
// TODO: collate for parameters that are multiplies
// TODO: work with couple of files
// TODO: show lucas the use of the file command
// Enable DSL2
nextflow.enable.dsl=2

include {downloadGenome} from './../../nf_processes/nf_prcs_download_genome.nf'
include {downloadGTF} from './../../nf_processes/nf_prcs_download_gtf.nf'
include {run_seqspec} from './../../nf_processes/nf_seqspec.nf'
include {run_cellatlas_build} from './../../nf_processes/nf_cellatlas_build.nf'

workflow {
    // STEP 1: input processing
    modality = params.MODALITY
    println modality

    spec_yaml_ch = file(params.SPEC_YAML)
    println spec_yaml_ch
    feature_barcodes_ch = file(params.FEATURE_BARCODES)
    println feature_barcodes_ch

    // Files whose name ends with the .gz suffix are expected to be GZIP compressed and automatically uncompressed.
    r1_ch = Channel.fromPath(params.R1_FASTQ_GZ,checkIfExists: true)
    println(r1_ch)
    r2_ch = Channel.fromPath(params.R2_FASTQ_GZ,checkIfExists: true)
    println(r2_ch)

    // STEP  2 - download the genome - worked
    genome_fasta_ch = file(params.GENOME_FASTA)
    println genome_fasta_ch

    // STEP 3 - download the gtf
    // println params.GENOME_GZ_GTF
    genome_gtf_ch = file(params.GENOME_GZ_GTF)
    println genome_gtf_ch

    // STEP 4 - check inputs validity
    println modality
    println spec_yaml_ch
    println genome_fasta_ch
    println genome_gtf_ch
    println feature_barcodes_ch
    println r1_ch
    println r2_ch

    // print implicit variable
    print "baseDir is $baseDir, launchDir is $launchDir, moduleDir is $moduleDir, nextflow is $nextflow, \
           params is $params, projectDir is $projectDir, workDir is $workDir, workflow is $workflow"
    run_cellatlas_build(modality,spec_yaml_ch,genome_fasta_ch,genome_gtf_ch,feature_barcodes_ch,r1_ch,r2_ch)
    // print(run_cellatlas_build.out.cellatlas_built_rna_output)

    //  worked for seqspec execution 
    // print params.SPEC_YAML
    // spec_yaml = channel.fromPath(params.SPEC_YAML, checkIfExists: true )     
    // seqspec 
    // run_seqspec(spec_yaml)
    // run_seqspec.out.seqspec_out.view()
}
