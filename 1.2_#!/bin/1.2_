#!/bin/bash

# Author: Raven

# Date: 2024-01-04

# Email: qiaokn123@163.com

## print function usage
function Usage {
cat <<USAGE  
`basename $0` empty 

Usage example:
bash $0 -r REFIMAGE -m BBRMAT -t T1SucorticalSegmentation -o OUTDIR -p PREFIX
Required arguments:

-r: Reference image path   
-m: BBRegister matrix path
-t: T1 Subcortical segmentation path  
-o: Output directory
-p: Output file prefix

USAGE

exit 1
}

## parse arguments  
if [[ $# -lt 6 ]]; then
  Usage >&1
  exit 1
else
  while getopts "r:m:t:o:p:" OPT
  do
    case $OPT in
      r) # reference image
        REFIMAGE=$OPTARG  
        ;;
      m) # bbregister matrix   
        BBRMAT=$OPTARG   
        ;;
      t) # thalamic nuclei 
        T1Ss+=("$OPTARG")
        ;;
      o) # output dir  
        OUTDIR=$OPTARG
        ;;
      p) # prefix   
        PREFIX=$OPTARG
        ;;
      *) ## getopts issues an error message
        echo "ERROR: unrecognized option -$OPT $OPTARG"
        exit 1
        ;;    
  esac
  done
fi  

mkdir -p ${OUTDIR}/masks
NT1=${#T1Ss[@]}

if [[ ${NT1} -eq 1 ]]
then
    # Prepare subcortical segmentation
    Sname=$( basename ${T1Ss%.mgz} )
    mri_convert ${T1Ss} ${OUTDIR}/masks/$Sname.nii.gz
    mri_label2vol --seg ${OUTDIR}/masks/$Sname.nii.gz --temp ${REFIMAGE} --reg ${BBRMAT} --o ${OUTDIR}/masks/${PREFIX}_${Sname}.nii.gz
else
    PARA=""
    for img_idx in $(seq 1 ${NT1})
    do
    arr_idx=$(( ${img_idx} - 1 ))
    PARA="${PARA} --i ${T1Ss[${arr_idx}]}"
    Sname=$( basename ${T1Ss[${arr_idx}]%.mgz} | cut -d '.' -f2-4 )
    done
    mri_concat --combine ${PARA} --o ${OUTDIR}/masks/$Sname.mgz
    mri_convert ${OUTDIR}/masks/$Sname.mgz ${OUTDIR}/masks/$Sname.nii.gz
    mri_label2vol --seg ${OUTDIR}/masks/$Sname.nii.gz --temp ${REFIMAGE} --reg ${BBRMAT} --o ${OUTDIR}/masks/${PREFIX}_${Sname}.nii.gz
fi

    
