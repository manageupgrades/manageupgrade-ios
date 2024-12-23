# ManageUpgrades iOS

A Swift package for managing app updates and maintenance mode in iOS applications.

## Installation

### CocoaPods

1. Add the following to your `Podfile`:
```ruby
pod 'ManageUpgrades'
```

2. Run:
```bash
pod install
```

### Swift Package Manager

You can install ManageUpgrades using Swift Package Manager in two ways:

#### Using Xcode:
1. In Xcode, select `File` → `Add Packages...`
2. In the search field, enter the package repository URL:
```
https://github.com/yourusername/manageupgrades_ios
```
3. Select the version rule (e.g., "Up to Next Major Version")
4. Click "Add Package"
5. Select the target where you want to use ManageUpgrades
6. Click "Add Package" to finish the installation

#### Using Package.swift:
1. Add the dependency to your `Package.swift` file:
```swift
dependencies: [
    .package(url: "https://github.com/yourusername/manageupgrades_ios.git", from: "1.0.0")
]
```

2. Add "ManageUpgrades" as a dependency for your target:
```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["ManageUpgrades"])
]
```

## Usage

1. Import the package:
```swift
import ManageUpgrades
```

2. Initialize the plugin:
```swift
let manageUpgradesPlugin = SwiftManageUpgradesPlugin()
```

3. Call the check update method:
```swift
let arguments: [String: Any] = [
    "project_id": "YOUR_PROJECT_ID",  // Replace with your project ID
    "version": "1.0.0",              // Your app's current version
    "platform": "ios",               // Platform identifier
    "api_key": "YOUR_API_KEY",       // Your API key from ManageUpgrades
    "googleid": "",                  // Can be empty for iOS
    "appleid": "YOUR_APPLE_ID"       // Your app's Apple ID
]

let call = FlutterMethodCall(methodName: "checkAppStatus", arguments: arguments)

manageUpgradesPlugin.handle(call) { result in
    if let response = result as? [String: Any] {
        print("Update check response: \(response)")
    } else if let error = result as? FlutterError {
        print("Error: \(error.message ?? "Unknown error")")
    }
}

## Features

- Check for app updates
- Handle maintenance mode
- Force update scenarios
- Optional update notifications
- Automatic App Store redirection

## Response Types

The plugin will return different responses based on the server response:

1. Maintenance Mode:
```swift
["status": "maintenance"]
```

2. Force Update:
```swift
["status": "force_update"]
```

3. Optional Update:
```swift
["status": "display_message"]
```

4. No Action Required:
```swift
["status": "no_action"]
```

5. Error:
```swift
["error": "error message"]
```

## Requirements

- iOS 11.0+
- Xcode 12.0+
- Swift 5.0+

## License

This project is licensed under the MIT License - see the LICENSE file for details.
