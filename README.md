# react-native-gidjit
# Description

This Repo contains two simple scripts that will allow you to add, launch, and run your React Native apps inside of Gidjit - Smart Launcher.
The scripts will generate QR codes so that you can share with others.
Gidjit is available on the  [AppStore](https://itunes.apple.com/us/app/gidjit-smart-launcher/id1179176359?at=1001lnP4&mt=8).
Currently iOS 10.0+ only. We will begin working on Android variant soon.

![Download](https://s3-us-west-2.amazonaws.com/gidjit-public/iTunesGidjit.png)

## Introduction

See the official [React Native website](https://facebook.github.io/react-native/) for an introduction to React Native.

### Bundling and testing
1. Copy the two scripts **bundle.sh** and **share.sh** in to your project repo's root or child directory. You could even add this repo as a submodule for best results.
2. Run `chmod +x bundle.sh share.sh`
3. Run `./bundle.sh -e index.ios.js`, where index.ios.js is your entry-file. The entry-file path should be relative to the project root or package.json. For more help just type `./bundle.sh -h`
4. Use the QR code generated to test locally following instructions from bundle.sh

***You can install all the packages you like. All of your node modules will be bundled. The exception are react native libraries that need linking. Fortunately, Gidjit comes with many common react native libraries already linked - listed below.***

### Move bundle/zip to cloud and share
1. Run `./share.sh -u URL`, where URL is a publicly accessible location of the app.zip from the bundle section (For example Amazon S3 or Google Cloud drive). For more help just type `./share.sh -h`
2. Share the QR code generated with others. Once they install Gidjit they can just scan the QR code with their Photo app and complete the rest of the setup.

### What Gidjit Provides
- Users can update your app from inside Gidjit. (As long as the cloud URL stays the same)
- From the Gidjit App you can hide/show the primary app navigation bar with a three finger tap on the screen.
- The following recommended versions of react-native and react.
  * "react": "16.4.0",
  * "react-native": "0.55.4",
- There are also many great react native libraries already linked for you. Please contact us if you would like more
    * "react-native-ble-plx": "^0.9.0",
    * "react-native-device-info": "^0.21.5",
    * "react-native-fetch-blob": "^0.10.8",
    * "react-native-svg": "^6.3.1",
    * "react-native-vector-icons": "^4.5.0",
- The following fonts have been linked/included in Gidjit for you
	* Entypo.ttf
	* EvilIcons.ttf
	* FontAwesome.ttf
	* Foundation.ttf
	* Ionicons.ttf
	* MaterialIcons.ttf
	* Octicons.ttf
	* Zocial.ttf
- Currently the following data Will be passed to your initial element
	* props -> sessionID (can be used to check it different actions are launching your app)
