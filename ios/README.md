# TO MAKE IT WORK

## Setup Mopro

1. Close XCode
2. Unzip `MoproKit/Libs/libmopro_ffi.a.zip`
4. Install Cocoa Pods with `pod install` (*Note: requires local pod installation*)
2. After that, run `Confidate/mopro_script.sh`
3. Open XCode

## Disable Sandboxing in XCode
To allow CocoaPods to integrate
1. Go to `Project Settings/Build Settings/Allow Script Sandboxing` -> `NO`
	

Now should compile
	

