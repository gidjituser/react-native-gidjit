### **react-native-gidjit**

Gidjit - Smart Launcher allows you to embed, update, and quickly launch your React Native or Expo apps. This Repo contains two simple scripts. The first will bundle your app and the second will generate a QR code so that you can easily add your app to Gidjit with a snap from the Photo App. Gidjit is available on the [App Store](https://itunes.apple.com/us/app/gidjit-smart-launcher/id1179176359?at=1001lnP4&mt=8).
Currently iOS 11.0+ only.

Notes for Expo apps
  1. You do not have to run any of the scripts in this repo. You can simply enter or paste the **exp://** or **https://expo.host...** URL in the text field while you are creating the action inside of Gidjit.
  2. To generate a QR code use the sections **1. Get Scripts** and **4. Sharing** only. This way your Expo app can be quickly added to Gidjit with a scan from your iDevice **📷 Photo App**.

[Gidjit Website](https://gidjit.concerco.space/)

## Introduction

* If you do not have Gidjit, scan the QR code below from your iDevice to view and install from the AppStore

![Download](https://s3-us-west-2.amazonaws.com/gidjit-public/iTunesGidjit.png)

* See the official [React Native website](https://facebook.github.io/react-native/docs/getting-started.html) for getting started with React Native. Make sure to follow the section ***Building Projects with Native Code***.


### 1. Get Scripts
1. Open your terminal
2. Copy the two scripts **bundle.sh** and **share.sh** in to your project repo's root or child directory. If you are using Git add this repo as a submodule for best results. From the project root, run: `git submodule add https://github.com/gidjituser/react-native-gidjit.git`. The following commands assume you added the submodule or copied scripts into subfolder react-native-gidjit.
3. Run: `chmod +x react-native-gidjit/bundle.sh react-native-gidjit/share.sh`

### 2. Bundling and testing
1. Run: `./react-native-gidjit/bundle.sh -e index.ios.js`, where index.ios.js is your entry-file. The entry-file path should be relative to the project root or package.json. For more help just type `./react-native-gidjit/bundle.sh -h`
2. Use the QR code generated to test locally following the output instructions from bundle.sh

***You can install all the packages you like. All of your node modules and assets will be bundled. The exception are react native libraries that need linking. Fortunately, Gidjit comes with common react native libraries already linked - listed in the Gidjit Provides section.***

### 3. Move bundle/zip to the cloud
  Move the generated app.zip from the bundle step to the cloud (For example Amazon S3 or Google Cloud drive). You can rename it if you like. Ensure it is gets public permissions to read

### 4. Sharing
  1. Run `./react-native-gidjit/share.sh -u URL`, where URL is the publicly accessible location. For more help just type `./react-native-gidjit/share.sh -h`. For Expo this can be the developing or published URL.
  2. Look for the file __qrcode.png__ in your Downloads. Once Gidjit is installed on an iPhone/iPad, the QR code can be scanned by the **📷 Photo App** to install.
  3. Share it! Users will need to have Gidjit installed first. They can install it from the [AppStore](https://itunes.apple.com/us/app/gidjit-smart-launcher/id1179176359?at=1001lnP4&mt=8).

## What Gidjit Provides
- Your app/action can be updated inside Gidjit.
- You can hide/show Gidjit's primary app navigation bar with a three finger tap on the screen.
- The following recommended versions of react-native and react.
  * "react": "16.8.6"
  * "react-native": "0.59.8"
- Expo SDK version 35. New versions will be added regularly.
- There are also great react native libraries already linked for you. Please contact us if you would like more. _Note for Expo. These currently work only with latest SDK in this case 35_.
    * "react-native-ble-plx": "^1.1.0"
    * "react-native-device-info": "^5.3.1"
    * "react-native-fetch-blob": "^0.10.8"
- Currently the following initial props are passed to your initial element. See [Properties](https://facebook.github.io/react-native/docs/communication-ios.html#properties) for more details. _Note for Expo. Initial props can be found in **this.props.exp**_.
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
