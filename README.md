# iAirSandbox
## How To Get Started

- check out thie project
- pod install environment
- run example in your simulator or iOS device
- shake device will get a pop up window
- that's all, view or send u file to computer

## Installation

- check out project
- import all files in ITWSandbox directory to your project



## Requirements
- iOS 9 above


## Usage

``` objc
// add import
#import "ITWSandboxDashBoard.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //enable shake to pop up sandbox viewer in debug mode
    [ITWSandboxDashBoard enableShakeToView];
    return YES;
}

```

## License

iAirSandbox is released under the MIT license. See LICENSE for details.