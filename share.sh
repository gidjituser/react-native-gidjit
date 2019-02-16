#!/usr/bin/env bash

RED='\033[0;31m'
YELLOW='\033[0;33m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

bundleURL=""
passedProps=""
function showUsage {
    echo "Usage: $(basename "$0")
    [-h] help/usage
    [-u] public URL of react-native bundle created by the bundle script
    [-p] (Optional) Short JSON strings whose key/values will be passed as custom
    props to your initial element. To keep QR code small keep short. Valid values
    are String, Integer, Double, or Boolean.
    ex. '{n:\\\"Tom T.\\\",c:5}'

    Will output qrcode.png to ${HOME}/Downloads

    If you are NOT using Expo
      * You must first upload the bundle to a public location and copy its URL
    ex. a public AWS S3 URL, Google Cloud Storage or other
      * It is recommended your bundle contains an icon.png (120x120px) at the root directory.
    It will be used as an Action icon.

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
    4. Select 'Scan QR Code' (The other option 'React Native μApp from URL' is so the URL can be directly entered without a QR)
    5. Complete the rest of the setup - customizing icon and label of App

    For Expo users you can also directly scan XDE's QR using the previous steps.

    Example:
    $(basename "$0") -u 'https://s3-us-west-2.amazonaws.com/g.../app.zip'  -p '{n:\\\"Tom T.\\\",c:5}'

    $(basename "$0") -u 'exp6812112xxxxxxxxac://192.168.1.2:1900'

    $(basename "$0") -u 'https://exp.host/@user/project' -p '{d:\\\"some data\\\"}'
"
}
while getopts "hu:p:" opt; do
  case ${opt} in
    h ) showUsage
        exit 0
      ;;
    u ) bundleURL=${OPTARG}
      ;;
    p ) passedProps=${OPTARG}
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
    exit 1
fi

if  [[ $bundleURL != exp* ]] && [[ $bundleURL != https://exp.host* ]];
then
  #Make sure the is accessible if not expo
  #Aid Charles Duffy - Stack overflow
  if curl --output /dev/null --silent --head --fail "${bundleURL}"; then
  	echo -e "${PURPLE}The zip appears to be accessible from ${bundleURL} ${NC}"
  else
  	echo -e "${RED}The zip does not seem to be accessible from ${bundleURL} ${NC}"
  	exit 1
  fi
fi

#copy the QR code to Downloads
copyDir=${HOME}/Downloads
LIGHT_GREEN='\033[0;32m'
LIGHT_BLUE='\033[0;34m'

label="$(node -e "console.log(require(\"${projectRootDir}/package.json\").name)")"

gidjitAction=""
if [ -z "$passedProps" ]; then
  gidjitAction="{\"label\":\"$label\",\"url\":\"$bundleURL\",\"type\":19}"
else
  gidjitAction="{\"label\":\"$label\",\"url\":\"$bundleURL\",\"p\":\"$passedProps\",\"type\":19}"
fi

echo "gidjit Action is
$gidjitAction
"
gidjitEncodedAction=$(python -c "import urllib; print urllib.quote('''$gidjitAction''')")
#Generate qrcode in terminal
qrcode "gidjit://gidjit.com/newAction?action=$gidjitEncodedAction"

#Generate qrcode image to be served
qrcode -o "${copyDir}/qrcode.png" "gidjit://gidjit.com/newAction?action=$gidjitEncodedAction" > /dev/null

echo -e "${LIGHT_GREEN}

qrcode.png has been output to ${copyDir}. Your app can now be shared with others.

To use,
1. Scan the QR code generated with the Photo app of your iPhone/iPad
2. You will be prompted to open with Gidjit.
3. Complete the rest of the setup - customizing icon and label of the App if desired

If this is an Expo project updates are handled automatically when a new version is published.

Otherwise users can update the action from Gidjit by
1. Open Gidjit
1. From the Home screen, select the action type 'Launch User URL, RN, or Expo Actions'
3. Launch your action
4. Select the info icon in the top left (ℹ️_)
5. Select 'Update' button, version information will be taken from your package.json
6. Press 'Done' in the top right
If the URL changes an update cannot be performed

Notes -
You can also show/hide Gidjit's default nav-bar with a three-finger tap anywhere on the screen

${NC}"

echo 'Complete!'

exit 0
