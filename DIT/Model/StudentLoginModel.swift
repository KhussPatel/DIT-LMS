//
//  StudentLoginModel.swift
//  BrittsImperial
//
//  Created by Khuss on 07/10/23.
//


//   let studentLoginModel = try? JSONDecoder().decode(StudentLoginModel.self, from: jsonData)

import Foundation

// MARK: - StudentLoginModel
struct StudentLoginModel: Codable {
    let success: String?
    let result: [StudentLoginData]?

    enum CodingKeys: String, CodingKey {
        case success = "Success"
        case result
    }
}


// MARK: - Result
struct StudentLoginData: Codable {
    let pass, mobileNo, proposedStartDate, fmName: String?
    let proposedEndDate, stdType, mail, courseCode: String?
    let id: Int?
    let stdID, dob, campus, familyName: String?
    let email, appVer, coeCode, courseName: String?
    let profilePicLive: String?
    let username, otp: String?

    enum CodingKeys: String, CodingKey {
        case pass
        case mobileNo = "Mobile"
        case proposedStartDate = "proposed_start_date"
        case fmName = "First_Name"
        case proposedEndDate = "proposed_end_date"
        case stdType = "std_type"
        case mail
        case courseCode = "course_code"
        case id
        case stdID = "std_id"
        case dob, campus
        case familyName = "Family_Name"
        case email = "Email_Address"
        case appVer = "app_ver"
        case coeCode = "coe_code"
        case courseName = "course_name"
        case profilePicLive = "profile_pic_live"
        case username, otp
    }
}
