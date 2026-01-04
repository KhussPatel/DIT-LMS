//
//  ScheduleListVC.swift
//  BrittsImperial
//
//  Created by Khuss on 27/09/23.
//

import UIKit
import Foundation

class ScheduleListVC: UIViewController {
    
    
    fileprivate let actionButton = JJFloatingActionButton()
    @IBOutlet weak var btnSelectDate: UIButton!
    @IBOutlet weak var tblSchedule: UITableView!
    @IBOutlet weak var vwList: UIView!
    @IBOutlet weak var vwFull: UIView!
    @IBOutlet weak var lblHeader: UILabel!
    
    @IBOutlet weak var tblScheduleFullView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    var arrScheduleList = [ScheduleListData]()
    var userSelectedDate = ""
    
    
    var arrSelectedDate = [ScheduleListData]()
    var arrOtherDate = [ScheduleListData]()
    
    
    var arrcurrent = [ScheduleListData]()
    var arrUpcomming = [ScheduleListData]()
    var arrPrevious = [ScheduleListData]()
    
    var isListView = true
    var selectedSegment = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        actionButton.buttonColor = UIColor(rgb: 0xdd4334)
        actionButton.configureDefaultItem { item in
            
            item.buttonColor = UIColor(rgb: 0xdd4334)
        }
        
        
        actionButton.addItem(title: "Full View", image: UIImage(named: "fullscreen")) { item in
           print(item)
            self.vwList.isHidden = true
            self.vwFull.isHidden = false
            self.isListView = false
            UserDefaultsHelper.setIsFullView(true)
            self.tblScheduleFullView.reloadData()
            self.lblHeader.text = "Full View"
        }

        actionButton.addItem(title: "Schedule List", image: UIImage(named: "list")) { item in
            print(item)
            self.vwList.isHidden = false
            self.vwFull.isHidden = true
            UserDefaultsHelper.setIsFullView(false)
            self.isListView = true
            
            self.tblSchedule.reloadData()
            self.lblHeader.text = "Schedule List"
        }

        actionButton.display(inViewController: self)
        
        
        if UserDefaultsHelper.getIsFullView() ?? false{
            self.vwList.isHidden = true
            self.vwFull.isHidden = false
            isListView = false
            self.tblScheduleFullView.reloadData()
            lblHeader.text = "Full View"
        }else{
            self.vwList.isHidden = false
            self.vwFull.isHidden = true
            isListView = true
            self.tblSchedule.reloadData()
            lblHeader.text = "Schedule List"
        }
        
        getScheduleList()
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM, YYYY"
        let formattedDate = dateFormatter.string(from: Date())
        userSelectedDate = formattedDate
        btnSelectDate.setTitle("\(formattedDate)", for: .normal)
        
        segmentedControl.setTitle("\(formattedDate)", forSegmentAt: 0)
        segmentedControl.setTitle("Upcoming", forSegmentAt: 1)
        segmentedControl.setTitle("Past", forSegmentAt: 2)
        
        segemtnSetup()
        
        //Toast(text: "\(UserDefaultsHelper.getSTDID() ?? "") Student ID").show()
    }
    
    func segemtnSetup(){
        let unselectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 14)
        ]
        segmentedControl.setTitleTextAttributes(unselectedTextAttributes, for: .normal)
        
        // Set selected text color
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(rgb: 0x4C4A48),
            .font: UIFont.boldSystemFont(ofSize: 16)
        ]
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
    }
    
    
    
    @IBAction func segmentedControlButtonClickAction(_ sender: UISegmentedControl) {
        print(" Segment Select ===\(sender.selectedSegmentIndex)")
       if sender.selectedSegmentIndex == 0 {
          print("First Segment Select")
           selectedSegment = sender.selectedSegmentIndex
       }else if sender.selectedSegmentIndex == 1{
           selectedSegment = sender.selectedSegmentIndex
       }else if sender.selectedSegmentIndex == 2{
           selectedSegment = sender.selectedSegmentIndex
       }
        
        tblScheduleFullView.reloadData()
    }
    
    @IBAction func btn_BACK(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btn_SELECT_DATE(_ sender: UIButton) {

        let vc = SambagMonthYearPickerViewController()
        var limit = SambagSelectionLimit()
        limit.selectedDate = Date()
        let calendar = Calendar.current
        limit.minDate = calendar.date(
            byAdding: .year,
            value: -10,
            to: limit.selectedDate,
            wrappingComponents: false
        )
        limit.maxDate = calendar.date(
            byAdding: .year,
            value: 0,
            to: limit.selectedDate,
            wrappingComponents: false
        )
        vc.limit = limit
        vc.theme = .light
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }

    func filterFullView(){
        
        self.arrcurrent.removeAll()
        self.arrPrevious.removeAll()
        self.arrUpcomming.removeAll()
        
        let cateArray = categorizeEvents(events: arrScheduleList)
        
        self.arrcurrent = cateArray.currentMonth
        self.arrPrevious = cateArray.previousMonths
        self.arrUpcomming = cateArray.upcomingMonths
        

        
        tblSchedule.reloadData()
        tblScheduleFullView.reloadData()
    }
    
    func filterDate(){// List view Selected month filter
        arrSelectedDate.removeAll()
        
        for itemm in self.arrScheduleList{
            
            if let startDate = itemm.startDate,
               let endDate = itemm.endDate{
                let olDateFormatter = DateFormatter()
                olDateFormatter.dateFormat = "dd MMM, yyyy"
                let oldDate = olDateFormatter.date(from: startDate)
                let end_date = olDateFormatter.date(from: endDate)
                
                let convertDateFormatter = DateFormatter()
                convertDateFormatter.dateFormat = "MMM, yyyy"
                
                let newDate = convertDateFormatter.string(from: oldDate ?? Date())
                let e_newDate = convertDateFormatter.string(from: end_date ?? Date())
                
                if newDate == self.userSelectedDate || e_newDate == self.userSelectedDate{
                    self.arrSelectedDate.append(itemm)
                }else {
                    self.arrOtherDate.append(itemm)
                }
            }
        }
        
        tblSchedule.reloadData()
        tblScheduleFullView.reloadData()
    }
    
    func categorizeEvents(events: [ScheduleListData]) -> (currentMonth: [ScheduleListData], upcomingMonths: [ScheduleListData], previousMonths: [ScheduleListData]) {
        // Get the current month and year
        let currentDate = Date()
        let currentMonth = Calendar.current.component(.month, from: currentDate)
        let currentYear = Calendar.current.component(.year, from: currentDate)

        var arrayCurrentMonth: [ScheduleListData] = []
        var arrayPreviousMonth: [ScheduleListData] = []
        var arrayUpcomingMonths: [ScheduleListData] = []

        for event in events {
            if let (startMonth, startYear) = extractMonthAndYear(from: event.startDate!),
               let (endMonth, endYear) = extractMonthAndYear(from: event.endDate!) {

                // Check if the start_date or end_date is in the current month
                if startMonth == currentMonth && startYear == currentYear {
                    arrayCurrentMonth.append(event)
                } else if endMonth > currentMonth || endYear > currentYear {
                    // Check if the end_date is in an upcoming month (after current month)
                    arrayUpcomingMonths.append(event)
                } else {
                    // Otherwise, it's in a previous month
                    arrayPreviousMonth.append(event)
                }
            }
        }

        return (arrayCurrentMonth, arrayUpcomingMonths, arrayPreviousMonth)
    }
    
    func extractMonthAndYear(from dateString: String) -> (Int, Int)? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"  // Assuming the date format from your JSON

        if let date = dateFormatter.date(from: dateString) {
            let components = Calendar.current.dateComponents([.month, .year], from: date)
            return (components.month!, components.year!)
        }
        return nil
    }
}

extension ScheduleListVC : SambagMonthYearPickerViewControllerDelegate{
    func sambagMonthYearPickerDidSet(_ viewController: SambagMonthYearPickerViewController, result: SambagMonthYearPickerResult) {
        
        self.dismiss(animated: true, completion: nil)
        
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "MMM yyyy"
        let oldDate = olDateFormatter.date(from: "\(result)")
        
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "MMM, yyyy"
        
        let newDate = convertDateFormatter.string(from: oldDate ?? Date())
        
        btnSelectDate.setTitle(newDate, for: .normal)
        userSelectedDate = newDate
        filterDate()
    }
    
    func sambagMonthYearPickerDidCancel(_ viewController: SambagMonthYearPickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

extension ScheduleListVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isListView{
            return self.arrSelectedDate.count
        }else{
            if selectedSegment == 0{
                return self.arrcurrent.count
            }else if selectedSegment == 1{
                return self.arrUpcomming.count
            }else if selectedSegment == 2{
                return self.arrPrevious.count
            }
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isListView{
            if let unitCode = arrSelectedDate[indexPath.row].unitCode, unitCode == "Term Break"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CellNA") as! ScheduleCell
                
                cell.lblDates.text = "\(arrSelectedDate[indexPath.row].startDate ?? "N/A") to \(arrSelectedDate[indexPath.row].endDate ?? "N/A")"
                
                
                
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ScheduleCell
            
            cell.lblDates.text = "\(arrSelectedDate[indexPath.row].startDate ?? "N/A") to \(arrSelectedDate[indexPath.row].endDate ?? "N/A")"
            
            cell.lblUnitName.text = arrSelectedDate[indexPath.row].unitName ?? "N/A"
            
            //cell.lblUnitCode.text = arrSelectedDate[indexPath.row].unitCode ?? "N/A"
            
            if let startDate = arrSelectedDate[indexPath.row].startDate{
                let result = isTodayBeforeOrEqualToStartDate(startDate: startDate)
                if result{
                    cell.vw_ViewAll.isHidden = true
                }else{
                    cell.vw_ViewAll.isHidden = false
                }
            }
            
            
            cell.btn_VIEW.tag = indexPath.row
            cell.btn_VIEW.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
            
            return cell
            
        }else{
            
            var tempObj : ScheduleListData!
            
            if selectedSegment == 0{
                tempObj = arrcurrent[indexPath.row]
            }else if selectedSegment == 1{
                tempObj = arrUpcomming[indexPath.row]
            }else if selectedSegment == 2{
                tempObj = arrPrevious[indexPath.row]
            }
            
        
            
//            if let unitCode = tempObj.unitCode, unitCode == "Term Break"{
//                let cell = tableView.dequeueReusableCell(withIdentifier: "CellNA") as! ScheduleCell
//
//                cell.lblDates.text = "\(tempObj.startDate ?? "N/A") to \(tempObj.endDate ?? "N/A")"
//
//
//
//                return cell
//            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ScheduleCell
            
            cell.lblDates.text = "\(tempObj.startDate ?? "N/A") to \(tempObj.endDate ?? "N/A")"
            
            cell.lblUnitName.text = tempObj.unitName ?? "N/A"
            
            if cell.lblUnitCode != nil{
                cell.lblUnitCode.text = tempObj.unitCode ?? "N/A"
            }
            
            
            if let startDate = tempObj.startDate{
                let result = isTodayBeforeOrEqualToStartDate(startDate: startDate)
                if result{
                    cell.vw_ViewAll.isHidden = true
                }else{
                    cell.vw_ViewAll.isHidden = false
                }
            }
            
            if let unitCode = tempObj.unitCode, unitCode == "Term Break"{
                cell.lblUnitName.text = "Term Break"
                cell.vw_ViewAll.isHidden = true
                if cell.lblUnitCode != nil{
                    cell.lblUnitCode.text = ""
                }
                
            }
            
            
            cell.btn_VIEW.tag = indexPath.row
            cell.btn_VIEW.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
            
            return cell

        }
        
        
        
        
    }
    
    @objc func buttonSelected(sender: UIButton){
        print(sender.tag)
        var tempObj : ScheduleListData!
        
        if isListView{
            tempObj = arrSelectedDate[sender.tag]
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleOptionVC") as! ScheduleOptionVC
            next.unitTitle = tempObj.unitName ?? ""
            next.unitCode = tempObj.unitCode ?? ""
            
            self.navigationController?.pushViewController(next, animated: true)
        }else{
            if selectedSegment == 0{
                tempObj = arrcurrent[sender.tag]
            }else if selectedSegment == 1{
                tempObj = arrUpcomming[sender.tag]
            }else if selectedSegment == 2{
                tempObj = arrPrevious[sender.tag]
            }
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleOptionVC") as! ScheduleOptionVC
            next.unitTitle = tempObj.unitName ?? ""
            next.unitCode = tempObj.unitCode ?? ""
            
            self.navigationController?.pushViewController(next, animated: true)
        }
        
        
        
    }
    
    func isTodayBeforeOrEqualToStartDate(startDate: String) -> Bool {
        // Create a DateFormatter instance
        let dateFormatter = DateFormatter()
        // Set the date format to match the format of the "start_date" string
        dateFormatter.dateFormat = "dd MMM, yyyy"
        // Convert the "start_date" string to a Date object
        if let startDateObject = dateFormatter.date(from: startDate) {
            // Get the current date
            let currentDate = Date()
            // Compare the current date with the start date
            return currentDate <= startDateObject
        } else {
            // Handle invalid date format
            return false
        }
    }
}

extension ScheduleListVC{

    func convertDateFormat(inputDate: String) -> String {

         let olDateFormatter = DateFormatter()
         olDateFormatter.dateFormat = "dd MMM, yyyy"

         let oldDate = olDateFormatter.date(from: inputDate)

         let convertDateFormatter = DateFormatter()
         convertDateFormatter.dateFormat = "MMM, yyyy"

         return convertDateFormatter.string(from: oldDate!)
    }
    
}

extension ScheduleListVC{
    
    func getScheduleList(){
        APIManagerHandler.shared.callSOAPAPIforDis_full_view_ac_cal_for_student(requestXMLStr: getRequestXML()) { result in
            switch result {
            case .success(let jsonData):
                // Handle the JSON response here
                do {
                    let responseModel = try JSONDecoder().decode(ScheduleListModel.self, from: jsonData)
                    
                    if let data = responseModel.result{
                        self.arrScheduleList = data
                        
                        self.filterFullView()
                        
                        for itemm in data{
                            
                            if let startDate = itemm.startDate,
                               let endDate = itemm.endDate{
                                
                                let olDateFormatter = DateFormatter()
                                olDateFormatter.dateFormat = "dd MMM, yyyy"
                                let oldDate = olDateFormatter.date(from: startDate)
                                let end_date = olDateFormatter.date(from: endDate)
                                
                                let convertDateFormatter = DateFormatter()
                                convertDateFormatter.dateFormat = "MMM, yyyy"
                                
                                let newDate = convertDateFormatter.string(from: oldDate ?? Date())
                                
                                let e_newDate = convertDateFormatter.string(from: end_date ?? Date())
                                
                                if newDate == self.userSelectedDate || e_newDate == self.userSelectedDate{
                                    self.arrSelectedDate.append(itemm)
                                }else{
                                    self.arrOtherDate.append(itemm)
                                }
                            }
                            
                        }
                        
                        self.tblSchedule.reloadData()
                        self.tblScheduleFullView.reloadData()
                    }
                    
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
         <dis_full_view_ac_cal_for_student xmlns="http://tempuri.org/">
              <course_code>\(UserDefaultsHelper.getCourseCode() ?? "")</course_code>
                      <std_id>\(UserDefaultsHelper.getSTDID() ?? "")</std_id>
            </dis_full_view_ac_cal_for_student>
          </soap:Body>
        </soap:Envelope>
        """
        
        return stringParams
    }
}
