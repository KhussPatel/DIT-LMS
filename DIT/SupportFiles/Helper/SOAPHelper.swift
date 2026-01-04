//
//  SOAPHelper.swift
//  BrittsImperial
//
//  Created by Khuss on 06/10/23.
//

import Foundation
import SWXMLHash
import Alamofire
import SwiftyJSON
import SwiftLoader

class APIManagerHandler {
    static let shared = APIManagerHandler()
    
    
    func callSOAPAPI(requestXMLStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        SwiftLoader.show(animated: true)
        
        let url = URL(string:AppConstants().mainURL)
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpBody = requestXMLStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
        xmlRequest.httpMethod = "POST"
        xmlRequest.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        
        print("============================ REQUEST =======================\n\(requestXMLStr)")
        
        AF.request(xmlRequest)
            .responseData { (response) in
                SwiftLoader.hide()
                switch response.result {
                case .success(let data):
                    do {
                        let stringResponse: String = String(data: data, encoding: String.Encoding.utf8) as String? ?? ""
                        
                        let xml = SWXMLHash.XMLHash.parse(stringResponse)
                        let jsonResultString = xml["soap:Envelope"]["soap:Body"]["student_login_by_emailResponse"]["student_login_by_emailResult"].element?.text
                        
                        if let jsonData = jsonResultString?.data(using: .utf8){
                            
                            do {
                                let jsonResult = try JSON(data: jsonData)
                                print("jsonResult ==== \(jsonResult)")
                                // Now you have the JSON result
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                            
                            completion(.success(jsonData))
                        }else {
                            completion(.failure(NSError(domain: "APIManagerHandler", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON data not found in response"])))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func callSOAPAPIforDis_full_view_ac_cal_for_student(requestXMLStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        SwiftLoader.show(animated: true)
        
        let url = URL(string:AppConstants().mainURL)
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpBody = requestXMLStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
        xmlRequest.httpMethod = "POST"
        xmlRequest.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        
        
        
        AF.request(xmlRequest)
            .responseData { (response) in
                SwiftLoader.hide()
                switch response.result {
                case .success(let data):
                    do {
                        let stringResponse: String = String(data: data, encoding: String.Encoding.utf8) as String? ?? ""
                        
                        let xml = SWXMLHash.XMLHash.parse(stringResponse)
                        let jsonResultString = xml["soap:Envelope"]["soap:Body"]["dis_full_view_ac_cal_for_studentResponse"]["dis_full_view_ac_cal_for_studentResult"].element?.text
                        
                        if let jsonData = jsonResultString?.data(using: .utf8){
                            
                            do {
                                let jsonResult = try JSON(data: jsonData)
                                print("jsonResult ==== \(jsonResult)")
                                // Now you have the JSON result
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                            
                            completion(.success(jsonData))
                        }else {
                            completion(.failure(NSError(domain: "APIManagerHandler", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON data not found in response"])))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func callSOAPAPIfor_dis_del_timetable_for_student(requestXMLStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        SwiftLoader.show(animated: true)
        
        let url = URL(string:AppConstants().mainURL)
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpBody = requestXMLStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
        xmlRequest.httpMethod = "POST"
        xmlRequest.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        
        
        
        AF.request(xmlRequest)
            .responseData { (response) in
                SwiftLoader.hide()
                switch response.result {
                case .success(let data):
                    do {
                        let stringResponse: String = String(data: data, encoding: String.Encoding.utf8) as String? ?? ""
                        
                        let xml = SWXMLHash.XMLHash.parse(stringResponse)
                        let jsonResultString = xml["soap:Envelope"]["soap:Body"]["dis_del_timetable_for_studentResponse"]["dis_del_timetable_for_studentResult"].element?.text
                        
                        if let jsonData = jsonResultString?.data(using: .utf8){
                            
                            do {
                                let jsonResult = try JSON(data: jsonData)
                                print("jsonResult ==== \(jsonResult)")
                                // Now you have the JSON result
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                            
                            completion(.success(jsonData))
                        }else {
                            completion(.failure(NSError(domain: "APIManagerHandler", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON data not found in response"])))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    
    func callSOAPAPIforDis_unit_video(requestXMLStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        SwiftLoader.show(animated: true)
        
        let url = URL(string:AppConstants().mainURL)
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpBody = requestXMLStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
        xmlRequest.httpMethod = "POST"
        xmlRequest.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        
        
        
        AF.request(xmlRequest)
            .responseData { (response) in
                SwiftLoader.hide()
                switch response.result {
                case .success(let data):
                    do {
                        let stringResponse: String = String(data: data, encoding: String.Encoding.utf8) as String? ?? ""
                        
                        let xml = SWXMLHash.XMLHash.parse(stringResponse)
                        let jsonResultString = xml["soap:Envelope"]["soap:Body"]["dis_unit_videoResponse"]["dis_unit_videoResult"].element?.text
                        
                        if let jsonData = jsonResultString?.data(using: .utf8){
                            
                            do {
                                let jsonResult = try JSON(data: jsonData)
                                print("jsonResult ==== \(jsonResult)")
                                // Now you have the JSON result
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                            
                            completion(.success(jsonData))
                        }else {
                            completion(.failure(NSError(domain: "APIManagerHandler", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON data not found in response"])))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func callSOAPAPIforDis_assignment(requestXMLStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        SwiftLoader.show(animated: true)
        
        let url = URL(string:AppConstants().mainURL)
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpBody = requestXMLStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
        xmlRequest.httpMethod = "POST"
        xmlRequest.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        
        AF.request(xmlRequest)
            .responseData { (response) in
                SwiftLoader.hide()
                switch response.result {
                case .success(let data):
                    do {
                        let stringResponse: String = String(data: data, encoding: String.Encoding.utf8) as String? ?? ""
                        
                        let xml = SWXMLHash.XMLHash.parse(stringResponse)
                        let jsonResultString = xml["soap:Envelope"]["soap:Body"]["dis_del_timetable_for_studentResponse"]["dis_del_timetable_for_studentResult"].element?.text
                        
                        if let jsonData = jsonResultString?.data(using: .utf8){
                            
                            do {
                                let jsonResult = try JSON(data: jsonData)
                                print("jsonResult ==== \(jsonResult)")
                                // Now you have the JSON result
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                            
                            completion(.success(jsonData))
                        }else {
                            completion(.failure(NSError(domain: "APIManagerHandler", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON data not found in response"])))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func callSOAPAPIfor_dis_assignment(requestXMLStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        SwiftLoader.show(animated: true)
        
        let url = URL(string:AppConstants().mainURL)
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpBody = requestXMLStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
        xmlRequest.httpMethod = "POST"
        xmlRequest.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        
        
        
        AF.request(xmlRequest)
            .responseData { (response) in
                SwiftLoader.hide()
                switch response.result {
                case .success(let data):
                    do {
                        let stringResponse: String = String(data: data, encoding: String.Encoding.utf8) as String? ?? ""
                        
                        let xml = SWXMLHash.XMLHash.parse(stringResponse)
                        let jsonResultString = xml["soap:Envelope"]["soap:Body"]["dis_assignmentResponse"]["dis_assignmentResult"].element?.text
                        
                        if let jsonData = jsonResultString?.data(using: .utf8){
                            
                            do {
                                let jsonResult = try JSON(data: jsonData)
                                print("jsonResult ==== \(jsonResult)")
                                // Now you have the JSON result
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                            
                            completion(.success(jsonData))
                        }else {
                            completion(.failure(NSError(domain: "APIManagerHandler", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON data not found in response"])))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func callSOAPAPIfor_dis_course_resources(requestXMLStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        SwiftLoader.show(animated: true)
        
        let url = URL(string:AppConstants().mainURL)
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpBody = requestXMLStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
        xmlRequest.httpMethod = "POST"
        xmlRequest.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        
        
        
        AF.request(xmlRequest)
            .responseData { (response) in
                SwiftLoader.hide()
                switch response.result {
                case .success(let data):
                    do {
                        let stringResponse: String = String(data: data, encoding: String.Encoding.utf8) as String? ?? ""
                        
                        let xml = SWXMLHash.XMLHash.parse(stringResponse)
                        let jsonResultString = xml["soap:Envelope"]["soap:Body"]["dis_course_resourcesResponse"]["dis_course_resourcesResult"].element?.text
                        
                        if let jsonData = jsonResultString?.data(using: .utf8){
                            
                            do {
                                let jsonResult = try JSON(data: jsonData)
                                print("jsonResult ==== \(jsonResult)")
                                // Now you have the JSON result
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                            
                            completion(.success(jsonData))
                        }else {
                            completion(.failure(NSError(domain: "APIManagerHandler", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON data not found in response"])))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func callSOAPAPI_Display_student_payment_history(requestXMLStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        SwiftLoader.show(animated: true)
        
        let url = URL(string:AppConstants().mainURL)
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpBody = requestXMLStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
        xmlRequest.httpMethod = "POST"
        xmlRequest.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        
        
        
        AF.request(xmlRequest)
            .responseData { (response) in
                SwiftLoader.hide()
                switch response.result {
                case .success(let data):
                    do {
                        let stringResponse: String = String(data: data, encoding: String.Encoding.utf8) as String? ?? ""
                        
                        let xml = SWXMLHash.XMLHash.parse(stringResponse)
                        let jsonResultString = xml["soap:Envelope"]["soap:Body"]["display_student_payment_historyResponse"]["display_student_payment_historyResult"].element?.text
                        
                        if let jsonData = jsonResultString?.data(using: .utf8){
                            
                            do {
                                let jsonResult = try JSON(data: jsonData)
                                print("jsonResult ==== \(jsonResult)")
                                // Now you have the JSON result
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                            
                            completion(.success(jsonData))
                        }else {
                            completion(.failure(NSError(domain: "APIManagerHandler", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON data not found in response"])))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func callSOAPAPI_ins_guest_student(requestXMLStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        SwiftLoader.show(animated: true)
        
        let url = URL(string:AppConstants().mainURL)
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpBody = requestXMLStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
        xmlRequest.httpMethod = "POST"
        xmlRequest.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        
        
        
        AF.request(xmlRequest)
            .responseData { (response) in
                SwiftLoader.hide()
                switch response.result {
                case .success(let data):
                    do {
                        let stringResponse: String = String(data: data, encoding: String.Encoding.utf8) as String? ?? ""
                        
                        let xml = SWXMLHash.XMLHash.parse(stringResponse)
                        let jsonResultString = xml["soap:Envelope"]["soap:Body"]["ins_guest_studentResponse"]["ins_guest_studentResult"].element?.text
                        
                        if let jsonData = jsonResultString?.data(using: .utf8){
                            
                            do {
                                let jsonResult = try JSON(data: jsonData)
                                print("jsonResult ==== \(jsonResult)")
                                // Now you have the JSON result
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                            
                            completion(.success(jsonData))
                        }else {
                            completion(.failure(NSError(domain: "APIManagerHandler", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON data not found in response"])))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func callSOAPAPI_dis_notice_for_student_for_app(requestXMLStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        SwiftLoader.show(animated: true)
        
        let url = URL(string:AppConstants().mainURL)
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpBody = requestXMLStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
        xmlRequest.httpMethod = "POST"
        xmlRequest.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        
        
        
        AF.request(xmlRequest)
            .responseData { (response) in
                SwiftLoader.hide()
                switch response.result {
                case .success(let data):
                    do {
                        let stringResponse: String = String(data: data, encoding: String.Encoding.utf8) as String? ?? ""
                        
                        let xml = SWXMLHash.XMLHash.parse(stringResponse)
                        let jsonResultString = xml["soap:Envelope"]["soap:Body"]["dis_notice_for_student_for_appResponse"]["dis_notice_for_student_for_appResult"].element?.text
                        
                        if let jsonData = jsonResultString?.data(using: .utf8){
                            
                            do {
                                let jsonResult = try JSON(data: jsonData)
                                print("jsonResult ==== \(jsonResult)")
                                // Now you have the JSON result
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                            
                            completion(.success(jsonData))
                        }else {
                            completion(.failure(NSError(domain: "APIManagerHandler", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON data not found in response"])))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func callSOAPAPI_dis_student_wise_cap_chart(requestXMLStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        SwiftLoader.show(animated: true)
        
        print("====\(requestXMLStr)")
        
        let url = URL(string:AppConstants().mainURL)
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpBody = requestXMLStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
        xmlRequest.httpMethod = "POST"
        xmlRequest.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        
        
        
        AF.request(xmlRequest)
            .responseData { (response) in
                SwiftLoader.hide()
                switch response.result {
                case .success(let data):
                    do {
                        let stringResponse: String = String(data: data, encoding: String.Encoding.utf8) as String? ?? ""
                        
                        let xml = SWXMLHash.XMLHash.parse(stringResponse)
                        let jsonResultString = xml["soap:Envelope"]["soap:Body"]["dis_student_wise_cap_chartResponse"]["dis_student_wise_cap_chartResult"].element?.text
                        
                        if let jsonData = jsonResultString?.data(using: .utf8){
                            
                            do {
                                let jsonResult = try JSON(data: jsonData)
                                print("jsonResult ==== \(jsonResult)")
                                // Now you have the JSON result
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                            
                            completion(.success(jsonData))
                        }else {
                            completion(.failure(NSError(domain: "APIManagerHandler", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON data not found in response"])))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func callSOAPAPI_dis_post_for_student_for_app(requestXMLStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        SwiftLoader.show(animated: true)
        
        print("====\(requestXMLStr)")
        
        let url = URL(string:AppConstants().mainURL)
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpBody = requestXMLStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
        xmlRequest.httpMethod = "POST"
        xmlRequest.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        
        
        
        AF.request(xmlRequest)
            .responseData { (response) in
                SwiftLoader.hide()
                switch response.result {
                case .success(let data):
                    do {
                        let stringResponse: String = String(data: data, encoding: String.Encoding.utf8) as String? ?? ""
                        
                        let xml = SWXMLHash.XMLHash.parse(stringResponse)
                        let jsonResultString = xml["soap:Envelope"]["soap:Body"]["dis_post_for_student_for_appResponse"]["dis_post_for_student_for_appResult"].element?.text
                        
                        if let jsonData = jsonResultString?.data(using: .utf8){
                            
                            do {
                                let jsonResult = try JSON(data: jsonData)
                                print("jsonResult ==== \(jsonResult)")
                                // Now you have the JSON result
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                            
                            completion(.success(jsonData))
                        }else {
                            completion(.failure(NSError(domain: "APIManagerHandler", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON data not found in response"])))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func callSOAPAPI_change_std_pass(requestXMLStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        SwiftLoader.show(animated: true)
        
        print("====\(requestXMLStr)")
        
        let url = URL(string:AppConstants().mainURL)
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpBody = requestXMLStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
        xmlRequest.httpMethod = "POST"
        xmlRequest.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        
        
        
        AF.request(xmlRequest)
            .responseData { (response) in
                SwiftLoader.hide()
                switch response.result {
                case .success(let data):
                    do {
                        let stringResponse: String = String(data: data, encoding: String.Encoding.utf8) as String? ?? ""
                        
                        let xml = SWXMLHash.XMLHash.parse(stringResponse)
                        let jsonResultString = xml["soap:Envelope"]["soap:Body"]["change_std_passResponse"]["change_std_passResult"].element?.text
                        
                        if let jsonData = jsonResultString?.data(using: .utf8){
                            
                            do {
                                let jsonResult = try JSON(data: jsonData)
                                print("jsonResult ==== \(jsonResult)")
                                // Now you have the JSON result
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                            
                            completion(.success(jsonData))
                        }else {
                            completion(.failure(NSError(domain: "APIManagerHandler", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON data not found in response"])))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    //dis_std_dashboard
    
    func callSOAPAPI_dis_std_dashboard(requestXMLStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        SwiftLoader.show(animated: true)
        
        print("====\(requestXMLStr)")
        
        let url = URL(string:AppConstants().mainURL)
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpBody = requestXMLStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
        xmlRequest.httpMethod = "POST"
        xmlRequest.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        
        
        
        AF.request(xmlRequest)
            .responseData { (response) in
                SwiftLoader.hide()
                switch response.result {
                case .success(let data):
                    do {
                        let stringResponse: String = String(data: data, encoding: String.Encoding.utf8) as String? ?? ""
                        
                        let xml = SWXMLHash.XMLHash.parse(stringResponse)
                        let jsonResultString = xml["soap:Envelope"]["soap:Body"]["dis_std_dashboardResponse"]["dis_std_dashboardResult"].element?.text
                        
                        if let jsonData = jsonResultString?.data(using: .utf8){
                            
                            do {
                                let jsonResult = try JSON(data: jsonData)
                                print("jsonResult ==== \(jsonResult)")
                                // Now you have the JSON result
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                            
                            completion(.success(jsonData))
                        }else {
                            completion(.failure(NSError(domain: "APIManagerHandler", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON data not found in response"])))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func callSOAPAPI_std_profile(requestXMLStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        SwiftLoader.show(animated: true)
        
        print("====\(requestXMLStr)")
        
        let url = URL(string:AppConstants().mainURL)
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpBody = requestXMLStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
        xmlRequest.httpMethod = "POST"
        xmlRequest.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        
        
        
        AF.request(xmlRequest)
            .responseData { (response) in
                SwiftLoader.hide()
                switch response.result {
                case .success(let data):
                    do {
                        let stringResponse: String = String(data: data, encoding: String.Encoding.utf8) as String? ?? ""
                        
                        let xml = SWXMLHash.XMLHash.parse(stringResponse)
                        let jsonResultString = xml["soap:Envelope"]["soap:Body"]["std_profileResponse"]["std_profileResult"].element?.text
                        
                        if let jsonData = jsonResultString?.data(using: .utf8){
                            
                            do {
                                let jsonResult = try JSON(data: jsonData)
                                print("jsonResult ==== \(jsonResult)")
                                // Now you have the JSON result
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                            
                            completion(.success(jsonData))
                        }else {
                            completion(.failure(NSError(domain: "APIManagerHandler", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON data not found in response"])))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func callSOAPAPI_std_profile_Update(requestXMLStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        //SwiftLoader.show(animated: true)
        
        print("====\(requestXMLStr)")
        
        let url = URL(string:AppConstants().mainURL)
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpBody = requestXMLStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
        xmlRequest.httpMethod = "POST"
        xmlRequest.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        
        
        
        AF.request(xmlRequest)
            .responseData { (response) in
                //SwiftLoader.hide()
                switch response.result {
                case .success(let data):
                    do {
                        let stringResponse: String = String(data: data, encoding: String.Encoding.utf8) as String? ?? ""
                        
                        let xml = SWXMLHash.XMLHash.parse(stringResponse)
                        let jsonResultString = xml["soap:Envelope"]["soap:Body"]["upd_std_profileResponse"]["upd_std_profileResult"].element?.text
                        
                        if let jsonData = jsonResultString?.data(using: .utf8){
                            
                            do {
                                let jsonResult = try JSON(data: jsonData)
                                print("jsonResult ==== \(jsonResult)")
                                // Now you have the JSON result
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                            
                            completion(.success(jsonData))
                        }else {
                            completion(.failure(NSError(domain: "APIManagerHandler", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON data not found in response"])))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func callSOAPAPI_std_IcardQR(requestXMLStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        SwiftLoader.show(animated: true)
        
        print("====\(requestXMLStr)")
        
        let url = URL(string:AppConstants().mainURL)
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpBody = requestXMLStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
        xmlRequest.httpMethod = "POST"
        xmlRequest.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        
        
        
        AF.request(xmlRequest)
            .responseData { (response) in
                SwiftLoader.hide()
                switch response.result {
                case .success(let data):
                    do {
                        let stringResponse: String = String(data: data, encoding: String.Encoding.utf8) as String? ?? ""
                        
                        let xml = SWXMLHash.XMLHash.parse(stringResponse)
                        let jsonResultString = xml["soap:Envelope"]["soap:Body"]["get_student_idcard_qrResponse"]["get_student_idcard_qrResult"].element?.text
                        
                        if let jsonData = jsonResultString?.data(using: .utf8){
                            
                            do {
                                let jsonResult = try JSON(data: jsonData)
                                print("jsonResult ==== \(jsonResult)")
                                // Now you have the JSON result
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                            
                            completion(.success(jsonData))
                        }else {
                            completion(.failure(NSError(domain: "APIManagerHandler", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON data not found in response"])))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func callSOAPAPI_ins_studet_qr_attendance(requestXMLStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        SwiftLoader.show(animated: true)
        
        print("====\(requestXMLStr)")
        
        let url = URL(string:AppConstants().mainURL)
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpBody = requestXMLStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
        xmlRequest.httpMethod = "POST"
        xmlRequest.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        
        
        
        AF.request(xmlRequest)
            .responseData { (response) in
                SwiftLoader.hide()
                switch response.result {
                case .success(let data):
                    do {
                        let stringResponse: String = String(data: data, encoding: String.Encoding.utf8) as String? ?? ""
                        
                        let xml = SWXMLHash.XMLHash.parse(stringResponse)
                        let jsonResultString = xml["soap:Envelope"]["soap:Body"]["ins_studet_qr_attendanceResponse"]["ins_studet_qr_attendanceResult"].element?.text
                        
                        if let jsonData = jsonResultString?.data(using: .utf8){
                            
                            do {
                                let jsonResult = try JSON(data: jsonData)
                                print("jsonResult ==== \(jsonResult)")
                                // Now you have the JSON result
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                            
                            completion(.success(jsonData))
                        }else {
                            completion(.failure(NSError(domain: "APIManagerHandler", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON data not found in response"])))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func callSOAPAPI_display_privacy_policy(requestXMLStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        SwiftLoader.show(animated: true)
        
        print("====\(requestXMLStr)")
        
        let url = URL(string:AppConstants().mainURL)
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpBody = requestXMLStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
        xmlRequest.httpMethod = "POST"
        xmlRequest.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        
        
        
        AF.request(xmlRequest)
            .responseData { (response) in
                SwiftLoader.hide()
                switch response.result {
                case .success(let data):
                    do {
                        let stringResponse: String = String(data: data, encoding: String.Encoding.utf8) as String? ?? ""
                        
                        let xml = SWXMLHash.XMLHash.parse(stringResponse)
                        let jsonResultString = xml["soap:Envelope"]["soap:Body"]["display_privacy_policyResponse"]["display_privacy_policyResult"].element?.text
                        
                        if let jsonData = jsonResultString?.data(using: .utf8){
                            
                            do {
                                let jsonResult = try JSON(data: jsonData)
                                print("jsonResult ==== \(jsonResult)")
                                // Now you have the JSON result
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                            
                            completion(.success(jsonData))
                        }else {
                            completion(.failure(NSError(domain: "APIManagerHandler", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON data not found in response"])))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func callSOAPAPI_Forgot_password_email(requestXMLStr: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        SwiftLoader.show(animated: true)
        
        print("====\(requestXMLStr)")
        
        let url = URL(string:AppConstants().mainURL)
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpBody = requestXMLStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
        xmlRequest.httpMethod = "POST"
        xmlRequest.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        
        
        
        AF.request(xmlRequest)
            .responseData { (response) in
                SwiftLoader.hide()
                switch response.result {
                case .success(let data):
                    do {
                        let stringResponse: String = String(data: data, encoding: String.Encoding.utf8) as String? ?? ""
                        
                        let xml = SWXMLHash.XMLHash.parse(stringResponse)
                        let jsonResultString = xml["soap:Envelope"]["soap:Body"]["send_email_for_forgot_passwordResponse"]["send_email_for_forgot_passwordResult"].element?.text
                        
                        if let jsonData = jsonResultString?.data(using: .utf8){
                            
                            do {
                                let jsonResult = try JSON(data: jsonData)
                                print("jsonResult ==== \(jsonResult)")
                                // Now you have the JSON result
                            } catch {
                                print("Error parsing JSON: \(error)")
                            }
                            
                            completion(.success(jsonData))
                        }else {
                            completion(.failure(NSError(domain: "APIManagerHandler", code: 0, userInfo: [NSLocalizedDescriptionKey: "JSON data not found in response"])))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
