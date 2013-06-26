BP=`dirname $0`
jarFileName=tms_client_1.0.jar
java -classpath .:$jarFileName -Dfile.encoding=uft-8 com.hollycrm.ems.tms.cli.WorkPlanRun "$@" 
