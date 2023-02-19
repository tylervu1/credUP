//
//  settingsViewController.swift
//  credup
//
//  Created by Ryan Reid on 2/18/23.
//

import UIKit

class settingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footer: UILabel!
    
    var settings = ["Bank Account", "Credit Card"]
    var settingsIcons = [UIImage(named: "bankIcon"), UIImage(named: "visaIcon")]
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        
        footer.text = "Version \(appVersion!)\nⒸ 2023 CredUP LLC"
    }

}

extension settingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! settingsTableViewCell
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        cell.setting.text = settings[indexPath.row]
        cell.icon.image = settingsIcons[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if settings[indexPath.row] == "Premium Access" {
//            let value = gb!.getFeatureValue(feature: "p_settings", default: JSON(rawValue: {}) ?? "{}")
//            showPaywall(json: value)
        } else if settings[indexPath.row] == "About" {
//            let alert = UIAlertController(title: "69 Positions", message: "Version: \(appVersion!)", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.cancel, handler: nil))
//            self.present(alert, animated: true, completion: nil)
        } else if settings[indexPath.row] == "Debug Menu" {
//            let alert = UIAlertController(title: "Change Premium Status", message: "Will be changed to: \(!UserDefaults.standard.bool(forKey: "net.shovelmate.iap.premium"))", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
//            let okay = UIAlertAction(title: "Change", style: .default, handler: { action in
//                DispatchQueue.main.async {
//                    UserDefaults.standard.setValue(!UserDefaults.standard.bool(forKey: "net.shovelmate.iap.premium"), forKey: "net.shovelmate.iap.premium")
//                    tableView.reloadData()
//                }
//            })
//            alert.addAction(okay)
//            self.present(alert, animated: true, completion: nil)
        } else if settings[indexPath.row] == "Restore Purchases" {
//            Purchases.shared.restorePurchases { (purchaserInfo, error) in
//                //... check purchaserInfo to see if entitlement is now active
//                print("something...")
//            }
        } else if settings[indexPath.row] == "Passcode Lock" {
            print("")
        } else if settings[indexPath.row] == "Uncheck All Positions" {
            print("")
        }
    }
    
}
