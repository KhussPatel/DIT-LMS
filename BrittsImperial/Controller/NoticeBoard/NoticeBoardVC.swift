//
//  NoticeBoardVC.swift
//  BrittsImperial
//
//  Created by Khuss on 25/06/24.
//

import UIKit
import SwiftLoader

class NoticeBoardVC: UIViewController {

    @IBOutlet weak var tblNotice: UITableView!
    
    var arrNotices = [NoticeBoardList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getNoticeBoardListList()
    }
    
    @IBAction func btnBACK(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
extension NoticeBoardVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNotices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeBoardCell") as! NoticeBoardCell
        cell.setData(obj: arrNotices[indexPath.row])
        
        cell.btnAttach.tag = indexPath.row
        cell.btnAttach.addTarget(self, action: #selector(attachFind), for: .touchUpInside)
        
        return cell
    }
    
    @objc func attachFind(sender: UIButton){
        print(sender.tag)
        
        guard let fileUrlString = arrNotices[sender.tag].fileList, let fileUrl = URL(string: String(fileUrlString)) else {
            print("Invalid file URL")
            return
        }
        
        
        
        //SwiftLoader.show(animated: true)
        
        self.downloadFile(from: fileUrl) { savedURL in
            //SwiftLoader.hide()
            
            if let savedURL = savedURL {
                print("File saved to: \(savedURL.path)")
                Toast(text: "File saved to: \(savedURL.path)").show()
            } else {
                print("Failed to save the file")
                Toast(text: "Failed to save the file, may be file already exist").show()
            }
        }
        
    }
}

extension NoticeBoardVC{
    func downloadFile(from url: URL, completion: @escaping (URL?) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { tempLocalUrl, response, error in
            guard let tempLocalUrl = tempLocalUrl, error == nil else {
                completion(nil)
                return
            }

            // Save the file to a desired location
            let fileManager = FileManager.default
            do {
                let documentsDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let savedURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)
                try fileManager.moveItem(at: tempLocalUrl, to: savedURL)
                completion(savedURL)
            } catch {
                print("File saving error: \(error)")
                completion(nil)
            }
        }

        task.resume()
    }
}

extension NoticeBoardVC{
    
    func getNoticeBoardListList(){
        APIManagerHandler.shared.callSOAPAPI_dis_notice_for_student_for_app(requestXMLStr: getRequestXML()) { result in
            switch result {
            case .success(let jsonData):
                // Handle the JSON response here
                do {
                    let responseModel = try JSONDecoder().decode(NoticeBoardModel.self, from: jsonData)
                    if let temp = responseModel.result{
                        self.arrNotices = temp
                    }
                    
                    self.tblNotice.reloadData()
                    
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
         <dis_notice_for_student_for_app xmlns="http://tempuri.org/">
              <coe_code>\(UserDefaultsHelper.getCOE_CODE() ?? "")</coe_code>
            </dis_notice_for_student_for_app>
          </soap:Body>
        </soap:Envelope>
        """
        
        return stringParams
    }
}

//MARK: ------ UITableViewCell ---------
class NoticeBoardCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var btnAttach: UIButton!
    
    @IBOutlet weak var btnAttachConst: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnAttachConst.constant = 0.0
        btnAttach.isHidden = true
    }

    func setData(obj:NoticeBoardList){
        lblTitle.text = obj.title ?? ""
        lblContent.text = obj.desc ?? ""
        
        if obj.fileCount ?? 0 > 0{
            btnAttachConst.constant = 20.0
            btnAttach.isHidden = false
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
