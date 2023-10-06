#!/bin/bash

nextflow run nf_workflow.nf -c nextflow.config

# gcloud batch jobs list - to check the batch jobs 
gcloud batch jobs list