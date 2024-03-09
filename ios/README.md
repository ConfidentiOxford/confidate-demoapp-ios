# TO MAKE IT WORK

## Setup Mopro

1. Clone [mopro](https://github.com/ConfidentiOxford/mopro)
2. In the mopro repository run 
	- `scripts/build_ios.sh`
	- `scripts/build_ios.sh config-example.toml`
3. Copy the `mopro-ios/MoproKit` to our `confidate-demoapp-ios/ios/`

## Setup Out Repo with Mopro

1. Close XCode
2. Go to `confidate-demoapp-ios/ios/Confidate`
4. Install Cocoa Pods with in the `pod install` (*Note: requires local pod installation*)
2. After that, run `mopro_script.sh`
3. Open XCode

## Disable Sandboxing in XCode
To allow CocoaPods to integrate
1. Go to `Project Settings/Build Settings/Allow Script Sandboxing` -> `NO`
	

Now should compile
	

