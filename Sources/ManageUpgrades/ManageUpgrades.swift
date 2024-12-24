import UIKit
import SafariServices

public class ManageUpgradesService: NSObject {
    public static let shared = ManageUpgradesService()
    
    private override init() {
        super.init()
    }
    
    public func checkAppStatus(
        projectId: String,
        version: String,
        platform: String,
        apiKey: String,
        googleId: String,
        appleId: String
       
    ) {
        let url = URL(string: "https://api.manageupgrades.com/checkupdate")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "project_id": projectId,
            "version": version,
            "platform": platform,
            "api_key": apiKey
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                guard let data = data,
                      let httpResponse = response as? HTTPURLResponse,
                      error == nil else {
                    
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        let maintenanceMode = json["maintenance_mode"] as? Bool ?? false
                        let appUpdateNotes = json["appUpdate_notes"] as? String ?? ""
                        let updateScenario = json["update_scenario"] as? String ?? ""
                        
                        if maintenanceMode {
                            self.showMaintenanceAlert()
                            return
                        }
                        
                        else if updateScenario == "Force Upgrade" {
                            self.showForceUpdateAlert(message: appUpdateNotes, appleId: appleId)
                            
                        } else if updateScenario == "Display Message" {
                            self.showUpdateMessage(message: appUpdateNotes, appleId: appleId)
                            
                        } else {
                            
                        }
                    } else {
                        
                    }
                } else {
                    
                }
            }
        }
        task.resume()
    }
    
    private func showMaintenanceAlert() {
        let alert = UIAlertController(
            title: "Under Maintenance",
            message: "The app is under maintenance. Please try again later.",
            preferredStyle: .alert
        )
        
        // Adding a dummy action that does nothing to prevent auto-dismissal
        let dummyAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Re-present the same alert if somehow dismissed
            self.showMaintenanceAlert()
        }
        alert.addAction(dummyAction)
        
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            viewController.modalPresentationStyle = .fullScreen
            viewController.definesPresentationContext = true
            viewController.present(alert, animated: true) {
                // Remove the ability to tap outside to dismiss
                alert.view.superview?.isUserInteractionEnabled = false
                alert.view.superview?.subviews.first?.isUserInteractionEnabled = false
            }
        }
    }
    
    private func showForceUpdateAlert(message: String, appleId: String) {
        let alert = UIAlertController(
            title: "App Update Required!",
            message: message,
            preferredStyle: .alert
        )
        
        let updateAction = UIAlertAction(title: "Update Now", style: .default) { _ in
          
                // Fallback to web App Store URL if the direct link fails
                if let webUrl = URL(string: "https://itunes.apple.com/app/id\(appleId)") {
                    UIApplication.shared.open(webUrl)
                }
          
            // Re-present the alert after attempting to open App Store
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showForceUpdateAlert(message: message, appleId: appleId)
            }
        }
        alert.addAction(updateAction)
        
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            alert.modalPresentationStyle = .fullScreen
            alert.view.backgroundColor = .clear
            alert.view.window?.windowLevel = .alert + 1
            viewController.present(alert, animated: true) {
                // Disable interaction with background
                alert.view.superview?.isUserInteractionEnabled = true
                alert.view.superview?.subviews.forEach { $0.isUserInteractionEnabled = false }
                alert.view.isUserInteractionEnabled = true
            }
        }
    }
    
    private func showUpdateMessage(message: String, appleId: String) {
        let alert = UIAlertController(
            title: "Notice",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Update", style: .default) { _ in
         
                // Fallback to web App Store URL if the direct link fails
                if let webUrl = URL(string: "https://itunes.apple.com/app/id\(appleId)") {
                    UIApplication.shared.open(webUrl)
                    // Re-present the alert after attempting to open App Store
               
                }
         
        })
        
        alert.addAction(UIAlertAction(title: "Not Now", style: .cancel))
        
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            viewController.present(alert, animated: true)
        }
    }
}
