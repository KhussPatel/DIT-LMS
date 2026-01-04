//
//  NoticeBoardModel.swift
//  BrittsImperial
//
//  Created by Khuss on 26/06/24.
//

import Foundation
// MARK: - NoticeBoardModel
struct NoticeBoardModel: Codable {
    let success: String?
    let result: [NoticeBoardList]?

    enum CodingKeys: String, CodingKey {
        case success = "Success"
        case result
    }
}

// MARK: - Result
struct NoticeBoardList: Codable {
    let desc: String?
    let fileList: String?
    let postBy: String?
    let noticeID: Int?
    let intake: String?
    let fileCount: Int?
    let postDate, title, campus, course: String?

    enum CodingKeys: String, CodingKey {
        case desc
        case fileList = "file_list"
        case postBy = "post_by"
        case noticeID = "notice_id"
        case intake
        case fileCount = "file_count"
        case postDate = "post_date"
        case title, campus, course
    }
}
