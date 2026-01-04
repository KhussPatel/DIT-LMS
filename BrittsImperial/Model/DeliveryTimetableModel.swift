//
//  DeliveryTimetableModel.swift
//  BrittsImperial
//
//  Created by Khuss on 07/10/23.
//

import Foundation

// MARK: - DeliveryTimetableModel
struct DeliveryTimetableModel: Codable {
    let result: [DeliveryTimetableData]?
    let success: String?

    enum CodingKeys: String, CodingKey {
        case result
        case success = "Success"
    }
}

// MARK: - Result
struct DeliveryTimetableData: Codable {
    let dayName, trainerName, trainerEmail, fromTime: String?
    let toTime, premises: String?

    enum CodingKeys: String, CodingKey {
        case dayName = "day_name"
        case trainerName = "trainer_name"
        case trainerEmail = "trainer_email"
        case fromTime = "from_time"
        case toTime = "to_time"
        case premises
    }
}
