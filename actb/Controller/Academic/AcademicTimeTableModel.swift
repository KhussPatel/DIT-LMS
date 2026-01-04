//
//  AcademicTimeTableModel.swift
//  BrittsImperial
//
//  Created by Khuss on 26/06/24.
//

import Foundation
// MARK: - AcademicTimeTableModel
struct AcademicTimeTableModel: Codable {
    let result: [AcademicTimeTableList]?
    let success: String?

    enum CodingKeys: String, CodingKey {
        case result
        case success = "Success"
    }
}

// MARK: - Result
struct AcademicTimeTableList: Codable {
    let batch, classRoom, name, fromTime: String?
    let email, toTime, dayName: String?

    enum CodingKeys: String, CodingKey {
        case batch
        case classRoom = "class_room"
        case name
        case fromTime = "from_time"
        case email
        case toTime = "to_time"
        case dayName = "day_name"
    }
}
