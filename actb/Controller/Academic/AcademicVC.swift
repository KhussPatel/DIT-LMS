//
//  AcademicVC.swift
//  BrittsImperial
//
//  Created by Khuss on 26/06/24.
//

import UIKit

class AcademicVC: UIViewController {
    @IBOutlet weak var tblTimeTable: UITableView!
    @IBOutlet weak var vwHeader: UIView!
    
    var arrTimeTable = [AcademicTimeTableList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getAcademicTimeTable()
    }

    @IBAction func btnBACK(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AcademicVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTimeTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AcademicCell") as! AcademicCell
        cell.setData(obj: arrTimeTable[indexPath.row])
        return cell
    }
    
    
}

extension AcademicVC{
    
    
    func getAcademicTimeTable(){
        APIManagerHandler.shared.callSOAPAPI_dis_student_wise_cap_chart(requestXMLStr: getRequestXML()) { result in
            switch result {
            case .success(let jsonData):
                // Handle the JSON response here
                do {
                    let responseModel = try JSONDecoder().decode(AcademicTimeTableModel.self, from: jsonData)
                    
                    if let temp = responseModel.result, temp.count > 0{
                        self.arrTimeTable = temp
                        self.vwHeader.isHidden = false
                        
                    }else{
                        self.arrTimeTable.removeAll()
                        self.vwHeader.isHidden = true
                    }
                    
                    self.tblTimeTable.reloadData()
                    
                    
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
             <dis_student_wise_cap_chart xmlns="http://tempuri.org/">
                  <course_code>\(UserDefaultsHelper.getCourseCode() ?? "")</course_code>
                              <campus>\(UserDefaultsHelper.getCampus() ?? "")</campus>
                                    <std_id>\(UserDefaultsHelper.getSTDID() ?? "")</std_id>
                </dis_student_wise_cap_chart>
              </soap:Body>
            </soap:Envelope>
            """
        
        return stringParams
    }
    
}
//MARK: ------ UITableViewCell ---------
class AcademicCell: UITableViewCell {

    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblSTime: UILabel!
    @IBOutlet weak var lblETime: UILabel!
    @IBOutlet weak var lblClassRoom: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func setData(obj: AcademicTimeTableList){
        if let dday = obj.dayName{
            //lblDay.text = shortDayName(from: day)
            lblDay.text = dday
        }
        
        if let room = obj.classRoom{
            lblClassRoom.text = room
        }
        
        
        lblSTime.text = obj.fromTime ?? ""
        lblETime.text = obj.toTime ?? ""
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func shortDayName(from fullName: String) -> String? {
        let dayMapping: [String: String] = [
            "Monday": "Mon",
            "Tuesday": "Tue",
            "Wednesday": "Wed",
            "Thursday": "Thu",
            "Friday": "Fri",
            "Saturday": "Sat",
            "Sunday": "Sun"
        ]
        
        return dayMapping[fullName]
    }

    func removeRoomPrefix(from string: String) -> String {
        let result = string.replacingOccurrences(of: "Room ", with: "")
        return result
    }
}

class AcademicTimetableViewController: UIViewController {

    @IBOutlet weak var vwMain: UIView!
    
    let scrollView = UIScrollView()
    let mainStackView = UIStackView()

    var arrTimeTable: [AcademicTimeTableList] = [] // Fill from API

    override func viewDidLoad() {
        super.viewDidLoad()
        vwMain.backgroundColor = .systemGroupedBackground
        setupUI()
        getAcademicTimeTable()
        populateStackView()
    }
    
    @IBAction func btnBACK(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        vwMain.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: vwMain.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: vwMain.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: vwMain.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: vwMain.bottomAnchor)
        ])

        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(mainStackView)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }

    

    func populateStackView() {
        mainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let grouped = Dictionary(grouping: arrTimeTable, by: { $0.dayName })
        let sortedDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

        for day in sortedDays {
            if let entries = grouped[day] {
                let cardView = DayCardView(day: day, entries: entries)
                mainStackView.addArrangedSubview(cardView)
            }
        }
    }
    
    func getAcademicTimeTable() {
        APIManagerHandler.shared.callSOAPAPI_dis_student_wise_cap_chart(requestXMLStr: getRequestXML()) { result in
            switch result {
            case .success(let jsonData):
                do {
                    let responseModel = try JSONDecoder().decode(AcademicTimeTableModel.self, from: jsonData)
                    if let temp = responseModel.result, !temp.isEmpty {
                        self.arrTimeTable = temp
                        DispatchQueue.main.async {
                            self.populateStackView()
                        }
                    }
                } catch {
                    print("Decoding error: \(error)")
                }

            case .failure(let error):
                print("API error: \(error.localizedDescription)")
            }
        }
    }
    
    func getRequestXML() -> String {
        return """
        <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                       xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
          <soap:Header>
            <AuthUser xmlns="http://tempuri.org/">
              <UserName>Admin</UserName>
              <Password>123</Password>
              <Token>College</Token>
            </AuthUser>
          </soap:Header>
          <soap:Body>
            <dis_student_wise_cap_chart xmlns="http://tempuri.org/">
              <course_code>\(UserDefaultsHelper.getCourseCode() ?? "")</course_code>
              <campus>\(UserDefaultsHelper.getCampus() ?? "")</campus>
              <std_id>\(UserDefaultsHelper.getSTDID() ?? "")</std_id>
            </dis_student_wise_cap_chart>
          </soap:Body>
        </soap:Envelope>
        """
    }

}


import UIKit

class DayCardView: UIView {

    private let titleLabel = UILabel()
    private let stackView = UIStackView()

    init(day: String, entries: [AcademicTimeTableList]) {
        super.init(frame: .zero)
        setupUI()
        configure(day: day, entries: entries)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 4

        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = UIColor(rgb: 0xFB8801)

        stackView.axis = .vertical
        stackView.spacing = 0

        let container = UIStackView(arrangedSubviews: [titleLabel, stackView])
        container.axis = .vertical
        container.spacing = 8
        container.translatesAutoresizingMaskIntoConstraints = false

        addSubview(container)
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    private func configure(day: String, entries: [AcademicTimeTableList]) {
        titleLabel.text = day.uppercased()
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for (i, entry) in entries.enumerated() {
            let slot = TimeSlotView(
                time: "\(entry.fromTime ?? "") – \(entry.toTime ?? "")",
                location: entry.classRoom ?? "",
                showSeparator: i != entries.count - 1
            )
            stackView.addArrangedSubview(slot)
        }
    }
}


import UIKit

class TimeSlotView: UIView {

    private let timeLabel = UILabel()
    private let locationLabel = UILabel()
    private let separator = UIView()

    init(time: String, location: String, showSeparator: Bool) {
        super.init(frame: .zero)
        setupUI()
        timeLabel.text = time
        locationLabel.text = location
        separator.isHidden = !showSeparator
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [timeLabel, locationLabel])
        stack.axis = .vertical
        stack.spacing = 2

        timeLabel.font = .boldSystemFont(ofSize: 14)
        locationLabel.font = .systemFont(ofSize: 13)
        locationLabel.textColor = .darkGray

        separator.backgroundColor = .lightGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true

        let wrapper = UIStackView(arrangedSubviews: [stack, separator])
        wrapper.axis = .vertical
        wrapper.spacing = 8

        addSubview(wrapper)
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            wrapper.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            wrapper.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            wrapper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            wrapper.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
