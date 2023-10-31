// Enable DSL2
nextflow.enable.dsl=2

process run_download_chromap_idx {
  label 'chromap'
  debug true
  script:
  """
  echo 'run_download_chromap_idx'
  chromap 
  """
}

process run_create_chromap_idx {
  label 'chromap_idx'
  debug true
  input: 
    path ref_fa 
  output:
    path "ref.index", emit: chromap_idx_out
  script:
  """
  echo 'run_create_chromap_idx'
  # create an index first and then map
  chromap -i -r $ref_fa -o ref.index
  """
}

// tuple path(fastq1), path(fastq2), path(fastq3), path(spec_yaml)
process run_chromap_map_to_idx {
  label 'chromap'
  debug true
  executor = 'local'
  input:
    path chromap_idx
    path ref_fa
    tuple path(fastq1), path(fastq2), path(fastq3), path(spec_yaml)
  output:
    path "map_bed_file.bed", emit: chromap_map_bed_path
  script:
    """
    echo $chromap_idx
    echo $ref_fa
    echo 'fastq1 is $fastq1'
    echo 'fastq2 is $fastq2'
    echo 'fastq3 is $fastq3'
    chromap -x $chromap_idx -r $ref_fa -1 $fastq1 -2 $fastq2 -o map_bed_file.bed
    echo 'finished map_bed_file.bed'

    """
  }


// path chromap_idx
// process run_chromap_map_to_idx {
//   label 'chromap'
//   debug true
//   executor = 'local'
//   input:
//     path ref_fa 
//     tuple path(fastq1), path(fastq2), path(fastq3), path(spec_yaml)
//   output:
//     path "map_bed_file.bed", emit: chromap_map_bed_path
//   script:
//     """
//     echo 'fastq1 is $fastq1'
//     echo 'fastq2 is $fastq2'
//     echo 'fastq3 is $fastq3'
//     if [ $fastq3 == "na.na" ]; then
//       echo "fastq3 is na.na"
    
//     else
//       echo "fastq3 has file match the string na.na"
//     fi 
//     echo 'finished map_bed_file.bed'
//     """
// }
// #  chromap -x $chromap_idx -r $ref_fa -1 $fastq1 -2 $fastq2 -o map_bed_file.bed
// # chromap -x $chromap_idx -r $ref_fa -1 $fastq1 -2 $fastq2 -3 $fastq3 -o map_bed_file.bed