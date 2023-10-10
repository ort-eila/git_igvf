// Enable DSL2
nextflow.enable.dsl=2

process run_cellatlas_build {
  debug true
  cpus 4
  cache 'lenient'
  container 'eilalan/atomic_update:latest'

  input:
    val modality
    path spec_yaml
    path genome_fasta
    path genome_gtf
    path feature_barcodes
    path r1
    path r2
    
  output:
    path 'seqspec_out', emit: seqspec_out
    path 'rna_output', emit: cellatlas_built_rna_output
    path 'rna_alignment_log.json', emit: cellatlas_built_rna_align_log

  script:
  """
    # TODO: extract the sample name
    echo "seqspec print $spec_yaml"
    echo "output 1: seqspec_out"
    seqspec print $spec_yaml > seqspec_out
    
    echo "cellatlas build -o out -m $modality -s $spec_yaml -fa $genome_fasta -g $genome_gtf -fb $feature_barcodes $r1 $r2"
    cellatlas build -o out -m $modality -s $spec_yaml -fa $genome_fasta -g $genome_gtf -fb $feature_barcodes $r1 $r2
    
    jq -r '.commands[] | values[] | join(";")' out/cellatlas_info.json > jq_commands.txt
    # Execute each command from the jq_commands.txt file
    chmod +x jq_commands.txt
    source jq_commands.txt 
    tree out > tree_output
    echo "output 2: rna_output"
    ls out/output.bus  > rna_output
    echo "output 3: rna_alignment_log.json"
    ls out/run_info.json > rna_alignment_log.json
    # TODO: rename the outputs with the sample name that was extracted
  """
}