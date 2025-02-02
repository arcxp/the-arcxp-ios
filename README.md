#  Getting started with ArcXP News

## Description
**Arc XP News (iOS)** is a mobile application that demos features provided by ArcXP's Commerce and Content SDKs. Explore this project to learn about how you might make use of these frameworks in your own iOS application.

## Requirements
- [CocoaPods](https://guides.cocoapods.org/using/getting-started.html)
- GADApplicationIdentifier, your Google AdMob app ID. 

### Optional
- GoogleService-Info.plist file. Google provides this when creating your Firebase project. See [here](https://firebase.google.com/docs/ios/setup)

## Installation steps
1. Clone this directory: 
``` 
git clone https://github.com/arcxp/the-arcxp-ios.git
```

2. Go to the Xcode project directory: 
```
cd the-arcxp-ios/TheArcXP
```

3. Use CocoaPods to install dependencies. These dependencies will involve services related to specific features implemented in the News app, such as social login, and others. 
```
pod install
```

4. Open `TheArcXP.xcworkspace` and prepare to add a few more details.

5. Make sure SPM packages have been downloaded correctly. If there is an issue, go to `File > Packages > Reset Package Caches` to re-download the necessary Swift packages for this project.

6. Google AdMob setup. Replace the GADApplicationIdentifier in the Info.plist with your actual Ad manager app ID. See setup guide [here](https://developers.google.com/admob/ios/quick-start).

7. Google Analytics setup(Optional). You'll need to add your Firebase project's `GoogleService-Info.plist` file to the Xcode project. See setup guide [here](https://firebase.google.com/docs/analytics/get-started?platform=ios).

8. Now you should be able to run the project in the simulator or on a device and explore its features.

---

Arc XP developers, visit [this link](https://arcpublishing.atlassian.net/wiki/spaces/UNI/pages/3739549854/Getting+Started+with+The+Arc+XP+Project+Internal) for details specific to internal development.
