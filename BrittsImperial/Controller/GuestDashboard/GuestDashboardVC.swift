//
//  GuestDashboardVC.swift
//  BrittsImperial
//
//  Created by mac on 09/03/24.
//

import UIKit
import WebKit
class GuestDashboardVC: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let name = UserDefaultsHelper.getStudentFName(){
            lblName.text = "Hi, \(name)"
        }
        
        if let email = UserDefaultsHelper.getStudentEmail(){
            lblEmail.text = email
        }
        
        webView.navigationDelegate = self
        
        if let url = URL(string: "https://nortwest.edu.au/") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        UIApplication.shared.statusBarUIView?.backgroundColor = UIColor(rgb: 0x084545)
    }
    

    @IBAction func btn_LOGOUT(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Confirmation", message: "Do you want to logout?", preferredStyle: .alert)

        // Create "Yes" button with a handler
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            // Handle "Yes" button tap
            self.handleYesAction()
        }

        // Create "No" button with a handler
        let noAction = UIAlertAction(title: "No", style: .cancel) { (action) in
            // Handle "No" button tap or dismiss the alert
            print("No.....")
        }

        // Add the actions to the alert controller
        alertController.addAction(yesAction)
        alertController.addAction(noAction)

        // Present the alert controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func handleYesAction() {
        // Code to execute when "Yes" is tapped
        print("User tapped 'Yes'")
        resetUserDefaults()
        
        
        if let window = UIApplication.shared.windows.first {
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let navigationHomeVC = UINavigationController(rootViewController: homeVC)
            window.rootViewController = navigationHomeVC
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

}


extension GuestDashboardVC: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            // Handle webView start
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Handle webView finish
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            // Handle webView failure
        }
}
