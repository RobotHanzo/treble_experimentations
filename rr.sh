#!/bin/bash
j=$(nproc --all)
gapps="vanilla"
su="nosu"
type="userdebug"
scp_host='frs.sourceforge.net'
images="release/$(date +%y%m%d)/*.img"
# This section should be manually configured to match what it really is

scp_remote_path=''
scp_username=''
scp_password=''


# Use 4G for JVM memory to prevent Metalava from failing
export _JAVA_OPTIONS='-Xmx4G'
function usage()
{
    echo "Build treble for Resurrection Remix"
    echo ""
    echo "./rr.sh"
    echo "\t-h --help"
    echo "\tBuilding:"
    echo "\t-j=$j"
    echo "\t--gapps=$vanilla"
    echo "\t--su=$nosu"
    echo "\t--type=$userdebug"
    echo "\tAuto uploader:"
    echo "\t--remote-path=$scp_remote_path"
    echo "\t--username=$scp_username"
    echo "\t--password=$scp_password"
    echo ""
}
while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        -j)
            j=$VALUE
            ;;
        --gapps)
            gapps=$VALUE
            ;;
        --su)
            su=$VALUE
            ;;
        --type)
            type=$VALUE
            ;;
        --remote-path)
            scp_remote_path=$VALUE
            ;;
        --username)
            scp_username=$VALUE
            ;;
        --password)
            scp_password=$VALUE
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done
echo "================================"
echo ""
echo "Confirm your selections:"
echo ""
echo "Job Count: $j"
echo "OpenGAPPS Implementation: $gapps"
echo "Superuser: $su"
echo "Build Type: $type"
echo ""
echo "Auto Uploader"
echo ""
echo "Upload to: $scp_remote_path"
echo "With username: $scp_username"
echo "With password: $scp_password"
echo ""
echo "================================"
echo ""
read -p "Press any key to proceed building Resurrection Remix Q"
bash ../treble_experimentations/build-dakkar.sh -j $j rr-q arm-aonly-$gapps-$su-$type arm-ab-$gapps-$su-$type a64-aonly-$gapps-$su-$type a64-ab-$gapps-$su-$type arm64-aonly-$gapps-$su-$type arm64-ab-$gapps-$su-$type
echo "================================="
echo ""
echo "Build succeeded, now uploading..."
echo ""
echo "================================="
sshpass -p $scp_password scp $images $scp_username@$scp_host:$scp_remote_path
echo "========================================================="
echo ""
echo "Upload finished, the building process has fully completed"
echo ""
echo "========================================================="
