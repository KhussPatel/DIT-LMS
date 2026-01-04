//
//  AttendanceHelper.swift
//  BrittsImperial
//
//  Created by Khushal iOS on 19/08/25.
//

import CoreLocation

class AttendanceHelper {
    
    /// Check if user is inside attendance area
    /// - Parameters:
    ///   - userLat: User latitude
    ///   - userLong: User longitude
    ///   - qrLat: QR code latitude (fixed)
    ///   - qrLong: QR code longitude (fixed)
    ///   - radius: Allowed distance in meters (default 50m)
    /// - Returns: Bool (true = inside area, false = outside)
    static func isUserInsideAttendanceArea(userLat: Double,
                                           userLong: Double,
                                           qrLat: Double,
                                           qrLong: Double,
                                           radius: Double = 50.0) -> Bool {
        
        let userCoordinate = CLLocationCoordinate2D(latitude: userLat, longitude: userLong)
        let qrCoordinate   = CLLocationCoordinate2D(latitude: qrLat, longitude: qrLong)
        
        let region = CLCircularRegion(center: qrCoordinate,
                                      radius: radius,
                                      identifier: "AttendanceArea")
        
        return region.contains(userCoordinate)
    }
    
    /// Optional: Get exact distance in meters (rounded to 2 decimals)
    static func calculateDistance(userLat: Double,
                                  userLong: Double,
                                  qrLat: Double,
                                  qrLong: Double) -> Double {
        
        let userLocation = CLLocation(latitude: userLat, longitude: userLong)
        let qrLocation   = CLLocation(latitude: qrLat, longitude: qrLong)
        
        let distance = userLocation.distance(from: qrLocation) // meters
        return Double(String(format: "%.2f", distance)) ?? distance
    }
}
