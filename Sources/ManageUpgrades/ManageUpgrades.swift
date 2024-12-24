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
                        
                        if updateScenario == "Force Upgrade" {
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
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            alert.modalPresentationStyle = .fullScreen
            viewController.present(alert, animated: true)
        }
    }
    
    private func showForceUpdateAlert(message: String, appleId: String) {
        let alert = UIAlertController(
            title: "App Update Required!",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Update Now", style: .default) { _ in
            if let url = URL(string: "itms-apps://apps.apple.com/app/id\(appleId)") {
                UIApplication.shared.open(url)
            }
        })
        
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            alert.modalPresentationStyle = .fullScreen
            viewController.present(alert, animated: true)
        }
    }
    
    private func showUpdateMessage(message: String, appleId: String) {
        let alert = UIAlertController(
            title: "Notice",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Update", style: .default) { _ in
            if let url = URL(string: "itms-apps://apps.apple.com/app/id\(appleId)") {
                UIApplication.shared.open(url)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Not Now", style: .cancel))
        
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            viewController.present(alert, animated: true)
        }
    }
}
