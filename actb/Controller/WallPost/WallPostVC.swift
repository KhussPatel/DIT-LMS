//
//  WallPostVC.swift
//  BrittsImperial
//
//  Created by Khuss on 26/06/24.
//

import UIKit
import SDWebImage

class WallPostVC: UIViewController {

    @IBOutlet weak var tblWallPost: UITableView!
    
    var arrWallPost = [WallPostList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getWallPostList()
    }
    
    @IBAction func btnBACK(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension WallPostVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrWallPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = arrWallPost[indexPath.row]
        
        if obj.type ?? "" == "d"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WallPostDocCell") as! WallPostDocCell
            let obj = arrWallPost[indexPath.row]
            cell.lblName.text = obj.title ?? ""
            cell.lblDateTime.text = obj.postDate ?? "" + "  \(Constants.unicodeBulletPoint)  " + (obj.postBy ?? "")
            
            cell.lblContent.text = obj.desc ?? ""
            
            if let file_list = obj.fileList{
                var urlStrings = file_list.components(separatedBy: ",")
                urlStrings.removeAll { $0.isEmpty }
                let urls: [URL] = urlStrings.compactMap { URL(string: $0) }
                if urls.count > 0{
                    cell.configureDocs(with: urls)
                }

            }
            
            return cell
        }else if obj.type ?? "" == "t"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WallPostTextCell") as! WallPostCell
            let obj = arrWallPost[indexPath.row]
            cell.lblName.text = obj.title ?? ""
            cell.lblDateTime.text = obj.postDate ?? "" + "  \(Constants.unicodeBulletPoint)  " + (obj.postBy ?? "")
            
            cell.lblContent.text = obj.desc ?? ""
            return cell
        }else if obj.type ?? "" == "i" && obj.fileCount ?? 0 == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WallPostCell") as! WallPostCell
            let obj = arrWallPost[indexPath.row]
            cell.lblName.text = obj.title ?? ""
            cell.lblDateTime.text = obj.postDate ?? "" + "  \(Constants.unicodeBulletPoint)  " + (obj.postBy ?? "")
            
            cell.lblContent.text = obj.desc ?? ""
            
            if let file_list = obj.fileList{
                var urlStrings = file_list.components(separatedBy: ",")
                urlStrings.removeAll { $0.isEmpty }
                let urls: [URL] = urlStrings.compactMap { URL(string: $0) }
                if urls.count > 0{
                    let imageUrl = urls[0]
                    cell.img1.sd_setImage(with: imageUrl) { [weak tableView] (image, error, cacheType, url) in
                        guard let tableView = tableView else { return }
                        DispatchQueue.main.async {
                            tableView.beginUpdates()
                            cell.configureOnlyImage(with: image)
                            tableView.endUpdates()
                        }
                    }
                }

            }
            
            return cell
        }else if obj.type ?? "" == "i" && obj.fileCount ?? 0 == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellImg2") as! WallPostCell
            let obj = arrWallPost[indexPath.row]
            cell.lblName.text = obj.title ?? ""
            cell.lblDateTime.text = obj.postDate ?? "" + "  \(Constants.unicodeBulletPoint)  " + (obj.postBy ?? "")
            
            cell.lblContent.text = obj.desc ?? ""
            
            if let file_list = obj.fileList{
                var urlStrings = file_list.components(separatedBy: ",")
                urlStrings.removeAll { $0.isEmpty }
                let urls: [URL] = urlStrings.compactMap { URL(string: $0) }
                if urls.count > 0{
                    cell.config2Img(arrUrl: urls)
                }

            }
            
            return cell
        }else if obj.type ?? "" == "i" && obj.fileCount ?? 0 == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellImg3") as! WallPostCell
            let obj = arrWallPost[indexPath.row]
            cell.lblName.text = obj.title ?? ""
            cell.lblDateTime.text = obj.postDate ?? "" + "  \(Constants.unicodeBulletPoint)  " + (obj.postBy ?? "")
            
            cell.lblContent.text = obj.desc ?? ""
            
            if let file_list = obj.fileList{
                var urlStrings = file_list.components(separatedBy: ",")
                urlStrings.removeAll { $0.isEmpty }
                let urls: [URL] = urlStrings.compactMap { URL(string: $0) }
                if urls.count > 0{
                    cell.config3Img(arrUrl: urls)
                }

            }
            
            return cell
        }else if obj.type ?? "" == "i" && obj.fileCount ?? 0 == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellImg4") as! WallPostCell
            let obj = arrWallPost[indexPath.row]
            cell.lblName.text = obj.title ?? ""
            cell.lblDateTime.text = obj.postDate ?? "" + "  \(Constants.unicodeBulletPoint)  " + (obj.postBy ?? "")
            
            cell.lblContent.text = obj.desc ?? ""
            
            if let file_list = obj.fileList{
                var urlStrings = file_list.components(separatedBy: ",")
                urlStrings.removeAll { $0.isEmpty }
                let urls: [URL] = urlStrings.compactMap { URL(string: $0) }
                if urls.count > 0{
                    cell.config4Img(arrUrl: urls)
                }

            }
            
            return cell
        }else if obj.type ?? "" == "i" && obj.fileCount ?? 0 > 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellImg5") as! WallPostCell
            let obj = arrWallPost[indexPath.row]
            cell.lblName.text = obj.title ?? ""
            cell.lblDateTime.text = obj.postDate ?? "" + "  \(Constants.unicodeBulletPoint)  " + (obj.postBy ?? "")
            
            cell.lblContent.text = obj.desc ?? ""
            
            if let file_list = obj.fileList{
                var urlStrings = file_list.components(separatedBy: ",")
                urlStrings.removeAll { $0.isEmpty }
                let urls: [URL] = urlStrings.compactMap { URL(string: $0) }
                if urls.count > 0{
                    cell.config5Img(arrUrl: urls, imgcount: urls.count - 3)
                }

            }
            
            return cell
        }else{
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = arrWallPost[indexPath.row]
        var arrURLs = [URL]()
        
        if obj.type ?? "" == "i"{
            let next = self.storyboard?.instantiateViewController(withIdentifier: "WallPostDetailsVC") as! WallPostDetailsVC
            if let file_list = obj.fileList{
                var urlStrings = file_list.components(separatedBy: ",")
                urlStrings.removeAll { $0.isEmpty }
                let urls: [URL] = urlStrings.compactMap { URL(string: $0) }
                if urls.count > 0{
                    arrURLs = urls
                }
            }
            next.fileList = arrURLs
            self.navigationController?.pushViewController(next, animated: false)
        }
    }
    
}

extension WallPostVC{
    class ImageDownloader {
        static let shared = ImageDownloader()
        
        private init() {}
        
        func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil, let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                DispatchQueue.main.async {
                    completion(image)
                }
            }.resume()
        }
    }
}


extension WallPostVC{
    
    func getWallPostList(){
        APIManagerHandler.shared.callSOAPAPI_dis_post_for_student_for_app(requestXMLStr: getRequestXML()) { result in
            switch result {
            case .success(let jsonData):
                // Handle the JSON response here
                do {
                    let responseModel = try JSONDecoder().decode(WallPostModel.self, from: jsonData)
                    
                    if let temp = responseModel.result{
                        self.arrWallPost = temp
                    }
                    
                    self.tblWallPost.reloadData()
                    
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
    
    //<course_code>\(UserDefaultsHelper.getCourseCode() ?? "")</course_code>
    //<course_code>\(UserDefaultsHelper.getCourseCode() ?? "")</course_code>
    //<std_id>\(UserDefaultsHelper.getStudentId() ?? 0)</std_id>
    
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
         <dis_post_for_student_for_app xmlns="http://tempuri.org/">
              <course_code>\(UserDefaultsHelper.getCourseCode() ?? "")</course_code>
              <std_id>\(UserDefaultsHelper.getSTDID() ?? "")</std_id>
              <last_id>0</last_id>
            </dis_post_for_student_for_app>
          </soap:Body>
        </soap:Envelope>
        """
        
        return stringParams
    }
}
