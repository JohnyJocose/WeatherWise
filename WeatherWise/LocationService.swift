//
//  LocationService.swift
//  WeatherWise
//
//  Created by Johnathan Huijon on 10/30/23.
//

import Foundation
import CoreLocation

class LocationService: NSObject {
    
    static let shared = LocationService()
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        return manager
    }()
    
    
    private override init() {
        super.init()
        self.requestPermissionToAccessLocation()
    }
    
    func requestPermissionToAccessLocation() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    func updateUsersLocation() {
        locationManager.startUpdatingLocation()
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {

        case .authorizedAlways:
            manager.startUpdatingLocation()
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            print("error with location auth change")
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            
            //print(location)
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}






//class LocationService: NSObject {
//    
//    static let shared = LocationService()
//    
//    var completion: ((CLLocation) -> Void)?
//    
//    
//    let locationManager = CLLocationManager()
//    public func getUsersLocation(completion: @escaping ((CLLocation) -> Void)) {
//        self.completion = completion
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.delegate = self
//        locationManager.startUpdatingLocation()
//    }
//    
//    
//}
//
//extension LocationService: CLLocationManagerDelegate {
//
//
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else {
//            return
//        }
//        completion?(location)
//        manager.stopUpdatingLocation()
//        
//        
//    }
//
//}
