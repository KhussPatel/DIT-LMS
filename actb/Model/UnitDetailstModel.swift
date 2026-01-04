//
//  UnitDetailstModel.swift
//  BrittsImperial
//
//  Created by Khuss on 21/10/23.
//

import Foundation
import Foundation

// MARK: - UnitDetailstModel
struct UnitDetailstModel: Codable {
    let result: [UnitDetailstResult]?
    let success: String?

    enum CodingKeys: String, CodingKey {
        case result
        case success = "Success"
    }
}

// MARK: - Result
struct UnitDetailstResult: Codable {
    let assID: Int?
    let name, unitCode: String?
    let assignmentPath: String?
    let assignment: String?
    let id: Int?
    let resourcesPath: String?
    let resources: String?
    let video: String?
    
    enum CodingKeys: String, CodingKey {
        case assID = "ass_id"
        case name
        case unitCode = "unit_code"
        case assignmentPath = "assignment_path"
        case assignment
        case id
        case resourcesPath = "resources_path"
        case resources
        case video
    }
}

