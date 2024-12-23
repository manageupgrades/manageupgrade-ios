import UIKit
import Flutter

class ExampleViewController: UIViewController {
    
    // Initialize the plugin
    private let manageUpgradesPlugin = SwiftManageUpgradesPlugin()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkForUpdates()
    }
    
    private func checkForUpdates() {
        // Prepare the arguments
        let arguments: [String: Any] = [
            "project_id": "YOUR_PROJECT_ID",  // Replace with your project ID
            "version": "1.0.0",              // Your app's current version
            "platform": "ios",               // Platform identifier
            "api_key": "YOUR_API_KEY",       // Your API key from ManageUpgrades
            "googleid": "",                  // Can be empty for iOS
            "appleid": "YOUR_APPLE_ID"       // Your app's Apple ID
        ]
        
        // Create a method call
        let call = FlutterMethodCall(methodName: "checkAppStatus", arguments: arguments)
        
        // Call the plugin
        manageUpgradesPlugin.handle(call) { result in
            if let response = result as? [String: Any] {
                print("Update check response: \(response)")
            } else if let error = result as? FlutterError {
                print("Error: \(error.message ?? "Unknown error")")
            }
        }
    }
}
