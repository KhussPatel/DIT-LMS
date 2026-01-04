//
//  DashboardVC.swift
//  BrittsImperial
//
//  Created by Khuss on 27/09/23.
//

import UIKit
import BMPlayer


class DashboardVC: BaseViewController {
    
    
    
    @IBOutlet weak var lblCurrentData: UILabel!
    @IBOutlet weak var collHome: UICollectionView!
    @IBOutlet weak var lblLoginUserName: UILabel!
    @IBOutlet weak var lblLoginCourseName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    
    @IBOutlet weak var vwTabbar: UIView!
    
    @IBOutlet weak var segmentMenu: TTSegmentedControl!
    
    @IBOutlet weak var tblSegment: SelfSizingTableView!
    
    
    let margin: CGFloat = 0
    
    var player = BMPlayer()

    //let arrTemp = [["title":"Assignment","image":"ic_assignment"],["title":"Cource Resource","image":"ic_course_resource"],["title":"Video","image":"ic_video_unit"],["title":"Notice Board","image":"ic_fee_color"],["title":"Fees","image":"ic_fee_color"],["title":"ICard","image":"ic_icard"]]
    let arrTemp = [["title":"Assignment","image":"ic_assignment"],["title":"Cource Resource","image":"ic_course_resource"],["title":"Video","image":"ic_video_unit"],["title":"Notice Board","image":"ic_fee_color"],["title":"ICard","image":"ic_icard"]]
    
    var arrResult1 = [DashboardList]()
    var arrResult2 = [DashboardList]()
    var arrResult3 = [DashboardList]()
    
    var mainArr = [DashboardList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaultsHelper.setIsLogin(true)
        
        lblLoginUserName.text = "\(UserDefaultsHelper.getStudentFName() ?? "") \(UserDefaultsHelper.getStudentFMName() ?? "")"
        
        //imgProfile.loadImageUsingCacheWithURLString(UserDefaultsHelper.getProfilePic() ?? "", placeHolder: UIImage(named: "appIcons1024"))
        
        //lblCurrentData.text = Date.getCurrentDate()
        
        lblLoginCourseName.text = UserDefaultsHelper.getCourseName() ?? ""
        
        lblStartDate.text = "S : \(UserDefaultsHelper.getProposed_start_date() ?? "")"
        lblEndDate.text = "E : \(UserDefaultsHelper.getProposed_end_date() ?? "")"
        // Do any additional setup after loading the view.
        
        guard let collectionView = collHome, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

            flowLayout.minimumInteritemSpacing = margin
            flowLayout.minimumLineSpacing = margin
            flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
      
        
        UIApplication.shared.statusBarUIView?.backgroundColor = UIColor(rgb: 0x084545)

        getDashboardData()
        
        let titles = ["Videos", "Assignment","Resources"].map { TTSegmentedControlTitle(text: $0) }
        segmentMenu.titles = titles
        segmentMenu.delegate = self
        
        segmentMenu.selectionViewFillType = .fillSegment
        segmentMenu.titleDistribution = .equalSpacing
        segmentMenu.isDragEnabled = false
        segmentMenu.isSizeAdjustEnabled = false
        segmentMenu.isSwitchBehaviorEnabled = false
        segmentMenu.selectionViewColorType = .color(value: .lightGray)
        segmentMenu.cornerRadiusSeg = .maximum
        segmentMenu.padding = .init(width: 0, height: 0)
        
        
        //Toast(text: "\(UserDefaultsHelper.getSTDID() ?? "") Student ID").show()
        CheckUpdate.shared.showUpdate(withConfirmation: false)
        
    }
    
    @IBAction func btn_MENU(_ sender: UIButton) {
        self.onSlideMenuButtonPressed(sender)
    }
    
    @IBAction func btn_CALENDER(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleListVC") as! ScheduleListVC
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func btn_DELIVERY_TIMETABLE(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "DeliveryTimeVC") as! DeliveryTimeVC
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func btn_Academic_TIMETABLE(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "AcademicVC") as! AcademicVC
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func btn_WallPost(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WallPostVC") as! WallPostVC
        self.navigationController?.pushViewController(next, animated: true)
    }
}

extension DashboardVC :BMPlayerDelegate {
   
    func bmPlayer(player: BMPlayer, playerStateDidChange state: BMPlayerState) {
      print("| BMPlayerDelegate | playerStateDidChange | state - \(state)")
    }
    
    
    func bmPlayer(player: BMPlayer, loadedTimeDidChange loadedDuration: TimeInterval, totalDuration: TimeInterval) {
        print("loadedTimeDidChange")
    }
    
    func bmPlayer(player: BMPlayer, playTimeDidChange currentTime: TimeInterval, totalTime: TimeInterval) {
        print("playTimeDidChange")
    }
    
    func bmPlayer(player: BMPlayer, playerIsPlaying playing: Bool) {
        print("playerIsPlaying")
    }
    
    func bmPlayer(player: BMPlayer, playerOrientChanged isFullscreen: Bool) {
        print("playerOrientChanged")
    }
}

extension DashboardVC: TTSegmentedControlDelegate{
    func segmentedViewDidBegin(_ view: TTSegmentedControl) {
        print("segmentedViewDidBegin")
    }
    
    func segmentedView(_ view: TTSegmentedControl, didDragAt index: Int) {
        print("didDragAt == \(index)")
    }
    
    func segmentedView(_ view: TTSegmentedControl, shouldMoveAt index: Int) -> Bool {
        print("shouldMoveAt == \(index)")
        return true
    }
    
    func segmentedView(_ view: TTSegmentedControl, didEndAt index: Int) {
        print("didEndAt == \(index)")
        if index == 0{
            self.mainArr = self.arrResult3
        }else if index == 1{
            self.mainArr = self.arrResult1
        }else{
            self.mainArr = self.arrResult2
        }
        
        self.tblSegment.reloadData()
    }
}


extension DashboardVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTemp.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DashboardCell
        let obj = arrTemp[indexPath.row]
        cell.lbltitle.text = obj["title"]!
        cell.imgIcon.image = UIImage(named: "\(obj["image"]!)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 3  //number of column you want
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            Constants.selectedMenu = .Assignement
        }else if indexPath.row == 1{
            Constants.selectedMenu = .Course
        }else if indexPath.row == 2{
            Constants.selectedMenu = .Video
        }
        
        
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 {
            if indexPath.row == 0{
                Constants.selectedMenu = .Assignement
            } else if indexPath.row == 1{
                Constants.selectedMenu = .Course
            }else{
                Constants.selectedMenu = .Video
            }
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "UnitListVC") as! UnitListVC
            self.navigationController?.pushViewController(next, animated: true)
        }else if indexPath.row == 3{//NoticeBoard
            let next = self.storyboard?.instantiateViewController(withIdentifier: "NoticeBoardVC") as! NoticeBoardVC
            self.navigationController?.pushViewController(next, animated: true)
        }else if indexPath.row == 4{//Fees
//            let next = self.storyboard?.instantiateViewController(withIdentifier: "FeeVC") as! FeeVC
//            self.navigationController?.pushViewController(next, animated: true)
            let next = self.storyboard?.instantiateViewController(withIdentifier: "IcardVC") as! IcardVC
            self.navigationController?.pushViewController(next, animated: true)
        }else{
            let next = self.storyboard?.instantiateViewController(withIdentifier: "IcardVC") as! IcardVC
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
    
    func moveVideoView(){
        let next = self.storyboard?.instantiateViewController(withIdentifier: "VideoPlayViewController") as! VideoPlayViewController
        self.navigationController?.pushViewController(next, animated: true)
      
    }
}

extension DashboardVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//DashboardTblCell
        
        if let _ = mainArr[indexPath.row].video{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTblCell1") as! DashboardTblCell
            cell.setData(obj: mainArr[indexPath.row])
            
            return cell
        }
        
        if let _ = mainArr[indexPath.row].assignmentLink{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTblCell2") as! DashboardTblCell
            cell.setDataAssignemtAndResource(obj: mainArr[indexPath.row])
            
            return cell
        }
        
        if let _ = mainArr[indexPath.row].resources{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTblCell2") as! DashboardTblCell
            cell.setDataAssignemtAndResource(obj: mainArr[indexPath.row])
            
            return cell
        }
        
        let tempCell = UITableViewCell()
        tempCell.backgroundColor = .clear
        return tempCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        guard let urlString = mainArr[indexPath.row].video else {
//            print("assignmentPath not found")
//            return
//        }
        
        if let urlString = mainArr[indexPath.row].video{
            if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
               if #available(iOS 10.0, *) {
                  UIApplication.shared.open(url, options: [:], completionHandler: nil)
               } else {
                  UIApplication.shared.openURL(url)
               }
            }else{
                Toast(text: "Invalid Video URL").show()
            }
        }
        
        if let urlString = mainArr[indexPath.row].assignmentLink ,let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
           if #available(iOS 10.0, *) {
              UIApplication.shared.open(url, options: [:], completionHandler: nil)
           } else {
              UIApplication.shared.openURL(url)
           }
        }
        
        if let urlString = mainArr[indexPath.row].resources ,let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
           if #available(iOS 10.0, *) {
              UIApplication.shared.open(url, options: [:], completionHandler: nil)
           } else {
              UIApplication.shared.openURL(url)
           }
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)
        
        let button = UIButton(type: .system)
        button.frame = CGRect(x: (footerView.frame.width - 200) / 2, y: 5, width: 200, height: 40)
        button.setTitle("Show More Video", for: .normal)
        button.backgroundColor = UIColor(rgb: 0xad3e3e)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(footerButtonTapped), for: .touchUpInside)
                
        footerView.addSubview(button)
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if mainArr.count > 0 && mainArr[0].video != nil{
            return 50
        }
        
        return 0
    }
    
    @objc func footerButtonTapped() {
        print("Footer button tapped!")
        // Add your action here
//        Constants.selectedMenu = .Video
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "UnitListVC") as! UnitListVC
//        self.navigationController?.pushViewController(next, animated: true)
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "VideoGallaryVC") as! VideoGallaryVC
        next.unitCode = mainArr[0].unitCode ?? ""
        next.unitTitle = mainArr[0].unitName ?? ""
        self.navigationController?.pushViewController(next, animated: true)
    }
}

extension DashboardVC{
    
    func getDashboardData(){
        APIManagerHandler.shared.callSOAPAPI_dis_std_dashboard(requestXMLStr: getRequestXML()) { result in
            switch result {
            case .success(let jsonData):
                // Handle the JSON response here
                do {
                    let responseModel = try JSONDecoder().decode(DashboardModel.self, from: jsonData)
                    
                    if let succee = responseModel.success, succee == "0"{
                        self.vwTabbar.isHidden = true
                        return
                    }
                    
                    if let result1 = responseModel.result{
                        self.arrResult1 = result1
                    }
                    
                    if let result2 = responseModel.result2{
                        self.arrResult2 = result2
                    }
                    
                    if let result3 = responseModel.result3{
                        self.arrResult3 = result3
                        self.mainArr = result3
                    }
                    
                    
                    self.tblSegment.reloadData()
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
        <dis_std_dashboard xmlns="http://tempuri.org/">
              <coe_code>\(UserDefaultsHelper.getCOE_CODE() ?? "")</coe_code>
            </dis_std_dashboard>
             
          </soap:Body>
        </soap:Envelope>
        """
        
        return stringParams
    }
}


extension UINavigationController {

    func setStatusBar(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }

}

extension UIApplication {

    var statusBarUIView: UIView? {

        if #available(iOS 13.0, *) {
            let tag = 3848245

            let keyWindow: UIWindow? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
                let statusBarView = UIView(frame: height)
                statusBarView.tag = tag
                statusBarView.layer.zPosition = 999999
                
                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }

        } else {

            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
      }
}


