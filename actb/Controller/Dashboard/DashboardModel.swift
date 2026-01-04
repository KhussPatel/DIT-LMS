//
//  DashboardModel.swift
//  BrittsImperial
//
//  Created by Khuss on 29/06/24.
//

import Foundation

// MARK: - DashboardModel
struct DashboardModel: Codable {
    let result2: [DashboardList]?
    let success: String?
    let result, result3: [DashboardList]?

    enum CodingKeys: String, CodingKey {
        case result2
        case success = "Success"
        case result, result3
    }
}

// MARK: - Result
struct DashboardList: Codable {
    let unitName, unitCode: String?
    let assignmentLink: String?
    let name: String?
    let resources: String?
    let video: String?

    enum CodingKeys: String, CodingKey {
        case unitName = "unit_name"
        case unitCode = "unit_code"
        case name, resources, video
        case assignmentLink = "assignment"
    }
}
