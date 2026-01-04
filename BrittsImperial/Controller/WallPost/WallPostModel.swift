//
//  WallPostModel.swift
//  BrittsImperial
//
//  Created by Khuss on 27/06/24.
//

import Foundation
// MARK: - WallPostModel
struct WallPostModel: Codable {
    let result: [WallPostList]?
    let success: String?

    enum CodingKeys: String, CodingKey {
        case result
        case success = "Success"
    }
}

// MARK: - Result
struct WallPostList: Codable {
    let title: String?
    let fileList: String?
    let fileCount: Int?
    let postDate, campus: String?
    let desc: String?
    let type: String?
    let postID: Int?
    let intake, course, postBy: String?

    enum CodingKeys: String, CodingKey {
        case title
        case fileList = "file_list"
        case fileCount = "file_count"
        case postDate = "post_date"
        case campus, desc, type
        case postID = "post_id"
        case intake, course
        case postBy = "post_by"
    }
}
