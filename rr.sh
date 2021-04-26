#!/bin/bash
j=$(nproc --all)
gapps="vanilla"
su="nosu"
type="userdebug"
scp_host='frs.sourceforge.net'
images="release/$(date +%y%m%d)/*.img"

# Use 4G for JVM memory to prevent Metalava from failing
export _JAVA_OPTIONS='-Xmx4G'
function usage()
{
    echo "Build treble for Resurrection Remix"
    echo ""
    echo "./rr.sh"
    echo "-h --help"
    echo "Building:"
    echo "-j=$j"
    echo "--gapps=$vanilla"
    echo "--su=$nosu"
    echo "--type=$userdebug"
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
echo "================================"
echo ""
echo "Confirm your selections:"
echo ""
echo "Job Count: $j"
echo "OpenGAPPS Implementation: $gapps"
echo "Superuser: $su"
echo "Build Type: $type"
echo ""
echo "================================"
echo ""
read -p "Press any key to proceed building Resurrection Remix Q"
bash ../treble_experimentations/build-dakkar.sh -j $j rr-q arm-aonly-$gapps-$su-$type arm-ab-$gapps-$su-$type a64-aonly-$gapps-$su-$type a64-ab-$gapps-$su-$type arm64-aonly-$gapps-$su-$type arm64-ab-$gapps-$su-$type
echo "=============="
echo ""
echo "Build finished"
echo ""
echo "=============="
