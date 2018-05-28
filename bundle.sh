#!/usr/bin/env bash 

RED='\033[0;31m'
YELLOW='\033[0;33m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

entryFile=""
function showUsage {
    echo "Usage: $(basename "$0")
    [-h] help/usage
    [-e] entryFile Path expected by react-native bundle
    Default: [PROJECT_ROOT]/index.ios.js
    (absolute path or relative from package.json location)

    Description:
    Place this script in the root or child directory of your 
    project (at most 1 level below the root). 

    It is recommnded to add an icon.png (120x120px) at the root of your directory that
    will be used as an App icon.

    This script will bundle and zip your project so that it can be run from
    Gidjit - Smart Launcher on your iDevice. On success, a QR code will be generated. 
    When scanned from your iDevice camera it will open Gidjit if installed - 
    https://itunes.apple.com/us/app/gidjit-smart-launcher/id1179176359?mt=8. 
    You will then be able to complete the rest of your React Native uApp
    installation inside the app.

    A webserver will also run to serve the zipped bundle. It's url will be
    displayed on success. The url of the QR code in png format will also
    be displayed.

    Example:
    $(basename "$0") -e js/index.ios.js
"
}
while getopts "he:" opt; do
  case ${opt} in
    h ) showUsage 
        exit 0
      ;;
    e ) entryFile=${OPTARG}
      ;;
    \? ) showUsage
        exit 0
      ;;
  esac
done

tmpPath=""
function cleanupFromScript {
    echo -en "\033[0m"
    echo "Cleaning up"
    [ -d $tmpPath ] && rm -rf $tmpPath
}
trap cleanupFromScript SIGTERM SIGINT

#netstat command assisted by Artur Bodera - Stackoverflow
netstat -aln | awk '$6 == "LISTEN" && $4 ~ "[\\.\:]9080$"' | grep -q 9080
if [ $? -eq 0 ]; then 
    echo -e "
    ${RED}Port 9080 does not appear to be avaliable. Please make sure this 
    script is not running elsewhere.
    ${NC}"
    cleanupFromScript
    exit 3
fi

which static-server
if [ $? -ne 0  ]; then
    echo 'Need to install global static-server via npm'
    npm install -g static-server
fi
which qrcode
if [ $? -ne 0  ]; then
    echo 'Need to install global qrcode via npm'
    npm install -g qrcode
fi

#Get directory location of current script
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${dir}
# Go to project root directory
if [ ! -e package.json ]; then 
    # Check in parent directory
    cd ${dir}/..
    if [ ! -e package.json ]; then 
        echo -e "${RED}
        Could not find package.json
        Make sure the script is located at Project Root 
        or in sub folder of Project Root.
        ${NC}" 
        echo -e "  "
        cleanupFromScript
        exit 1
    fi
fi
projectRootDir=$(pwd)
# Get repo name
if [ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1; then
    repoName=$(basename `git rev-parse --show-toplevel`)
fi
[ ! -z "$repoName" ] && echo "Bundling and Deploying for Repo $repoName"

# Make sure required input files available
if [ -z "$entryFile" ]; then 
    entryFile="${projectRootDir}/index.ios.js" 
    echo -e "${PURPLE}No entryFile (-e) passed, using default entryFile (index.ios.js) $entryFile ${NC}"
    echo -e "  "
fi

if [ ! -e "$entryFile" ]; then 
    echo -e "${RED}could not locate entryFile $entryFile ${NC}" 
    echo -e "  "
    cleanupFromScript
    exit 1
fi

#Generate temporary destinations for output
tmpPath="$(mktemp -d)"
#Where the final zip will be served from http server
servePath="$tmpPath/Serve"
#Where all the intermediate files are stored
outputPath="$servePath/Project"
mkdir -p $outputPath

#Copy files over to temp destination
if [ -e icon.png ]; then 
    cp icon.png $outputPath 
fi

cp package.json $outputPath

#bundle the project
echo 'Preparing to bundle files. This may take a minute'
react-native bundle --platform ios --dev false --entry-file "$entryFile" --bundle-output "$outputPath/main.ios.jsbundle" --assets-dest "$outputPath"
if [ $? -ne 0 ]; then 
    echo -e "${RED}Could not bundle the project${NC}"
    cleanupFromScript
    exit 3
fi
cd $servePath
#zip temporary destination to location to be reached from static server
zip -r app.zip Project


#Project is bundled and zipped
copyDir=${HOME}/Downloads
echo "Project is bundled"
LIGHT_GREEN='\033[0;32m'
LIGHT_BLUE='\033[0;34m'

# Copy to Downloads
if [ -d $copyDir ]; then 
   cp app.zip $copyDir
   echo -e "${LIGHT_BLUE}Copy of Zip can be found at $copyDir/app.zip${NC}"
fi

getMyIP() {
	#Taken from F. Hauri, on Stackoverflow. Thanks Bud!
    local _ip _myip _line _nl=$'\n'
    while IFS=$': \t' read -a _line ;do
        [ -z "${_line%inet}" ] &&
           _ip=${_line[${#_line[1]}>4?1:2]} &&
           [ "${_ip#127.0.0.1}" ] && _myip=$_ip
      done< <(LANG=C /sbin/ifconfig)
    printf ${1+-v} $1 "%s${_nl:0:$[${#1}>0?0:1]}" $_myip
}



getMyIP ipLocation 
contentURL="http://${ipLocation}:9080/app.zip"
label="$(node -e "console.log(require(\"${projectRootDir}/package.json\").name)")"

gidjitAction="{\"label\":\"$label\",\"url\":\"$contentURL\",\"type\":19}"
gidjitEncodedAction="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$gidjitAction")"

#Generate qrcode in terminal
qrcode "gidjit://gidjit.com/newAction?action=$gidjitEncodedAction" 
#node -e "require('qrcode-terminal').generate(\"$gidjitEncodedAction\", {small : true});"
echo -e "${LIGHT_GREEN}
To use, 
1. Scan the qrcode above with the photo app of your iPhone/iPad
2. You will be prompted to open with Gidjit.
-- Or --
1. Open Gidjit 
2. Select Edit Actions
3. Select a Panel (if in advanced mode)
4. Select All Other Actions
5. Select 'From QR Code' 
(The other option 'React Native μApp from URL' is for use without the QR code. 
The url of app.zip can be used instead)
6. Select 'Scan QR Code' and scan the generated QR code
7. Complete the rest of the setup - customizing icon and label of the App if desired

To update an existing action 
1. Open Gidjit 
1. From the main screen, select the action type 'Launch Custom or React Native Actions'
3. Launch your existing action
4. Select the info icon in the top left (ℹ️_) 
5. Select 'Update' button, version info will be used from your package.json
6. Press 'Done' in the top right
If the URL changes an update cannot be performed
${NC}"
#Generate qrcode image to be served 
qrcode -o "${servePath}/qrcode.png" "gidjit://gidjit.com/newAction?action=$gidjitEncodedAction" > /dev/null

echo -e "${LIGHT_BLUE}Using a browser an alternative qrcode can be found at http://${ipLocation}:9080/qrcode.png${NC}"
echo -e "${LIGHT_BLUE}
app.zip can also be accessed at http://${ipLocation}:9080/app.zip
or in 
${HOME}/Downloads/app.zip

To share with others
1. Move it to a cloud service like AWS S3, Google Cloud Storage, or other 
2. Configure permissions so is accessible to the public and Copy the URL 
3. Run share.sh -u URL to generate a QR code so others can easily 
add, launch, and run your app on their iDevice through Gidjit.
${NC}"
echo ""

static-server

echo 'Complete!'

exit 0
