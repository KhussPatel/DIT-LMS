//
//  SideMenuVC.swift
//  SideMenuDemo
//
//  Created by Hoch Technology on 11/07/23.
//

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class SideMenuVC: UIViewController {
    
    var delegate : SlideMenuDelegate?
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    @IBOutlet var lblUserName : UILabel!
    @IBOutlet var imgProfile : UIImageView!
    @IBOutlet var lblEmail : UILabel!
    var btnMenu : UIButton!
    
    var arrMenuImage = ["side-usericon","password","privacy-policy","side-logout"]
    var arrMenu = ["Profile","Change Password","Privacy Policy","Logout"]
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblUserName.text = "\(UserDefaultsHelper.getStudentFamilyName() ?? "") \(UserDefaultsHelper.getStudentFMName() ?? "")"
        lblEmail.text = UserDefaultsHelper.getCourseName()
        
       
        imgProfile.loadImageUsingCacheWithURLString(UserDefaultsHelper.getProfilePic() ?? "", placeHolder: UIImage(named: "avatar"))

        
    }
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParent()
        })
    }
}
//MARK: - Tableview Delegate 👉  👉
extension SideMenuVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SideCell
        cell.lbl_title.text = arrMenu[indexPath.row]
        cell.img_icon.image = UIImage(named: arrMenuImage[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
    }
}
