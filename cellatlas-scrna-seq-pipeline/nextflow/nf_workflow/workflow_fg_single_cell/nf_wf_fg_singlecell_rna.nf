include {run_synpase_download} from './../../nf_processes/nf_prcs_synapse_utils.nf'
include {run_print} from './../../nf_processes/nf_prcs_print.nf'
include {run_kb_ref;run_kb_count;run_download_kb_idx} from './../../nf_processes/nf_prcs_kallisto_bustools.nf'
include {run_downloadFiles} from './../../nf_processes/nf_prcs_download_url_files.nf'
include {run_seqspec_print;run_seqspec_index_rna_kb;run_seqspec_check;run_seqspec_modify_rna} from './../../nf_processes/nf_prcs_seqspec_utils.nf'


workflow {
  println params.ENV_SYNAPSE_TOKEN
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
  files_ch = Channel
    .fromPath( params.FASTQS_SPEC_CH )
    .splitCsv( header: true, sep: '\t' )
    .map { row -> tuple( file(row.R1_fastq_gz), file(row.R2_fastq_gz), file(row.spec) ) }
    .set { sample_run_ch }

  // STEP 3: check spec file and update as needed
  run_seqspec_print(sample_run_ch)
  // println ('finished run_seqspec_print')
  
  run_seqspec_check(sample_run_ch)
  // println ('finished run_seqspec_check')

  run_seqspec_modify_rna(sample_run_ch)
  
  run_seqspec_index_rna_kb(sample_run_ch,run_seqspec_modify_rna.out.seqspec_modify_rna_out)

   // STEP  4 - download the genome
  genome_fasta_ch = channel.value(file(params.GENOME_FASTA))
  println genome_fasta_ch

  // STEP 5 - download the gtf
  genome_gtf_ch = channel.value(file(params.GENOME_GZ_GTF))
  println genome_gtf_ch

  // STEP 6 a
  // TODO: run on a bigger machine with CPU. workaround - download reference
  // run_kb_ref(genome_fasta_ch, genome_gtf_ch)
  // println run_kb_ref

  // STEP 6 b - alternative - download an index file
  genome_idx_org_ch = channel.value(params.ORGANISM)
  println genome_idx_org_ch
  run_download_kb_idx(genome_idx_org_ch)
  index_out = run_download_kb_idx.out.index_out
  t2g_out = run_download_kb_idx.out.t2g_txt_out

//  STEP 7 - a
println run_seqspec_index_rna_kb.out.seqspec_index_out_file
run_kb_count(index_out, \
             t2g_out, \
             genome_gtf_ch, \
             sample_run_ch, \
             run_seqspec_index_rna_kb.out.seqspec_index_out_file)
println run_kb_count

// TODO: add QC

}