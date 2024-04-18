DATADIR=/data03/public/CBPD
OUTDIR=/home/qiaokn/Desktop/MyFeatures/Subcortical_segmentation_CBPD
qcfile=$DATADIR/0scripts/t1qc_summary.csv                
N=$(cat ${qcfile} | wc -l )
for i in $(seq 1 $N)
do
        subj=$(cat ${qcfile} | sed -n "${i}p" | cut -d ',' -f1)
        t1dir=$(cat ${qcfile} | sed -n "${i}p" | cut -d ',' -f2)
        JOBDIR=$OUTDIR/$subj
        mkdir -p ${JOBDIR}
        JOBFILE="${JOBDIR}/Subcortical_segmentation_${subj}.job"
        echo "#! /bin/bash

#SBATCH --job-name=Subcortical_segmentation_${subj}
#SBATCH --partition=short.q
#SBATCH --output=${JOBDIR}/Subcortical_segmentation_${subj}.out
#SBATCH --error=${JOBDIR}/Subcortical_segmentation_${subj}.err
bash Subcortical_segmentation_freesurfer.sh -a $t1dir/freesurfer -b $OUTDIR/${subj}" > ${JOBFILE}
        sbatch ${JOBFILE}
done
