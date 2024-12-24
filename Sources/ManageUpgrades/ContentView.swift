import SwiftUI

struct ContentView: View {
    // Replace these with your actual values
    private let projectId = "YOUR_PROJECT_ID"
    private let apiKey = "YOUR_API_KEY"
    private let appleId = "YOUR_APPLE_ID"
    
    var body: some View {
        VStack {
            Text("Welcome to the App")
                .font(.title)
            
            Button("Check for Updates") {
                checkForUpdates()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .onAppear {
            // Automatically check for updates when view appears
            checkForUpdates()
        }
    }
    
    private func checkForUpdates() {
        // Get current app version
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        
        // Call the ManageUpgradesService
        ManageUpgradesService.shared.checkAppStatus(
            projectId: projectId,
            version: currentVersion,
            platform: "iOS",
            apiKey: apiKey,
            googleId: "", // Not needed for iOS
            appleId: appleId
        )
    }
}

#Preview {
    ContentView()
}
