BP=`dirname $0`
jarFileName=tms_client_1.0.jar
java -Dfile.encoding=uft-8 -jar $jarFileName "$@"
