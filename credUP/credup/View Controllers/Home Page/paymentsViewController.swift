//
//  paymentsViewController.swift
//  credup
//
//  Created by Ryan Reid on 2/18/23.
//

import UIKit
import Stripe
import StripePaymentSheet

class paymentsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var publicTransactions : Array<Dictionary<String, Any>> = []
    var paymentIntentClientSecret: String?
    let backendURL = URL(string: "https://reidapps.net/credit")!
    var paymentData = ["name": "", "email": "", "amount": "", "message": ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StripeAPI.defaultPublishableKey = "pk_test_51Md6mYEwxbGRW5vXZlUzFMDZYXhCWUi06PZz0tHIPAZJa2aZ1Ljr0Tqi6xxNATzPdn3mVTdOPBBIusfVGGZiNoVi00hzz5qKXT"
        sendMoneyButtonSyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        self.tableView.transform = CGAffineTransformMakeScale (1,-1)
        getPublicTransactions()
//        addNavBarImage()
    }
    
    func addNavBarImage() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let image = UIImage(named: "logo_only")
        let imageView = UIImageView(image: image)
        navigationItem.titleView = imageView
    }
    
    func getPublicTransactions() {
        let url = URL(string: "https://reidapps.net/credit/getPublicPayments")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data")
            return
        }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                    
                self.publicTransactions = responseJSON["publicTransactions"]! as! Array<Dictionary<String, Any>>
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            }
        }
        
        task.resume()
    }

    var customExportView = UIButton(frame: CGRect(x: 60, y: 100, width: 250, height: 100))
    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height
    let width = 200
    let height = 50
    
    func sendMoneyButtonSyle() {
        customExportView = UIButton(frame: CGRect(x: (w/2) - (CGFloat(width)/2), y: h - CGFloat(height) - (self.tabBarController?.tabBar.frame.size.height ?? 0) - 25, width: CGFloat(width), height: CGFloat(height)))
        self.view.addSubview(customExportView)
        customExportView.backgroundColor = UIColor(red: 124/255, green: 16/255, blue: 52/255, alpha: 1.0)
        customExportView.setTitle("Send Money", for: .normal)
        customExportView.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        customExportView.cornerRadius = 25
        customExportView.isHidden = false
        customExportView.isEnabled = true
    }
    
    var hasNotch: Bool {
        let bottom = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Make Payment", message: "", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Send", style: .default, handler: { alert -> Void in
            let nameTextField = alertController.textFields![0] as UITextField
            let emailTextField = alertController.textFields![1] as UITextField
            let amountTextField = alertController.textFields![2] as UITextField
            let messageTextField = alertController.textFields![3] as UITextField
            if nameTextField.text! != "" && emailTextField.text! != "" && amountTextField.text! != "" && messageTextField.text! != "" {
                if amountTextField.text! != "0" {
                    self.paymentData = ["name": nameTextField.text!, "email": emailTextField.text!, "amount": amountTextField.text!, "message": messageTextField.text!]
                    self.fetchPaymentIntent()
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action : UIAlertAction!) -> Void in })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Name"
            textField.keyboardType = .default
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Email"
            textField.keyboardType = .default
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Amount"
            textField.keyboardType = .numberPad
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Message"
            textField.keyboardType = .default
        }

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func makePayment() {
        let url = URL(string: "https://reidapps.net/credit/makePayment")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(paymentData["name"]!, forHTTPHeaderField: "recname")
        request.setValue(paymentData["email"]!, forHTTPHeaderField: "recemail")
        request.setValue(paymentData["amount"]!, forHTTPHeaderField: "amount")
        request.setValue("0", forHTTPHeaderField: "id")
        request.setValue("true", forHTTPHeaderField: "isPublic")
        request.setValue(paymentData["message"]!, forHTTPHeaderField: "message")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data")
            return
        }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                    
//                self.publicTransactions = responseJSON["publicTransactions"]! as! Array<Dictionary<String, Any>>
                
                DispatchQueue.main.async {
                    self.displayAlert(title: "Payment complete!")
                    self.getPublicTransactions()
                    self.tableView.reloadData()
                    
                }

            }
        }
        
        task.resume()
    }
    
    func fetchPaymentIntent() {
        let url = self.backendURL.appendingPathComponent("/create-payment-intent")

        let shoppingCartContent: [String: Any] = [
            "items": [
                ["id": "xl-shirt"]
            ]
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(paymentData["amount"]!, forHTTPHeaderField: "amount")
        request.httpBody = try? JSONSerialization.data(withJSONObject: shoppingCartContent)

        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                let clientSecret = json["clientSecret"] as? String
            else {
                let message = error?.localizedDescription ?? "Failed to decode response from server."
                self?.displayAlert(title: "Error loading page", message: message)
                return
            }

            print("Created PaymentIntent")
            self?.paymentIntentClientSecret = clientSecret

            DispatchQueue.main.async {
//                self?.payButton.isEnabled = true
                self!.pay()
            }
        })

        task.resume()
    }
    
    func displayAlert(title: String, message: String? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alertController, animated: true)
        }
    }
    
    func pay() {
        guard let paymentIntentClientSecret = self.paymentIntentClientSecret else {
            return
        }

        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "credUP LLC"


        let paymentSheet = PaymentSheet(
            paymentIntentClientSecret: paymentIntentClientSecret,
            configuration: configuration)

        paymentSheet.present(from: self) { [weak self] (paymentResult) in
            switch paymentResult {
            case .completed:
                DispatchQueue.main.async {
                    self?.makePayment()
                }
            case .canceled:
                print("Payment canceled!")
            case .failed(let error):
                self?.displayAlert(title: "Payment failed", message: error.localizedDescription)
            }
        }
    }

}

extension paymentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publicTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentsCell", for: indexPath) as! paymentsTableViewCell
        
//        cell.contentView.transform = CGAffineTransformMakeScale (1,-1)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.profilePic.image = UIImage(named: "defaultProfilePic")
        cell.profilePic.makeRounded()
        
        cell.message.text = publicTransactions[indexPath.row]["message"] as? String ?? ""
        
        let recName = publicTransactions[indexPath.row]["name"] as? String ?? ""
        cell.paymentRecipts.text = "You paid \(recName) $\(publicTransactions[indexPath.row]["amount"] as! Int)"
        
        let strDate = publicTransactions[indexPath.row]["paymentDate"] as? String ?? ""
//        let dateFormatter = DateFormatter()
//        let date = dateFormatter.date(from: strDate)!
        
        cell.timeStamp.text = strDate
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

extension UIImageView {
    func makeRounded() {
        layer.borderWidth = 0
        layer.masksToBounds = false
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }
}
