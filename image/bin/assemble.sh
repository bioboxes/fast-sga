#!/bin/bash

set -o errexit
set -o nounset
set -o xtrace

TASK=$1
READS=$(biobox_args.sh 'select(has("fastq")) | .fastq | map(.value) | join(",")')
OUTPUT=/bbx/output
CONTIGS=${OUTPUT}/contigs.fa
CPU=$(nproc)


# Define assembly parameters
eval $(fetch_task_from_taskfile.sh $TASKFILE $TASK)
ASSEMBLE_OVERLAP=111
TRIM_LENGTH=400

cd $(mktemp -d)


sga preprocess --pe-mode 2 -o reads.pp.fastq ${READS}
sga index -a ropebwt -t ${CPU} --no-reverse reads.pp.fastq
sga correct -k ${KMER} --learn -t ${CPU} -o reads.ec.fastq reads.pp.fastq
sga index -a ropebwt -t ${CPU} reads.ec.fastq
sga filter -x 2 -t ${CPU} reads.ec.fastq

# Fast string graph algorithm
sga fsg -m ${MIN_OVERLAP} -t ${CPU} reads.ec.filter.pass.fa
sga assemble -m ${ASSEMBLE_OVERLAP} --min-branch-length ${TRIM_LENGTH} -o assembly reads.ec.filter.pass.asqg.gz

mv assembly-contigs.fa ${CONTIGS}

# This command writes yaml into the biobox.yaml until the EOF symbol is reached
cat << EOF > ${OUTPUT}/biobox.yaml
version: 0.9.0
arguments:
  - fasta:
    - id: contigs1
      value: contigs.fa
      type: contigs
EOF

rm -rf /tmp.*
