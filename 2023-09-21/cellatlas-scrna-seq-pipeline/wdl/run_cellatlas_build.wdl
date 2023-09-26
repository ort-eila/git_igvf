version 1.0

# question: where wf_seqspec_onlist is being used in the command
workflow CellAtlasBuild {
  input {
    File  wf_spec_yaml
    File  wf_protein_feature_barcodes
    File  wf_rna_r1
    File  wf_rna_r2
    String wf_fa
    String wf_gtf
  }
  
  call run_cellatlas_build_task {
    input: 
      spec_yaml = wf_spec_yaml,
      protein_feature_barcodes = wf_protein_feature_barcodes,
      rna_r1 = wf_rna_r1,
      rna_r2 = wf_rna_r2,
      fa = wf_fa,
      gtf = wf_gtf
  }
  output {
    File workflow_CellAtlasBuild_ls_output = run_cellatlas_build_task.ls_output
    File workflow_CellAtlasBuild_seqspec_print_output = run_cellatlas_build_task.seqspec_print_output
  }
}

#################END OF WORKFLOW

task run_cellatlas_build_task {
  input {
    File  spec_yaml
    File  protein_feature_barcodes
    File  rna_r1
    File  rna_r2
    String fa
    String gtf
  }

  command {
    # Create the 'out' directory
    mkdir out

    # List the contents of the 'out' directory and save to 'ls_files.txt'
    ls -l > ls_files.txt

    # Print the value of 'spec_yaml'
    echo "spec_yaml is ${spec_yaml}"

    # TODO: Address with Sina
    seqspec print ${spec_yaml}
    seqspec print ${spec_yaml} > seqspec.print.out

    echo "fa is ${fa} "
    echo "gtf is ${gtf} "

    echo "protein_feature_barcodes is ${protein_feature_barcodes} "
    echo "rna_r1 is ${rna_r1} "
    echo "rna_r2 is ${rna_r2} "

}

  output {
    # TODO: missing the out from the execution
    File ls_output = "ls_files.txt"
    File seqspec_print_output = "seqspec.print.out"
  }

  runtime {
    # change it to input.
    # how to work with docker? where should I store the dockerfile.txt
    docker: "eilalan/cellatlas-scrna-seq-pipeline:1.0"
    cpu: 8
    memory: "8 GB"  # You can specify memory in GB or MB
    # bootDiskSizeGb: 100
    # disks: "local-disk 250 HDD"
  }
}
