#!/bin/bash

# TODO: provide the transcripts as tuples 
# TODO: check the use of with-docker. can we have it at the level of the processes
# TODO: add nextflow tower
# rm -r /Users/eilaarich-landkof-stanford/Documents/Code/git_igvf/cellatlas-scrna-seq-pipeline/nextflow/nf_workflow/workflow_cellatlas_rna/work

# rm -r /Users/eilaarich-landkof-stanford/Documents/Code/git_igvf/cellatlas-scrna-seq-pipeline/nextflow/nf_workflow/workflow_cellatlas_rna/.nextflow.log*
# export TOWER_ACCESS_TOKEN=YOUR_ACCESS_TOKEN
nextflow run nf_wf_cellatlas_rna.nf -c nf_wf_cellatlas_rna.config -with-tower
# eilalan/cellatlas_env:latest
# -with-docker eilalan/atomic_update:latest
