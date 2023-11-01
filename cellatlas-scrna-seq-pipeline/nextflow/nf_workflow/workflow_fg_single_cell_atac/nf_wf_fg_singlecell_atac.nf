include {run_synpase_download} from './../../nf_processes/nf_prcs_synapse_utils.nf'
include {run_downloadFiles} from './../../nf_processes/nf_prcs_download_url_files.nf'
include {run_seqspec_print;run_seqspec_check;run_seqspec_modify_atac;run_seqspec_test} from './../../nf_processes/nf_prcs_seqspec_utils.nf'
include {run_download_chromap_idx;run_create_chromap_idx;run_chromap_map_to_idx;run_chromap_test} from './../../nf_processes/nf_prcs_chromap_utils.nf'

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
  Channel
    .fromPath( params.FASTQS_SPEC_CH )
    .splitCsv( header: true, sep: '\t' )
    .map { row -> tuple( file(row.R1_fastq_gz), file(row.R2_fastq_gz), file(row.R3_fastq_gz),file(row.spec) ) }
    .set { sample_run_ch }
  
  //println ('calling run_seqspec_test')
  //run_seqspec_test()
  // STEP 3: check spec file and update as needed
  println ('calling run_seqspec_print')
  run_seqspec_print(sample_run_ch)
  println ('finished run_seqspec_print')
  
  // There is a bug with the online on the new version
  //   File "/opt/conda/lib/python3.11/site-packages/seqspec/Region.py", line 242, in to_dict
  // "location": self.location,
  //              ^^^^^^^^^^^^^
  //AttributeError: 'Onlist' object has no attribute 'location'
  //run_seqspec_check(sample_run_ch)
  //println ('finished run_seqspec_check')

  println ('start run_seqspec_modify_atac')
  run_seqspec_modify_atac(sample_run_ch)
  println ('finish run_seqspec_modify_atac')

  //println ('call run_chromap_test')
  //run_chromap_test()
  // STEP  4 - download the genome
  println ('start genome_fasta_ch download')
  genome_fasta_ch = channel.value(file(params.GENOME_FASTA))
  println ('finished genome_fasta_ch download')

  // STEP 5 - download the gtf
  println ('start genome_gtf_ch download')
  genome_gtf_ch = channel.value(file(params.GENOME_GZ_GTF))
  println ('finished genome_gtf_ch download')

  // STEP 6a: download chromap index
  println ('start genome_chromap_idx download')
  genome_chromap_idx = channel.value(file(params.CHROMAP_IDX))
  println ('finished genome_chromap_idx download')
  
  // Step 6b: create chromap index - make sure that you have enough resources
  // println ('start run_create_chromap_idx')
  // run_create_chromap_idx(genome_fasta_ch)
  // println ('stop run_create_chromap_idx download')
  
  // map the fastq files to the idx and fa file. genome_chromap_idx
  println ('start run_chromap_map_to_idx')
  run_chromap_map_to_idx(genome_chromap_idx,genome_fasta_ch,sample_run_ch)
  println ('finished run_chromap_map_to_idx')
}