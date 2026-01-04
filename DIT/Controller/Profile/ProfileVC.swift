//
//  ProfileVC.swift
//  BrittsImperial
//
//  Created by Khuss on 24/12/23.
//

import UIKit
import SwiftLoader

class ProfileVC: UIViewController {

    @IBOutlet weak var tblProfile: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblfName: UILabel!
    //@IBOutlet weak var lblCourse: UILabel!
    //@IBOutlet weak var lblBatch: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblDOB: UILabel!
    //@IBOutlet weak var lblCampus: UILabel!
    
    var arrProfile = [ProfileData2]()
    var imagePickerHelper: ImagePickerHelper!
    
    var base64Image = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imgProfile.loadImageUsingCacheWithURLString(UserDefaultsHelper.getProfilePic() ?? "", placeHolder: UIImage(named: "avatar"))
        
        lblfName.text = "\(UserDefaultsHelper.getStudentFMName() ?? "") \(UserDefaultsHelper.getStudentFamilyName() ?? "")"
        
        
        
        lblEmail.text = "\(UserDefaultsHelper.getStudentEmail() ?? "")"
        lblMobile.text = "\(UserDefaultsHelper.getMobileNo() ?? "")"
        //lblCourse.text = "\(UserDefaultsHelper.getCourseName() ?? "")"
        //lblBatch.text = "\(UserDefaultsHelper.getProposed_start_date() ?? "") to \(UserDefaultsHelper.getProposed_end_date() ?? "")"
        lblDOB.text = "\(UserDefaultsHelper.getdob() ?? "")"
        //lblCampus.text = "At : \(UserDefaultsHelper.getCampus() ?? "")"
        imagePickerHelper = ImagePickerHelper(viewController: self)
        getProfileData()
    }
    

    @IBAction func btn_BACK(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_PROFILE_PIC(_ sender: UIButton) {
        imagePickerHelper.showImagePickerOptions { [weak self] image in
            guard let self = self, let selectedImage = image else { return }
            self.imgProfile.image = selectedImage
            SwiftLoader.show(animated: true)
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.base64Image = selectedImage.toBase64() ?? ""
                DispatchQueue.main.async {
                    //self.completion?(base64String)
                    self.updateProfileData()
                }
            }
        }
    }
    
    func generateShortUniqueImageFileName() -> String {
        let timestamp = Int(Date().timeIntervalSince1970)
        let randomInt = Int.random(in: 1000...9999)
        let fileExtension = "jpg" // Change this to your desired file extension
        let fileName = "\(timestamp)_\(randomInt).\(fileExtension)"
        return fileName
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProfile.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        cell.config(obj: arrProfile[indexPath.row])
        return cell
    }
    
    
}



extension ProfileVC{
    
    
    func getProfileData(){
        APIManagerHandler.shared.callSOAPAPI_std_profile(requestXMLStr: getRequestXML()) { result in
            switch result {
            case .success(let jsonData):
                // Handle the JSON response here
                do {
                    let responseModel = try JSONDecoder().decode(ProfileModel.self, from: jsonData)
                    
                    if let temp = responseModel.result2{
                        self.arrProfile = temp
                    }
                    
                    self.tblProfile.reloadData()
                    
                    print("Decoded Person: \(responseModel)")
                } catch {
                    print("Error decoding data: \(error)")
                }
                
                print("JSON Response: \(jsonData)")
            case .failure(let error):
                // Handle the error here
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getRequestXML() -> String{
        let stringParams : String = """
            <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
              <soap:Header>
                <AuthUser xmlns="http://tempuri.org/">
                  <UserName>Admin</UserName>
                  <Password>123</Password>
                  <Token>College</Token>
                </AuthUser>
              </soap:Header>
              <soap:Body>
             <std_profile xmlns="http://tempuri.org/">
                            <std_id>\(UserDefaultsHelper.getSTDID() ?? "")</std_id>
                </std_profile>
              </soap:Body>
            </soap:Envelope>
            """
        
        return stringParams
    }
    //<std_id>\(UserDefaultsHelper.getStudentId() ?? 0)</std_id>
    func updateProfileData(){
        APIManagerHandler.shared.callSOAPAPI_std_profile_Update(requestXMLStr: getRequestXMLUpdateProfile()) { result in
            SwiftLoader.hide()
            switch result {
            case .success(let jsonData):
                // Handle the JSON response here
                do {
                    let responseModel = try JSONDecoder().decode(UpdateProfileModel.self, from: jsonData)
                    
                    if let temp = responseModel.result, temp.count > 0{
                        if let profilePic = temp[0].profilePicLive{
                            UserDefaultsHelper.setProfilePic(profilePic)
                        }
                    }
                    
                    Toast(text: "Profile Update Successfully").show()
                    print("Decoded Person: \(responseModel)")
                } catch {
                    print("Error decoding data: \(error)")
                }
                
                print("JSON Response: \(jsonData)")
            case .failure(let error):
                // Handle the error here
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getRequestXMLUpdateProfile() -> String{
        let stringParams : String = """
            <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
              <soap:Header>
                <AuthUser xmlns="http://tempuri.org/">
                  <UserName>Admin</UserName>
                  <Password>123</Password>
                  <Token>College</Token>
                </AuthUser>
              </soap:Header>
              <soap:Body>
             <upd_std_profile xmlns="http://tempuri.org/">
                  <std_id>\(UserDefaultsHelper.getSTDID() ?? "")</std_id>
                    <base64>\(base64Image)</base64>
                    <profile_pic>\(generateShortUniqueImageFileName())</profile_pic>
                </upd_std_profile>
              </soap:Body>
            </soap:Envelope>
            """
        
        return stringParams
    }
    
}


// MARK: - UpdateProfileModel
struct UpdateProfileModel: Codable {
    let result: [UpdateProfileResult]?
    let success: String?

    enum CodingKeys: String, CodingKey {
        case result
        case success = "Success"
    }
}

// MARK: - Result
struct UpdateProfileResult: Codable {
    let profilePicLive: String?

    enum CodingKeys: String, CodingKey {
        case profilePicLive = "profile_pic_live"
    }
}

//MARK: ------ UITableViewCell ---------
class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var lblCourse: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func config(obj : ProfileData2){
        lblDuration.text = "\(obj.proposedStartDate ?? "") to \(obj.proposedEndDate ?? "")"
        lblCourse.text = obj.courseName ?? ""
        lblLocation.text = "At : \(obj.locationName ?? "")"
    }
    
}
