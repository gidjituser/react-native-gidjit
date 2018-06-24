# react-native-gidjit
# Description

This Repo contains two simple scripts that will allow you to add, launch, and run your React Native apps/actions inside of Gidjit - Smart Launcher.
The scripts will generate QR codes so that you can easily share it across your iDevices, or with family and friends.
Gidjit is available on the  [AppStore](https://itunes.apple.com/us/app/gidjit-smart-launcher/id1179176359?at=1001lnP4&mt=8).
Currently iOS 10.0+ only. We will begin working on Android variant soon.

![Download](https://s3-us-west-2.amazonaws.com/gidjit-public/iTunesGidjit.png)

## Introduction

* See the official [React Native website](https://facebook.github.io/react-native/docs/getting-started.html) for getting started with React Native. Make sure to follow the section ***Building Projects with Native Code***.
* If you used ***create-react-native-app*** with Expo as opposed to ***react-native init***, you will need to [eject]( https://github.com/react-community/create-react-native-app/blob/master/react-native-scripts/template/README.md#ejecting-from-create-react-native-app) before following the next steps


### Bundling and testing
1. Copy the two scripts **bundle.sh** and **share.sh** in to your project repo's root or child directory. If you are using Git add this repo as a submodule for best results. From the project root, run: `git submodule add https://github.com/gidjituser/react-native-gidjit.git`. The following commands assume you added the submodule or copied scripts into subfolder react-native-gidjit.
2. Run: `chmod +x react-native-gidjit/bundle.sh react-native-gidjit/share.sh`
3. Run: `./react-native-gidjit/bundle.sh -e index.ios.js`, where index.ios.js is your entry-file. The entry-file path should be relative to the project root or package.json. For more help just type `./react-native-gidjit/bundle.sh -h`
4. Use the QR code generated to test locally following the output instructions from bundle.sh

***You can install all the packages you like. All of your node modules and assets will be bundled. The exception are react native libraries that need linking. Fortunately, Gidjit comes with many common react native libraries already linked - listed in the Gidjit Provides section.***

### Move bundle/zip to the cloud for sharing
1. Move the generated app.zip from the bundle step to the cloud (For example Amazon S3 or Google Cloud drive). You can rename it if you like. Ensure it is gets public permissions to read
2. Run `./react-native-gidjit/share.sh -u URL`, where URL is the publicly accessible location. For more help just type `./react-native-gidjit/share.sh -h`
3. Once Gidjit is installed on an iPhone/iPad, the QR code can be scanned by the **📷 Photo App** to install
4. Share it! Users will need to have Gidjit installed first. They can install it from the [AppStore](https://itunes.apple.com/us/app/gidjit-smart-launcher/id1179176359?at=1001lnP4&mt=8).

### What Gidjit Provides
- Your app/action can be updated inside Gidjit. (As long as the cloud URL stays the same)
- You can hide/show Gidjit's primary app navigation bar with a three finger tap on the screen.
- The following recommended versions of react-native and react.
  * "react": "16.4.0"
  * "react-native": "0.55.4"
- There are also many great react native libraries already linked for you. Please contact us if you would like more
    * "react-native-ble-plx": "^0.9.1"
    * "react-native-device-info": "^0.21.5"
    * "react-native-fetch-blob": "^0.10.8"
    * "react-native-svg": "^6.3.1"
    * "react-native-vector-icons": "^4.5.0"
- The following fonts have been linked/included in Gidjit for you
	* Entypo.ttf
	* EvilIcons.ttf
	* FontAwesome.ttf
	* Foundation.ttf
	* Ionicons.ttf
	* MaterialIcons.ttf
	* Octicons.ttf
	* Zocial.ttf
- Currently the following props are passed to your initial element. See [Properties](https://facebook.github.io/react-native/docs/communication-ios.html#properties) for more details.
  * additional props specified by the **-p** parameter of the **share.sh** script.  
  * sessionID (can be used to check it different actions are launching the app)

### Examples
**You can try these demos by scanning from you iPhone/iPad's photo app. Make sure Gidjit is installed first. Warning sometimes the photo app grabs the other QR code**
  - SimpleDemo:
  Repo at - [Github](https://github.com/gidjituser/HelloReact)


  ![SimpleDemo](https://s3-us-west-2.amazonaws.com/gidjit-public/SimpleDemo.png)


  - boostnote-mobile:
  Repo at - [Github](https://github.com/gidjituser/boostnote-mobile)

  ***Please note this is a really cool app forked from BoostIO.***
  ***We recommend you checking out their [Site](https://boostnote.io/)***


  ![BoostNote](https://s3-us-west-2.amazonaws.com/gidjit-public/BoostNote.png)
