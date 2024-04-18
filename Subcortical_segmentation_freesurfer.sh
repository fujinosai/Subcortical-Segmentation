#!/bin/bash

## Author: Raven / qiaokn123@163.com 

## print script usage
Usage () {
    cat <<USAGE
-------------------------------------------------------------------
`basename $0` Cross-sectional segmentation for the following structures: thalamus, brainstem, hippo-amygdala
-------------------------------------------------------------------
Usage example:

bash $0 -a /home/qiaokn/tdata/subj/t1_proc/freesurfer 
        -b /home/qiaokn/tdata/subj/t1_proc/subcortical_seg

-------------------------------------------------------------------
Required arguments:
        -a: FreeSurfer recon-all directory
        -b: Output directory

-------------------------------------------------------------------
USAGE
    exit 1
}

# Check arguments
if [ $# -lt 2 ]
then
        Usage >&1
        exit 1
fi
# Parse arguments
while getopts ":a:b:" opt; do
  case ${opt} in
    a )
      freesurfer_dir=${OPTARG}
      ;;
    b )
      results_dir=${OPTARG}
      ;;
    \? )
      print_usage
      exit 1
      ;;
  esac
done


# Validate input paths
if [ ! -d ${freesurfer_dir} ]; then
  echo "FreeSurfer directory not found"
  exit 1
fi

if [ ! -d ${results_dir} ]; then
  mkdir -p ${results_dir}
fi


# Set FreeSurfer environment variables
export SUBJECTS_DIR=$(dirname ${freesurfer_dir})
subject=$(basename ${freesurfer_dir})


for structure in thalamus hippo-amygdala brainstem
do
        segment_subregions ${structure} --cross ${subject} --out-dir ${results_dir} || {
                echo "Segmentation failed: $structure"
                exit 1
}
done
