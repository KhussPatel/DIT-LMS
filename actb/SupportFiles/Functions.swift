//
//  Functions.swift
//  BrittsImperial
//
//  Created by Khuss on 27/09/23.
//

import Foundation
import UIKit

extension Date {

 static func getCurrentDate() -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "dd"

        return dateFormatter.string(from: Date())

    }
}
