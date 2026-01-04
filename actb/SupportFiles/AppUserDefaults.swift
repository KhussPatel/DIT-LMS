//
//  AppUserDefaults.swift
//  BrittsImperial
//
//  Created by Khuss on 07/10/23.
//

import Foundation

class UserDefaultsHelper {
    // Define keys for your UserDefaults values
    private enum Keys {
        static let isLogin = "isLogin"
        static let studentEmail = "studentEmail"
        static let studentUsername = "studentUserName"
        static let studentPassword = "studentPassword"
        static let studentFMName = "studentFMName"
        static let studentfamilyName = "studentFamilyname"
        static let studentId = "studentId"
        static let coeCode = "coe_code"
        static let STD_ID = "std_id"
        static let CourseCode = "course_code"
        static let CourseName = "course_name"
        static let ProfilePic = "profilePic"
        static let Expiry = "expiry"
        static let DOB = "dob"
        static let MobileNo = "mobileNo"
        static let Campus = "campus"
        static let Proposed_end_date = "proposed_end_date"
        static let Proposed_start_date = "proposed_start_date"
        
        static let stdType = "studentType"//G means Guest student
        // Add more keys as needed
        
        static let isFullView = "isFullView"
        static let isAcceptPP = "isAcceptPP" // Is accept Privacy policy
    }

    // MARK: - Student Email

    static func setIsLogin(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: Keys.isLogin)
    }
    static func getIsLogin() -> Bool? {
        return UserDefaults.standard.bool(forKey: Keys.isLogin)
    }
    
    
    static func setStudentEmail(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.studentEmail)
    }
    static func getStudentEmail() -> String? {
        return UserDefaults.standard.string(forKey: Keys.studentEmail)
    }
    
    static func setStudentUserName(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.studentUsername)
    }
    static func getStudentUserName() -> String? {
        return UserDefaults.standard.string(forKey: Keys.studentUsername)
    }
    
    static func setStudentPassword(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.studentPassword)
    }
    static func getStudentPassword() -> String? {
        return UserDefaults.standard.string(forKey: Keys.studentPassword)
    }

    
    static func setStudentFMName(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.studentFMName)
    }
    static func getStudentFMName() -> String? {
        return UserDefaults.standard.string(forKey: Keys.studentFMName)
    }
    
    
    static func setStudentFamilyName(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.studentfamilyName)
    }
    static func getStudentFamilyName() -> String? {
        return UserDefaults.standard.string(forKey: Keys.studentfamilyName)
    }
    
    static func setCOE_CODE(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.coeCode)
    }
    static func getCOE_CODE() -> String? {
        return UserDefaults.standard.string(forKey: Keys.coeCode)
    }
    
    
    static func setStudentId(_ value: Int) {
        UserDefaults.standard.set(value, forKey: Keys.studentId)
    }
    static func getStudentId() -> Int? {
        return UserDefaults.standard.integer(forKey: Keys.studentId)
    }
    
    
    static func setSTD_ID(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.STD_ID)
    }
    static func getSTDID() -> String? {
        return UserDefaults.standard.string(forKey: Keys.STD_ID)
    }
    
    static func setStudentType(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.stdType)
    }
    static func getStudentType() -> String? {
        return UserDefaults.standard.string(forKey: Keys.stdType)
    }
    
    
    static func setCourseCode(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.CourseCode)
    }
    static func getCourseCode() -> String? {
        return UserDefaults.standard.string(forKey: Keys.CourseCode)
    }
    
    static func setCourseName(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.CourseName)
    }
    static func getCourseName() -> String? {
        return UserDefaults.standard.string(forKey: Keys.CourseName)
    }
    
    static func setProfilePic(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.ProfilePic)
    }
    static func getProfilePic() -> String? {
        return UserDefaults.standard.string(forKey: Keys.ProfilePic)
    }
    
    static func setExpiry(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.Expiry)
    }
    static func getExpiry() -> String? {
        return UserDefaults.standard.string(forKey: Keys.Expiry)
    }
    
    static func setdob(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.DOB)
    }
    static func getdob() -> String? {
        return UserDefaults.standard.string(forKey: Keys.DOB)
    }
    
    static func setMobileNo(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.MobileNo)
    }
    static func getMobileNo() -> String? {
        return UserDefaults.standard.string(forKey: Keys.MobileNo)
    }
    
    static func setCampus(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.Campus)
    }
    static func getCampus() -> String? {
        return UserDefaults.standard.string(forKey: Keys.Campus)
    }
    
    static func setProposed_end_date(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.Proposed_end_date)
    }
    static func getProposed_end_date() -> String? {
        return UserDefaults.standard.string(forKey: Keys.Proposed_end_date)
    }
    
    static func setProposed_start_date(_ value: String) {
        UserDefaults.standard.set(value, forKey: Keys.Proposed_start_date)
    }
    static func getProposed_start_date() -> String? {
        return UserDefaults.standard.string(forKey: Keys.Proposed_start_date)
    }
    
    static func setIsFullView(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: Keys.isFullView)
    }
    static func getIsFullView() -> Bool? {
        return UserDefaults.standard.bool(forKey: Keys.isFullView)
    }
    
    static func setAcceptPP(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: Keys.isAcceptPP)
    }
    static func getAcceptPP() -> Bool? {
        return UserDefaults.standard.bool(forKey: Keys.isAcceptPP)
    }
}
