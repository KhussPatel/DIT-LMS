//
//  GHomeVC.swift
//  actb
//
//  Created by Khushal iOS on 03/10/25.
//

import UIKit
import SafariServices

class GHomeVC: UIViewController {

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    
        let urls = [
            "https://www.actb.com.au/courses-new",
            "https://www.actb.com.au/pre-enrollments/",
            "https://www.actb.com.au/application-request-forms/",
            "https://www.actb.com.au/enrolment-form-paper-based-n/",
            "https://www.actb.com.au/contact-us/"
        ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign tags (used to identify which view was tapped)
        view1.tag = 1
        view2.tag = 2
        view3.tag = 3
        view4.tag = 4
        view5.tag = 5
        
        // Add tap gestures to all
        addTapGesture(to: view1)
        addTapGesture(to: view2)
        addTapGesture(to: view3)
        addTapGesture(to: view4)
        addTapGesture(to: view5)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        StatusBarManager.setStatusBarBackgroundColor(UIColor(rgb: 0x9E1F21)) // 🎨 your desired color 0x084545
    }
    
    // Common helper to add tap gesture
    func addTapGesture(to view: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(commonViewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
    }
    
    // 👇 One single function for all tap actions
    @objc func commonViewTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }
        
//        if let url = URL(string: urls[1]) {
//            let safariVC = SFSafariViewController(url: url)
//            present(safariVC, animated: true)
//        }
        
        switch tappedView.tag {
        case 1:
            if let url = URL(string: urls[0]) {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true)
            }
            break
        case 2:
            if let url = URL(string: urls[1]) {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true)
            }
            break
        case 3:
            if let url = URL(string: urls[2]) {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true)
            }
            break
        case 4:
            if let url = URL(string: urls[3]) {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true)
            }
            break
        case 5:
            if let url = URL(string: urls[4]) {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true)
            }
            break
        default:
            print("Not found")
        }
        
        
//        switch tappedView.tag {
//        case 1:
//            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
//            loginVC.urlString = urls[0]
//            loginVC.headerString = "ACTB Courses"
//            self.navigationController?.pushViewController(loginVC, animated: true)
//            break
//        case 2:
//            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
//            loginVC.urlString = urls[1]
//            loginVC.headerString = "ACTB For Student"
//            self.navigationController?.pushViewController(loginVC, animated: true)
//            break
//        case 3:
//            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
//            loginVC.urlString = urls[2]
//            loginVC.headerString = "ACTB Student Form"
//            self.navigationController?.pushViewController(loginVC, animated: true)
//            break
//        case 4:
//            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
//            loginVC.urlString = urls[3]
//            loginVC.headerString = "ACTB Apply"
//            self.navigationController?.pushViewController(loginVC, animated: true)
//            break
//        case 5:
//            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
//            loginVC.urlString = urls[4]
//            loginVC.headerString = "ACTB Contact"
//            self.navigationController?.pushViewController(loginVC, animated: true)
//            break
//        default:
//            print("Not found")
//        }
    }
    
    
    @IBAction func btn_BACK(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    

}
