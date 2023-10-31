include {run_synpase_download} from './../../nf_processes/nf_prcs_synapse_utils.nf'
include {run_downloadFiles} from './../../nf_processes/nf_prcs_download_url_files.nf'
include {run_seqspec_test;run_seqspec_print;run_seqspec_check;run_seqspec_modify_atac} from './../../nf_processes/nf_prcs_seqspec_utils.nf'
include {run_download_chromap_idx;run_create_chromap_idx;run_chromap_map_to_idx} from './../../nf_processes/nf_prcs_chromap_utils.nf'

params.OUTDIR='results'

workflow {
  println params.FASTQS_SPEC_CH

  // This will wait for the time that we have the data from the synapse
  // synIds_ch = Channel.fromPath(params.SYNAPSE_IDS)
  //                    .splitCsv(header: true)
  //                    | map { record -> tuple(record.synid_idx,record.synid_fastq1,record.synid_fastq2) }
  //                    | view
  // run_synpase_download(synIds_ch,params.ENV_SYNAPSE_TOKEN)
// STEP 2: download the fastq files and the index files
  // run_downloadFiles(files_ch)
  // println('finished run_downloadFiles')

  // BASED on https://colab.research.google.com/github/IGVF/atomic-workflows/blob/main/assays/SHARE-seq/example.ipynb#scrollTo=enZBq7G7WKI9
  // STEP 1: input processing
  // files_ch = Channel
  //   .fromPath( params.FASTQS_SPEC_CH )
  //   .splitCsv( header: true, sep: '\t' )
  //   .map { row -> tuple( file(row.R1_fastq_gz), file(row.R2_fastq_gz), file(row.R3_fastq_gz),file(row.spec) ) }
  //   .set { sample_run_ch }

  run_seqspec_test()
  // STEP 3: check spec file and update as needed
  // run_seqspec_print(sample_run_ch)
  // println ('finished run_seqspec_print')
  
  // run_seqspec_check(sample_run_ch)
  // println ('finished run_seqspec_check')

  // run_seqspec_modify_atac(sample_run_ch)

   // STEP  4 - download the genome
  // genome_fasta_ch = channel.value(file(params.GENOME_FASTA))
  // println genome_fasta_ch

  // STEP 5 - download the gtf
  // genome_gtf_ch = channel.value(file(params.GENOME_GZ_GTF))
  // println genome_gtf_ch

// STEP 6a: download chromap index
  // genome_chromap_idx = channel.value(file(params.CHROMAP_IDX))
  // println genome_chromap_idx
  
  // Step 6b: create chromap index - make sure that you have enough resources
  // run_create_chromap_idx(genome_fasta_ch)
  
  // map the fastq files to the idx and fa file. genome_chromap_idx
  // run_chromap_map_to_idx(genome_chromap_idx,genome_fasta_ch,sample_run_ch)
  // println run_chromap_map_to_idx
}