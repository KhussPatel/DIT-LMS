//
//  LocationHelper.swift
//  BrittsImperial
//
//  Created by Khushal iOS on 19/08/25.
//


import Foundation
import CoreLocation
import UIKit

class LocationHelper: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationHelper()
    
    private let locationManager = CLLocationManager()
    private var completion: ((Double, Double) -> Void)?
    private weak var presentingVC: UIViewController?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // One-time location fetch
    func getUserLocation(from vc: UIViewController, completion: @escaping (Double, Double) -> Void) {
        self.completion = completion
        self.presentingVC = vc
        
        let status = locationManager.authorizationStatus
        
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            showPermissionAlert(on: vc)
        @unknown default:
            break
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        completion?(Double(String(format: "%.6f", location.coordinate.latitude)) ?? location.coordinate.latitude,
                    Double(String(format: "%.6f", location.coordinate.longitude)) ?? location.coordinate.longitude)

//        completion?(location.coordinate.latitude, location.coordinate.longitude)
        completion = nil
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            if let vc = presentingVC {
                showPermissionAlert(on: vc)
            }
        default:
            break
        }
    }
    
    // MARK: - Permission Alert
    private func showPermissionAlert(on vc: UIViewController) {
        let alert = UIAlertController(
            title: "Location Permission Needed",
            message: "Please enable location services in Settings to mark attendance.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Change Permission", style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            }
        }))
        
        vc.present(alert, animated: true, completion: nil)
    }
}
