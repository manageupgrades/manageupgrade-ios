import SwiftUI

import ManageUpgrades

// Example parameters
let projectId = "projectid"
let version = "1.0.0"
let platform = "ios"
let apiKey = "123"
let googleId = "com.example.app"
let appleId = "123"



struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world1!")
        }
        .padding()
        .onAppear() {
            checkForUpdates()
        }
    }
}

private func checkForUpdates() {
        // Get current app version
        
        // Call the ManageUpgradesService
        ManageUpgradesService.shared.checkAppStatus(
            projectId: projectId,
            version: "1.2.5",
            platform: "ios",
            apiKey: apiKey,
            googleId: "", // Not needed for iOS
            appleId: appleId
        )
    }




#Preview {
    ContentView()
}
