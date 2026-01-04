//
//  ProfileModel.swift
//  BrittsImperial
//
//  Created by mac on 06/07/24.
//

import Foundation

// MARK: - ProfileModel
struct ProfileModel: Codable {
    let result2: [ProfileData2]?
    let success: String?
    let result: [ProfileData]?

    enum CodingKeys: String, CodingKey {
        case result2
        case success = "Success"
        case result
    }
}

// MARK: - Result
struct ProfileData: Codable {
    let fName, mobileNo, email, fmName: String?
    let stdID: String?
    let profilePicLive: String?
    let dob, sName: String?

    enum CodingKeys: String, CodingKey {
        case fName = "f_name"
        case mobileNo = "mobile_no"
        case email
        case fmName = "fm_name"
        case stdID = "std_id"
        case profilePicLive = "profile_pic_live"
        case dob
        case sName = "s_name"
    }
}

// MARK: - Result2
struct ProfileData2: Codable {
    let mobileNo, sName, proposedStartDate, stdID: String?
    let fName, fmName, locationName, courseCode: String?
    let actualLocation, courseName, coeCode, proposedEndDate: String?
    let dob, email: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case mobileNo = "mobile_no"
        case sName = "s_name"
        case proposedStartDate = "proposed_start_date"
        case stdID = "std_id"
        case fName = "f_name"
        case fmName = "fm_name"
        case locationName = "location_name"
        case courseCode = "course_code"
        case actualLocation = "actual_location"
        case courseName = "course_name"
        case coeCode = "coe_code"
        case proposedEndDate = "proposed_end_date"
        case dob, email, id
    }
}
