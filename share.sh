#!/usr/bin/env bash 

RED='\033[0;31m'
YELLOW='\033[0;33m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

bundleURL=""
function showUsage {
    echo "Usage: $(basename "$0")
    [-h] help/usage
    [-u] public URL of react-native bundle created by the bundle script
    
    Will output qrcode.png to ${HOME}/Downloads

    You must first upload the bundle to a public location and copy its URL
    ex. a public AWS S3 URL, Google Cloud Storage or other
    It is recommnded to add an icon.png (120x120px) at the root of your directory that
    will be used as an App icon.

    Description:
    Place this script in the root or a child directory of your 
    project (at most 1 level below the root). 

    This script will generate a QR code that can be shared, so yourself and 
    others can quickly scan, access, and run your App from Gidjit - Smart Launcher 
    on their iDevice. On success, a QR code will be generated. 


    When scanned from your iDevice camera it will open Gidjit if installed - 
    https://itunes.apple.com/us/app/gidjit-smart-launcher/id1179176359?at=1001lnP4&mt=8. 
    Users will be able to complete the rest of your React Native App
    installation inside the app. A user can also manually add the action inside
    Gidjit by 

    1. Open Gidjit 
    2. Select Edit Actions in the top right
    2. Select a Panel if requested 
    3. Select 'All Other Actions'
    4. Select 'Scan QR Code' (The other option 'React Native μApp from URL' is for use without QR)
    5. Complete the rest of the setup - customizing icon and label of App

    Example:
    $(basename "$0") -u 'https://s3-us-west-2.amazonaws.com/g.../app.zip' 
"
}
while getopts "hu:" opt; do
  case ${opt} in
    h ) showUsage 
        exit 0
      ;;
    u ) bundleURL=${OPTARG}
      ;;
    \? ) showUsage
        exit 0
      ;;
  esac
done

function cleanupFromScript {
    echo -en "\033[0m"
    echo "Cleaning up"
}
trap cleanupFromScript SIGTERM SIGINT

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
        exit 1
    fi
fi
projectRootDir=$(pwd)

# Make sure required input files available
if [ -z "$bundleURL" ]; then 
    echo -e "${RED}No bundle URL (-u) passed ${NC}"
    echo -e "  "
fi

#Make sure the .zip is accessible
#Aid Charles Duffy - Stack overflow
if curl --output /dev/null --silent --head --fail "${bundleURL}"; then
	echo -e "${PURPLE}The zip appears to be accessible from ${bundleURL} ${NC}" 
else
	echo -e "${RED}The zip does not seem to be accessible from ${bundleURL} ${NC}" 
	exit 1
fi

#copy the QR code to Downloads
copyDir=${HOME}/Downloads
LIGHT_GREEN='\033[0;32m'
LIGHT_BLUE='\033[0;34m'

label="$(node -e "console.log(require(\"${projectRootDir}/package.json\").name)")"

gidjitAction="{\"label\":\"$label\",\"url\":\"$bundleURL\",\"type\":19}"
gidjitEncodedAction="$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "$gidjitAction")"

#Generate qrcode in terminal
qrcode "gidjit://gidjit.com/newAction?action=$gidjitEncodedAction" 

#Generate qrcode image to be served 
qrcode -o "${copyDir}/qrcode.png" "gidjit://gidjit.com/newAction?action=$gidjitEncodedAction" > /dev/null

echo -e "${LIGHT_GREEN}

qrcode.png has been output to ${copyDir}/Downloads. Your app can now be shared with others.

To use, 
1. Scan the QR code generated with the photo app of your iPhone/iPad
2. You will be prompted to open with Gidjit.
3. Complete the rest of the setup - customizing icon and label of the App if desired
-- Or --
1. Open Gidjit 
2. Select Edit Actions in the top right
3. Select a Panel (if in advanced mode)
4. Select 'All Other Actions'
5. Select 'From QR Code' 
(The other option 'React Native μApp from URL' is for use without the QR code. 
The url of app.zip can be used instead)
6. Select 'Scan QR Code' and scan the generated QR code
7. Complete the rest of the setup - customizing icon and label of the App if desired

Users can update from Gidjit. To do so
1. Open Gidjit 
1. From the main screen, select the action type 'Launch Custom or React Native Actions'
3. Launch the existing action
4. Select the info icon in the top left (ℹ️_) 
5. Select 'Update' button, version information will be taken from your package.json
6. Press 'Done' in the top right
If the URL changes an update cannot be performed

Notes - 
You can also show/hide Gidjit's default nav-bar with a three-finger tap anywhere on the screen

${NC}"

echo 'Complete!'

exit 0
