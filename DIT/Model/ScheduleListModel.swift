//
//  ScheduleListModel.swift
//  BrittsImperial
//
//  Created by Khuss on 10/10/23.
//

//   let scheduleListModel = try? JSONDecoder().decode(ScheduleListModel.self, from: jsonData)

import Foundation

// MARK: - ScheduleListModel
struct ScheduleListModel: Codable {
    let success: String?
    let result: [ScheduleListData]?

    enum CodingKeys: String, CodingKey {
        case success = "Success"
        case result
    }
}

// MARK: - Result
struct ScheduleListData: Codable {
    let monthDiff2, monthDiff: Int?
    let startDate, term: String?
    let unitName: String?
    let seqWeek, endDate: String?
    let core: Core?
    let unitCode: String?

    enum CodingKeys: String, CodingKey {
        case monthDiff2 = "month_diff2"
        case monthDiff = "month_diff"
        case startDate = "start_date"
        case term
        case unitName = "unit_name"
        case seqWeek = "seq_week"
        case endDate = "end_date"
        case core
        case unitCode = "unit_code"
    }
}

enum Core: String, Codable {
    case core = "Core"
    case coreElective = "Elective"
    case elective = "Elective "
    case empty = ""
}
