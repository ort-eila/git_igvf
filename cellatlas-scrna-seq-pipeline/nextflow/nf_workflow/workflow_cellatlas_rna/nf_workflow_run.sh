#!/bin/bash

# TODO: provide the transcripts as tuples 
# TODO: check how to run for multiple rna file with the same parameters
# TODO: check the use of with-docker. can we have it at the level of the processes
# rm -r /Users/eilaarich-landkof-stanford/Documents/Code/git_igvf/cellatlas-scrna-seq-pipeline/nextflow/nf_workflow/workflow_cellatlas_rna/work

# rm -r /Users/eilaarich-landkof-stanford/Documents/Code/git_igvf/cellatlas-scrna-seq-pipeline/nextflow/nf_workflow/workflow_cellatlas_rna/.nextflow.log*

nextflow run nf_wf_cellatlas_rna.nf -c nf_wf_cellatlas_rna.config -with-docker eilalan/atomic_update:latest
# eilalan/cellatlas_env:latest
