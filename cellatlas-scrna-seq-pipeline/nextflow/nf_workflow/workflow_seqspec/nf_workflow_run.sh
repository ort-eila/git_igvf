#!/bin/bash

# run locally: nextflow run nf_workflow_seqspec.nf

# nextflow run nf_workflow_seqspec.nf -c nextflow-local.config

# run on cloud (the configuration will define the cloud - you have multiple configurations)
nextflow run nf_workflow_seqspec.nf -c nextflow.config

# gcloud batch jobs list - to check the batch jobs 
gcloud batch jobs list