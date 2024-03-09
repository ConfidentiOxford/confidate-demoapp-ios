# TO MAKE IT WORK

1. Close XCode
2. Unzip `MoproKit/Libs/libmopro_ffi.a.zip`
3. Copy `Libs` one level up 
4. Install Cocoa Pods with `pod install` (*Note: requires local pod installation*)
2. After that, run `Confidate/mopro_script.sh`
3. Open XCode
3. Disable Script Sandboxing in XCode (to allow CocoaPods to integrate)
	1. Go to `Project Settings/Build Settings/Allow Script Sandboxing` -> `NO`
2. Now should compile
	