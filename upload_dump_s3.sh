#!/bin/bash
timestamp()
{
 date +"%Y-%m-%d %T"
}

LOG_FILE="/var/log/s3_upload.log"
exec > >(tee -a $LOG_FILE) # directs stdout to log file
exec 2>&1 # and also to console

ec2InstanceId=`hostname`

export AWS_ACCESS_KEY_ID=$HEAPDUMP_UP_AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$HEAPDUMP_UP_AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION=us-east-1

NOW=$(date +"%Y%m%d%H%M%S")
expirationDate=$(date -d $(date +"%Y/%m/%"d)+" 30 days" +%Y/%m/%d)

echo "$(timestamp): look for heap dumps to upload "

cd /var/log/

for hprof_file in *.hprof
do
  echo "$(timestamp): Processing $hprof_file file..."
  gzip $hprof_file
  aws s3 cp ${hprof_file}.gz "s3://s3-bucket/${ec2InstanceId}_v${BUILD_NUMBER}_${NOW}.gz" --expires $expirationDate
  rm ${hprof_file}.gz
  echo "$(timestamp): upload dump successfuly"
done

echo "$(timestamp): done heap dump loop"

#Execute: `java -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/log/app-`date +%s`-pid$$.hprof -XX:OnOutOfMemoryError=/opt/app/bin/upload_dump_s3.sh -Xmx2m ConsumeHeap`
