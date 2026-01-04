//
//  BaseViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit
import StoreKit


class BaseViewController: UIViewController, SlideMenuDelegate {
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        switch(index){
        case 0:
//FAQs
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
        case 1:
            //ChangePassword
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePassVC") as! ChangePassVC
            self.navigationController?.pushViewController(vc, animated: true)
            
            break
        case 2:
            showAlertForLogout()
            //let vc = self.storyboard?.instantiateViewController(withIdentifier: "PricingVC") as! PricingVC
            //self.navigationController?.pushViewController(vc, animated: true)
            
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PricingNewVC") as! PricingNewVC
//            self.navigationController?.pushViewController(vc, animated: true)
            
            break
        default:
            print("default\n", terminator: "")
        }
    }
    
    func addSlideMenuButton(){
        let btnShowMenu = UIButton(type: UIButton.ButtonType.system)
        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControl.State())
        btnShowMenu.frame = CGRect(x: 40, y: 80, width: 80, height: 80)
        btnShowMenu.backgroundColor = .red
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }

    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
       
        return defaultMenuImage;
    }
    
    @objc func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            //self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
                }, completion: { (finished) -> Void in
                    viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let menuVC : SideMenuVC = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        menuVC.btnMenu = sender
        menuVC.delegate = self
        //self.view.addSubview(menuVC.view)
        //self.addChild(menuVC)
        
        let window = UIApplication.shared.keyWindow!
        window.addSubview(menuVC.view)
        self.addChild(menuVC)
        
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
            }, completion:nil)
    }
    
    func callRatingPop(){
        guard let scan = view.window?.windowScene else{
            print("Error")
            return
        }
        if #available(iOS 14.0, *) {
            SKStoreReviewController.requestReview(in: scan)
            
        } else {
            // Fallback on earlier versions
            Toast(text: "Not support").show()
        }
    }
    
    func showAlertForLogout() {
            let alertController = UIAlertController(title: "Confirmation", message: "Do you want to logout?", preferredStyle: .alert)

            // Create "Yes" button with a handler
            let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                // Handle "Yes" button tap
                self.handleYesAction()
            }

            // Create "No" button with a handler
            let noAction = UIAlertAction(title: "No", style: .cancel) { (action) in
                // Handle "No" button tap or dismiss the alert
                self.handleNoAction()
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

        func handleNoAction() {
            // Code to execute when "No" is tapped or when the alert is dismissed
            print("User tapped 'No' or dismissed the alert")
        }
}

