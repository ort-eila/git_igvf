version 1.0

workflow CellAtlasBuild {
  input {
    # Array[File] wf_fastqs
    # String  wf_modality
    File  wf_spec_yaml
    # File  wf_genome_fasta_gz
    # File  wf_feature_barcodes_txt
    # File  wf_genome_gtf_gz
  }
  
  call run_cellatlas_build_task {
    input: 
      # fastqs = wf_fastqs,
      # modality = wf_modality,
      spec_yaml = wf_spec_yaml
      # genome_fasta_gz = wf_genome_fasta_gz,
      # feature_barcodes_txt = wf_feature_barcodes_txt,
      # genome_gtf_gz = wf_genome_gtf_gz
  }
  output {
    # TODO: the cellatlas output
    File workflow_CellAtlasBuild_ls_output = run_cellatlas_build_task.ls_output
    File workflow_CellAtlasBuild_seqspec_print_output = run_cellatlas_build_task.seqspec_output
  }
}

#################END OF WORKFLOW

task run_cellatlas_build_task {
  input {
    # Array[File]  fastqs
    # String  modality
    File  spec_yaml
    # File  genome_fasta_gz
    # File  feature_barcodes_txt
    # File  genome_gtf_gz
  }
  
  command {
    # TODO: check how to specifiy the execution folder's name based on the sample ID. in case the machine is shared.
    # TODO: how do i work with arrays? will that work?${sep=" " fastqs}
    # check how to create the out folder with the name of the sample or with date
    # mkdir out
    ls -l out > ls_files.txt
    echo 'spec_yaml is ~{spec_yaml}'
    seqspec print ${spec_yaml} > seqspec_print.out
    # echo 'fastqs are ~{fastqs} modality is ~{modality}. spec_yaml is ~{spec_yaml}. genome_fasta_gz ~{genome_fasta_gz}. feature_barcodes_txt ~{feature_barcodes_txt}. genome_gtf_gz ~{genome_gtf_gz} '
    # cellatlas build -o out -s ~{spec_yaml} -fa ~{genome_fasta_gz} -fb ~{feature_barcodes_txt} -g ~{genome_gtf_gz} -m ~{modality} ${sep=" " fastqs}
  }

  output {
    # TODO: missing the out from the execution
    File ls_output = "ls_files.txt"
    File seqspec_output = "seqspec_print.out"
  }

  runtime {
    # change it to input.
    # how to work with docker? where should I store the dockerfile.txt
    docker: "eilalan/cellatlas-scrna-seq-pipeline:latest"
    cpus: '8'  # Number of CPU cores to allocate
    memory: 50 + "GB"
    # bootDiskSizeGb: 100
    # disks: "local-disk 250 HDD"
  }
}
