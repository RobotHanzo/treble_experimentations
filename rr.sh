#!/bin/bash
j=$(nproc --all)
gapps="vanilla"
su="nosu"
type="userdebug"
sftp_host='uploads.androidfilehost.com'
# This section should be manually configured to match what it really is

sftp_username=''
sftp_password=''


images="release/$(date +%y%m%d)/*"
function usage()
{
    echo "Build treble for Resurrection Remix"
    echo ""
    echo "./rr.sh"
    echo "\t-h --help"
    echo "\t-j=$j"
    echo "\t--gapps=$vanilla"
    echo "\t--su=$nosu"
    echo "\t--type=$userdebug"
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
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done
echo "Confirm your selections:"
echo ""
echo "Job Count: $j"
echo "OpenGAPPS Implementation: $gapps"
echo "Superuser: $su"
echo "Build Type: $type"
echo ""
read -p "Press any key to proceed building Resurrection Remix"
bash ../treble_experimentations/build-dakkar.sh -j $j rr-q arm-aonly-$gapps-$su-$type arm-ab-$gapps-$su-$type a64-aonly-$gapps-$su-$type a64-ab-$gapps-$su-$type arm64-aonly-$gapps-$su-$type arm64-ab-$gapps-$su-$type
echo "================================="
echo ""
echo "Build succeeded, now uploading..."
echo ""
echo "================================="
lftp -c "open ftp://$sftp_username:$sftp_password@$sftp_host:21 ; mput $images"
