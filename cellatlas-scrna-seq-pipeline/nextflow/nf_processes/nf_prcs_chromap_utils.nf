// Enable DSL2
nextflow.enable.dsl=2

process run_download_chromap_idx {
  label 'chromap_local'
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

process run_chromap_map_to_idx {
  label 'chromap_map_idx'
  debug true
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
    echo 'spec_yaml is $spec_yaml'
    chromap -x $chromap_idx -r $ref_fa -1 $fastq1 -2 $fastq3 -o map_bed_file.bed
    echo 'finished map_bed_file.bed'
    """
  }

process run_chromap_test {
  label 'chromap_local'
  debug true
   script:
    """
    echo run_chromap_test
    chromap
    echo run_chromap_test_end
    """
  }
