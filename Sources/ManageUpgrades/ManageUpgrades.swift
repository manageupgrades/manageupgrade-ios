import SafariServices

public protocol AlertPresenter {
    func showAlert(title: String?, message: String?, actions: [(String, () -> Void)])
    func showNonDismissibleAlert(title: String?, message: String?, action: (String, () -> Void))
}

public class ManageUpgradesService: NSObject {
    public static let shared = ManageUpgradesService()
    private var alertPresenter: AlertPresenter?
    
    private override init() {
        super.init()
    }
    
    public func configure(alertPresenter: AlertPresenter) {
        self.alertPresenter = alertPresenter
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
        
        if status.isMaintenance {
            alertPresenter?.showNonDismissibleAlert(
                title: status.title,
                message: status.message,
                action: ("OK", {})
            )
        } else if status.isForceUpdate {
            alertPresenter?.showNonDismissibleAlert(
                title: status.title,
                message: status.message,
                action: ("Update Now", { [weak self] in
                    self?.openAppStore(with: status.storeURL)
                })
            )
        } else {
            alertPresenter?.showAlert(
                title: status.title,
                message: status.message,
                actions: [
                    ("Update Now", { [weak self] in
                        self?.openAppStore(with: status.storeURL)
                    }),
                    ("Later", {})
                ]
            )
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
