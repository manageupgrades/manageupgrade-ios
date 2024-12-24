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
        appleId: String,
        completion: @escaping (Result<AppStatus, Error>) -> Void
    ) {
        let url = URL(string: "https://api.manageupgrades.com/checkupdate")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "project_id": projectId,
            "version": version,
            "platform": platform,
            "api_key": apiKey,
            "googleid": googleId,
            "appleid": appleId
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "ManageUpgrades", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    let status = AppStatus(json: json)
                    DispatchQueue.main.async {
                        completion(.success(status))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func showUpdateAlert(status: AppStatus) {
        guard status.shouldShowAlert else { return }
        
        let alert = UIAlertController(
            title: status.title,
            message: status.message,
            preferredStyle: .alert
        )
        
        if status.isMaintenance {
            // For maintenance, only show OK button but don't allow dismissal
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            // Prevent alert from being dismissed when tapping outside
            alert.view.tintColor = .systemBlue
        } else if status.isForceUpdate {
            // For force update, only show Update Now button and don't allow dismissal
            let updateAction = UIAlertAction(title: "Update Now", style: .default) { [weak self] _ in
                self?.openAppStore(with: status.storeURL)
            }
            alert.addAction(updateAction)
            // Prevent alert from being dismissed when tapping outside
            alert.view.tintColor = .systemBlue
        } else {
            // For optional updates, show both Update Now and Later buttons
            alert.addAction(UIAlertAction(title: "Update Now", style: .default) { [weak self] _ in
                self?.openAppStore(with: status.storeURL)
            })
            alert.addAction(UIAlertAction(title: "Later", style: .cancel))
        }
        
        // Get the top most view controller to present the alert
        if let topViewController = UIApplication.shared.windows.first?.rootViewController?.topMostViewController() {
            topViewController.present(alert, animated: true) {
                // For maintenance and force update, disable alert dismissal
                if status.isMaintenance || status.isForceUpdate {
                    alert.view.superview?.isUserInteractionEnabled = true
                    alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: nil, action: nil))
                }
            }
        }
    }
    
    private func openAppStore(with urlString: String?) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

public struct AppStatus {
    public let shouldShowAlert: Bool
    public let isForceUpdate: Bool
    public let isMaintenance: Bool
    public let title: String
    public let message: String
    public let storeURL: String?
    
    init(json: [String: Any]) {
        self.shouldShowAlert = json["show_alert"] as? Bool ?? false
        self.isForceUpdate = json["force_update"] as? Bool ?? false
        self.isMaintenance = json["maintenance"] as? Bool ?? false
        self.title = json["title"] as? String ?? "Update Available"
        self.message = json["message"] as? String ?? "A new version is available."
        self.storeURL = json["store_url"] as? String
    }
}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        return self
    }
}
