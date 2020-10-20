# Heap_Capture_s3


JVM Config

Execute: `java -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/log/app-`date +%s`-pid$$.hprof -XX:OnOutOfMemoryError=/opt/app/bin/upload_dump_s3.sh -Xmx2m ConsumeHeap`
