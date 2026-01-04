//
//  DashboardVC.swift
//  BrittsImperial
//
//  Created by Khuss on 27/09/23.
//

import UIKit
import BMPlayer
import SwiftQRCodeScanner


class DashboardVC: BaseViewController {
    
    
    
    @IBOutlet weak var lblCurrentData: UILabel!
    @IBOutlet weak var collHome: UICollectionView!
    @IBOutlet weak var lblLoginUserName: UILabel!
    @IBOutlet weak var lblLoginCourseName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    
    @IBOutlet weak var vwTabbar: UIView!
    
    @IBOutlet weak var vwAssienment: UIView!
    @IBOutlet weak var vwResouce: UIView!
    @IBOutlet weak var vwVideo: UIView!
    @IBOutlet weak var vwNotice: UIView!
    @IBOutlet weak var vwWallPost: UIView!
    @IBOutlet weak var vwiCard: UIView!
    
    @IBOutlet weak var vwAttendance: UIView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblClass: UILabel!
    
    
    @IBOutlet weak var segmentMenu: TTSegmentedControl!
    
    @IBOutlet weak var tblSegment: SelfSizingTableView!
    
    
    let margin: CGFloat = 0
    var qrLat = 0.0
    var qrLong = 0.0
    
    var player = BMPlayer()

    //let arrTemp = [["title":"Assignment","image":"ic_assignment"],["title":"Cource Resource","image":"ic_course_resource"],["title":"Video","image":"ic_video_unit"],["title":"Notice Board","image":"ic_fee_color"],["title":"Fees","image":"ic_fee_color"],["title":"ICard","image":"ic_icard"]]
    let arrTemp = [["title":"Assignment","image":"ic_assignment"],["title":"Course Resource","image":"ic_course_resource"],["title":"Video","image":"ic_video_unit"],["title":"Notice Board","image":"ic_fee_color"],["title":"ICard","image":"ic_icard"]]
    
    var arrResult1 = [DashboardList]()
    var arrResult2 = [DashboardList]()
    var arrResult3 = [DashboardList]()
    
    var mainArr = [DashboardList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaultsHelper.setIsLogin(true)
        
        //lblLoginUserName.text = "\(UserDefaultsHelper.getStudentFName() ?? "") \(UserDefaultsHelper.getStudentFMName() ?? "")"
        
        imgProfile.loadImageUsingCacheWithURLString(UserDefaultsHelper.getProfilePic() ?? "", placeHolder: UIImage(named: "appIcons1024"))
        
        //lblCurrentData.text = Date.getCurrentDate()
        
        lblLoginCourseName.text = UserDefaultsHelper.getCourseName() ?? ""
        
        lblStartDate.text = "S : \(UserDefaultsHelper.getProposed_start_date() ?? "")"
        lblEndDate.text = "E : \(UserDefaultsHelper.getProposed_end_date() ?? "")"
        // Do any additional setup after loading the view.
        
//        guard let collectionView = collHome, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
//
//            flowLayout.minimumInteritemSpacing = margin
//            flowLayout.minimumLineSpacing = margin
//            flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
      
        
        //UIApplication.shared.statusBarUIView?.backgroundColor = UIColor(rgb: 0x084545)

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
        
        viewAction()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(vwTapQR))
        vwAttendance.addGestureRecognizer(tapGesture)
    }
    
    
   /* @objc func vwTapQR() {
        print("QR tapped!")
        
        var configuration = QRScannerConfiguration()
        configuration.readQRFromPhotos = false
        // (Optional) customize other UI elements
//        configuration.cameraImage = UIImage(named: "camera")
//        configuration.flashOnImage = UIImage(named: "flash-on")
//        // If you don't want a gallery icon at all, you can skip setting galleryImage
        // configuration.galleryImage = UIImage(named: "photos")

        let scanner = QRCodeScannerController(qrScannerConfiguration: configuration)
        scanner.delegate = self
        present(scanner, animated: true, completion: nil)
        
    }*/
    
    @objc func vwTapQR() {
        print("QR tapped!")
        
        // ✅ First get user location
        LocationHelper.shared.getUserLocation(from: self) { [weak self] lat, long in
            print("📍 Got location: \(lat), \(long)")
            self?.qrLat = lat
            self?.qrLong = long
            // ✅ Now open QR scanner
            var configuration = QRScannerConfiguration()
            configuration.readQRFromPhotos = false

            let scanner = QRCodeScannerController(qrScannerConfiguration: configuration)
            scanner.delegate = self
            self?.present(scanner, animated: true, completion: nil)
        }
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
        let next = self.storyboard?.instantiateViewController(withIdentifier: "DeliveryTimeVC") as! DeliveryTimeVC
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func btn_WallPost(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WallPostVC") as! WallPostVC
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    
    func viewAction() {
        let vAssienment = UITapGestureRecognizer(target: self, action: #selector(btn_ASSIGNMENT))
        vwAssienment.isUserInteractionEnabled = true
        vwAssienment.addGestureRecognizer(vAssienment)
        
        let vResouce = UITapGestureRecognizer(target: self, action: #selector(btn_RESOURSE))
        vwResouce.isUserInteractionEnabled = true
        vwResouce.addGestureRecognizer(vResouce)
        
        let vVideo = UITapGestureRecognizer(target: self, action: #selector(btn_VIDEO))
        vwVideo.isUserInteractionEnabled = true
        vwVideo.addGestureRecognizer(vVideo)
        
        let vNotice = UITapGestureRecognizer(target: self, action: #selector(btn_NOTICE))
        vwNotice.isUserInteractionEnabled = true
        vwNotice.addGestureRecognizer(vNotice)
        
        let vWallPost = UITapGestureRecognizer(target: self, action: #selector(btn_LIVE_UPDATES))
        vwWallPost.isUserInteractionEnabled = true
        vwWallPost.addGestureRecognizer(vWallPost)
        
        let viCard = UITapGestureRecognizer(target: self, action: #selector(btn_I_CARD))
        vwiCard.isUserInteractionEnabled = true
        vwiCard.addGestureRecognizer(viCard)
    }
    
    
    //MARK: Educational Matrial Clicks
    @objc func btn_ASSIGNMENT() {
        Constants.selectedMenu = .Assignement
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "UnitListVC") as! UnitListVC
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    
    @objc func btn_RESOURSE() {
      
        Constants.selectedMenu = .Course
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "UnitListVC") as! UnitListVC
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @objc func btn_VIDEO() {
      
            Constants.selectedMenu = .Video
        
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "UnitListVC") as! UnitListVC
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    //MARK: Other Module Clicks
    @objc func btn_NOTICE() {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "NoticeBoardVC") as! NoticeBoardVC
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @objc func btn_LIVE_UPDATES() {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "WallPostVC") as! WallPostVC
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @objc func btn_I_CARD() {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "IcardVC") as! IcardVC
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    // MARK: - Custom Success Popup
    private func showCustomSuccessPopup() {
        DispatchQueue.main.async {
            // Create background overlay
            let overlayView = UIView(frame: self.view.bounds)
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            overlayView.tag = 999 // For easy removal
            
            // Create popup container
            let popupView = UIView()
            popupView.backgroundColor = UIColor.white
            popupView.layer.cornerRadius = 20
            popupView.translatesAutoresizingMaskIntoConstraints = false
            
            // Add shadow
            popupView.layer.shadowColor = UIColor.black.cgColor
            popupView.layer.shadowOffset = CGSize(width: 0, height: 4)
            popupView.layer.shadowRadius = 10
            popupView.layer.shadowOpacity = 0.3
            
            // Close button (X)
            let closeButton = UIButton(type: .system)
            closeButton.setTitle("✕", for: .normal)
            closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            closeButton.setTitleColor(UIColor.gray, for: .normal)
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            closeButton.addTarget(self, action: #selector(self.dismissCustomPopup), for: .touchUpInside)
            
            // QR Code illustration (using emoji as placeholder)
            let qrImageView = UIImageView()
            qrImageView.image = UIImage(named: "success-1")
            qrImageView.contentMode = .scaleAspectFit
            qrImageView.translatesAutoresizingMaskIntoConstraints = false
            
            // Create a simple QR-like illustration using emoji
//            let qrLabel = UILabel()
//            qrLabel.text = "📱"
//            qrLabel.font = UIFont.systemFont(ofSize: 60)
//            qrLabel.textAlignment = .center
//            qrLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // Thanks label
            let thanksLabel = UILabel()
            thanksLabel.text = "Thanks!"
            thanksLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
            thanksLabel.textColor = UIColor.systemGreen
            thanksLabel.textAlignment = .center
            thanksLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // Success message
            let messageLabel = UILabel()
            messageLabel.text = "Your attendance is marked. 😊"
            messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            messageLabel.textColor = UIColor.systemGreen
            messageLabel.textAlignment = .center
            messageLabel.numberOfLines = 0
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // Add subviews
            popupView.addSubview(closeButton)
            popupView.addSubview(qrImageView)   // ✅ use image instead of label
            popupView.addSubview(thanksLabel)
            popupView.addSubview(messageLabel)
            
            overlayView.addSubview(popupView)
            self.view.addSubview(overlayView)
            
            // Setup constraints
            NSLayoutConstraint.activate([
                // Popup constraints
                popupView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
                popupView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
                popupView.widthAnchor.constraint(equalToConstant: 280),
                popupView.heightAnchor.constraint(equalToConstant: 280),
                
                // Close button
                closeButton.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 15),
                closeButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -15),
                closeButton.widthAnchor.constraint(equalToConstant: 30),
                closeButton.heightAnchor.constraint(equalToConstant: 30),
                
                // QR Image
                qrImageView.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 50),
                qrImageView.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
                qrImageView.widthAnchor.constraint(equalToConstant: 80),
                qrImageView.heightAnchor.constraint(equalToConstant: 80),
                
                // Thanks label
                thanksLabel.topAnchor.constraint(equalTo: qrImageView.bottomAnchor, constant: 20),
                thanksLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 20),
                thanksLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -20),
                
                // Message label
                messageLabel.topAnchor.constraint(equalTo: thanksLabel.bottomAnchor, constant: 10),
                messageLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 20),
                messageLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -20),
                messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: popupView.bottomAnchor, constant: -30)
            ])
            
            // Add animation
            popupView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
                popupView.transform = CGAffineTransform.identity
            })
        }
    }
    
    @objc private func dismissCustomPopup() {
        if let overlayView = self.view.viewWithTag(999) {
            UIView.animate(withDuration: 0.2, animations: {
                overlayView.alpha = 0
            }) { _ in
                overlayView.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Custom Error Popup
    private func showCustomErrorPopup(message: String) {
        DispatchQueue.main.async {
            // Create background overlay
            let overlayView = UIView(frame: self.view.bounds)
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            overlayView.tag = 998 // Different tag for error popup
            
            // Create popup container
            let popupView = UIView()
            popupView.backgroundColor = UIColor.white
            popupView.layer.cornerRadius = 20
            popupView.translatesAutoresizingMaskIntoConstraints = false
            
            // Add shadow
            popupView.layer.shadowColor = UIColor.black.cgColor
            popupView.layer.shadowOffset = CGSize(width: 0, height: 4)
            popupView.layer.shadowRadius = 10
            popupView.layer.shadowOpacity = 0.3
            
            // Close button (X)
            let closeButton = UIButton(type: .system)
            closeButton.setTitle("✕", for: .normal)
            closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            closeButton.setTitleColor(UIColor.gray, for: .normal)
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            closeButton.addTarget(self, action: #selector(self.dismissCustomErrorPopup), for: .touchUpInside)
            
            // Error icon (red circle with exclamation mark)
            let errorIconView = UIView()
            errorIconView.backgroundColor = UIColor.systemRed
            errorIconView.layer.cornerRadius = 40 // Half of width/height for perfect circle
            errorIconView.translatesAutoresizingMaskIntoConstraints = false
            
            let exclamationLabel = UILabel()
            exclamationLabel.text = "!"
            exclamationLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
            exclamationLabel.textColor = UIColor.white
            exclamationLabel.textAlignment = .center
            exclamationLabel.translatesAutoresizingMaskIntoConstraints = false
            
            errorIconView.addSubview(exclamationLabel)
            
            // Error message
            let messageLabel = UILabel()
            messageLabel.text = message
            messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            messageLabel.textColor = UIColor.systemRed
            messageLabel.textAlignment = .center
            messageLabel.numberOfLines = 0
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // Add subviews
            popupView.addSubview(closeButton)
            popupView.addSubview(errorIconView)
            popupView.addSubview(messageLabel)
            
            overlayView.addSubview(popupView)
            self.view.addSubview(overlayView)
            
            // Setup constraints
            NSLayoutConstraint.activate([
                // Popup constraints
                popupView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
                popupView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
                popupView.widthAnchor.constraint(equalToConstant: 280),
                popupView.heightAnchor.constraint(equalToConstant: 280),
                
                // Close button
                closeButton.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 15),
                closeButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -15),
                closeButton.widthAnchor.constraint(equalToConstant: 30),
                closeButton.heightAnchor.constraint(equalToConstant: 30),
                
                // Error icon
                errorIconView.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 50),
                errorIconView.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
                errorIconView.widthAnchor.constraint(equalToConstant: 80),
                errorIconView.heightAnchor.constraint(equalToConstant: 80),
                
                // Exclamation mark inside error icon
                exclamationLabel.centerXAnchor.constraint(equalTo: errorIconView.centerXAnchor),
                exclamationLabel.centerYAnchor.constraint(equalTo: errorIconView.centerYAnchor),
                
                // Message label
                messageLabel.topAnchor.constraint(equalTo: errorIconView.bottomAnchor, constant: 30),
                messageLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 20),
                messageLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -20),
                messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: popupView.bottomAnchor, constant: -30)
            ])
            
            // Add animation
            popupView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
                popupView.transform = CGAffineTransform.identity
            })
        }
    }
    
    @objc private func dismissCustomErrorPopup() {
        if let overlayView = self.view.viewWithTag(998) {
            UIView.animate(withDuration: 0.2, animations: {
                overlayView.alpha = 0
            }) { _ in
                overlayView.removeFromSuperview()
            }
        }
    }
}


extension DashboardVC: QRScannerCodeDelegate {
    func qrScanner(_ controller: UIViewController, didScanQRCodeWithResult result: String) {
        print("result:\(result)")
        //Toast(text: "\(result)").show()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            AlertHelper.showAlert(from: self, title: "Successfully", message: "\(result)", completion: {
//                print("OK button tapped")
//            })
            
            if let location = decodeLatLong(from: result) {
                print("📍 Latitude: \(location.lat), Longitude: \(location.long)")
//                let calc = calculateDistance(userLat: self.qrLat, userLong: self.qrLong, qrLat: location.lat, qrLong: location.long)
//                
//                AlertHelper.showAlert(from: self, title: "Successfully", message: "Distance in meter is:\(calc)", completion: {
//                    print("OK button tapped")
//                })
                
                // Check if inside geofence (50m radius)
                if AttendanceHelper.isUserInsideAttendanceArea(userLat: location.lat,
                                                               userLong: location.long,
                                                               qrLat: self.qrLat,
                                                               qrLong: self.qrLong,
                                                               radius: 50) {
                    print("✅ User is inside attendance area")
                    
                    // Optional: get exact distance
                    let distance = AttendanceHelper.calculateDistance(userLat: location.lat,
                                                                      userLong: location.long,
                                                                      qrLat: self.qrLat,
                                                                      qrLong: self.qrLong)
                    print("📏 Distance: \(distance) meters")
                    
                    // 🚀 Call Attendance API
                    self.callAttendanceAPI(qrToken: result, distance: String(format: "%.2f", distance))
                    
                } else {
                    print("❌ User is outside attendance area")
                    AlertHelper.showAlert(from: self, title: "Failed", message: "❌ User is outside attendance area", completion: {
                        print("OK button tapped")
                    })
                }
            } else {
                // If QR doesn't contain location data, still call API with the QR token
                self.callAttendanceAPI(qrToken: result, distance: "")
            }
        }
    }

    func qrScanner(_ controller: UIViewController, didFailWithError error: SwiftQRCodeScanner.QRCodeError) {
        print("error:\(error.localizedDescription)")
    }

    func qrScannerDidCancel(_ controller: UIViewController) {
        print("SwiftQRScanner did cancel")
        Toast(text: "QR Closed").show()
    }
    
    // MARK: - Attendance API Call
    private func callAttendanceAPI(qrToken: String, distance: String) {
        let requestXML = getAttendanceRequestXML(qrToken: qrToken, distance: distance)
        
        APIManagerHandler.shared.callSOAPAPI_ins_studet_qr_attendance(requestXMLStr: requestXML) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let jsonData):
                    do {
                        print("📱 Raw JSON Response: \(String(data: jsonData, encoding: .utf8) ?? "")")
                        
                        // Try to decode as success response first (with result as array)
                        if let responseModel = try? JSONDecoder().decode(AttendanceResponseModel.self, from: jsonData) {
                            print("✅ Successfully decoded as AttendanceResponseModel")
                            if let success = responseModel.Success, success == "1" {
                                // Success case
                                let successMessage = responseModel.result?.first?.Column1 ?? "Attendance marked successfully!"
                                print("🎉 Success: \(successMessage)")
                                self.showCustomSuccessPopup()
                            } else {
                                // Error case with array result
                                let errorMessage = responseModel.result?.first?.Column1 ?? "Failed to mark attendance"
                                print("❌ Error: \(errorMessage)")
                                self.showCustomErrorPopup(message: errorMessage)
                            }
                            print("Attendance API Response: \(responseModel)")
                        } else {
                            // Try to decode as error response (with result as string)
                            print("🔄 Trying to decode as AttendanceErrorResponseModel")
                            let errorResponseModel = try JSONDecoder().decode(AttendanceErrorResponseModel.self, from: jsonData)
                            let errorMessage = errorResponseModel.result ?? "Failed to mark attendance"
                            print("❌ Error Response: \(errorMessage)")
                            self.showCustomErrorPopup(message: errorMessage)
                            print("Attendance Error Response: \(errorResponseModel)")
                        }
                    } catch {
                        print("Error decoding attendance response: \(error)")
                        AlertHelper.showAlert(from: self, title: "Error", message: "Failed to process attendance response", completion: {
                            print("Attendance API decode error")
                        })
                    }
                    
                case .failure(let error):
                    print("Attendance API Error: \(error.localizedDescription)")
                    AlertHelper.showAlert(from: self, title: "Error", message: "Network error: \(error.localizedDescription)", completion: {
                        print("Attendance API network error")
                    })
                }
            }
        }
    }
    
    private func getAttendanceRequestXML(qrToken: String, distance: String) -> String {
        let deviceUUID = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
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
            <ins_studet_qr_attendance xmlns="http://tempuri.org/">
              <std_id>\(UserDefaultsHelper.getSTDID() ?? "")</std_id>
              <course_code>\(UserDefaultsHelper.getCourseCode() ?? "")</course_code>
              <uuid>\(deviceUUID)</uuid>
              <qr_tokens>\(qrToken)</qr_tokens>
              <distance>\(distance)</distance>
              <lat_lng></lat_lng>
              <add></add>
            </ins_studet_qr_attendance>
          </soap:Body>
        </soap:Envelope>
        """
        
        return stringParams
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
              <course_code>\(UserDefaultsHelper.getCourseCode() ?? "")</course_code>
            <std_id>\(UserDefaultsHelper.getSTDID() ?? "")</std_id>
            </dis_std_dashboard>
             
          </soap:Body>
        </soap:Envelope>
        """
        
        return stringParams
    }
    

}


//extension UINavigationController {
//
//    func setStatusBar(backgroundColor: UIColor) {
//        let statusBarFrame: CGRect
//        if #available(iOS 13.0, *) {
//            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
//        } else {
//            statusBarFrame = UIApplication.shared.statusBarFrame
//        }
//        let statusBarView = UIView(frame: statusBarFrame)
//        statusBarView.backgroundColor = backgroundColor
//        view.addSubview(statusBarView)
//    }
//
//}
//
//extension UIApplication {
//
//    var statusBarUIView: UIView? {
//
//        if #available(iOS 13.0, *) {
//            let tag = 3848245
//
//            let keyWindow: UIWindow? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//
//            if let statusBar = keyWindow?.viewWithTag(tag) {
//                return statusBar
//            } else {
//                let height = keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
//                let statusBarView = UIView(frame: height)
//                statusBarView.tag = tag
//                statusBarView.layer.zPosition = 999999
//                
//                keyWindow?.addSubview(statusBarView)
//                return statusBarView
//            }
//
//        } else {
//
//            if responds(to: Selector(("statusBar"))) {
//                return value(forKey: "statusBar") as? UIView
//            }
//        }
//        return nil
//      }
//}



import CoreLocation

func calculateDistance(userLat: Double, userLong: Double,
                       qrLat: Double, qrLong: Double) -> Double {
    let userLocation = CLLocation(latitude: userLat, longitude: userLong)
    let qrLocation   = CLLocation(latitude: qrLat, longitude: qrLong)
    
    // ✅ Returns distance in meters (Double)
    return userLocation.distance(from: qrLocation)
}

import Foundation
func decodeLatLong(from encoded: String) -> (lat: Double, long: Double)? {
    var decoded = encoded
    decoded = decoded.replacingOccurrences(of: "&NORT", with: ".")
    decoded = decoded.replacingOccurrences(of: "WEST", with: ",")
    decoded = decoded.replacingOccurrences(of: "&LMS", with: ".")
    
    let components = decoded.split(separator: ",")
    if components.count == 2 {
        if let lat = Double(components[0]),
           let long = Double(components[1]) {
            return (lat, long)
        }
    }
    return nil
}

// MARK: - Attendance Response Model
struct AttendanceResponseModel: Codable {
    let Success: String?
    let result: [AttendanceResult]?
    
    enum CodingKeys: String, CodingKey {
        case Success
        case result
    }
}

struct AttendanceResult: Codable {
    let Column1: String?
    
    enum CodingKeys: String, CodingKey {
        case Column1
    }
}

// Alternative response model for error cases
struct AttendanceErrorResponseModel: Codable {
    let Success: String?
    let result: String?
    
    enum CodingKeys: String, CodingKey {
        case Success
        case result
    }
}
