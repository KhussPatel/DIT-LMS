//
//  FeesDataModel.swift
//  BrittsImperial
//
//  Created by Khuss on 21/11/23.
//
//   let feesModel = try? JSONDecoder().decode(FeesModel.self, from: jsonData)

import Foundation

// MARK: - FeesModel
struct FeesModel: Codable {
    let result3: [ResultData3]?
    let result2: [ResultData2]?
    let result4: [ResultData4]?
    let success: String?
    let result: [ResultData]?

    enum CodingKeys: String, CodingKey {
        case result3, result2, result4
        case success = "Success"
        case result
    }
}

// MARK: - Result
struct ResultData: Codable {
    let collectedFee: Double?
    let note: String?
    let rowNumber, feeHeadID: Int?
    let date, currencyCode, feeHead: String?
    let remainFee: Double?
    let fee, id: Int?

    enum CodingKeys: String, CodingKey {
        case collectedFee = "collected_fee"
        case note
        case rowNumber = "RowNumber"
        case feeHeadID = "fee_head_id"
        case date
        case currencyCode = "currency_code"
        case feeHead = "fee_head"
        case remainFee = "remain_fee"
        case fee, id
    }
}

// MARK: - Result2
struct ResultData2: Codable {
    let paymentModeDetail, recCurrencyCode, collectionDate: String?
    let recAmount: Int?
    let paymentSubMode, note: String?
    let fcID: Int?
    let feeHead: String?
    let usdAmount: Double?
    let paymentMode, recCurrencyIcon: String?
    let exchangeRate: Double?

    enum CodingKeys: String, CodingKey {
        case paymentModeDetail = "payment_mode_detail"
        case recCurrencyCode = "rec_currency_code"
        case collectionDate = "collection_date"
        case recAmount = "rec_amount"
        case paymentSubMode = "payment_sub_mode"
        case note
        case fcID = "fc_id"
        case feeHead = "fee_head"
        case usdAmount = "usd_amount"
        case paymentMode = "payment_mode"
        case recCurrencyIcon = "rec_currency_icon"
        case exchangeRate = "exchange_rate"
    }
}

// MARK: - Result3
struct ResultData3: Codable {
    let name, nameWithIcon: String?
    let id: Int?
    let code, icon: String?
    let rate: Double?

    enum CodingKeys: String, CodingKey {
        case name
        case nameWithIcon = "name_with_icon"
        case id, code, icon, rate
    }
}

// MARK: - Result4
struct ResultData4: Codable {
    let remainFee: Double?
    let feeHead: String?
    let collectedFee: Double?
    let fee: Int?
    let currencyCode: String?
    let feeHeadID: Int?

    enum CodingKeys: String, CodingKey {
        case remainFee = "remain_fee"
        case feeHead = "fee_head"
        case collectedFee = "collected_fee"
        case fee
        case currencyCode = "currency_code"
        case feeHeadID = "fee_head_id"
    }
}
