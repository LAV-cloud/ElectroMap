//
//  UserLocationService.swift
//  ElectroMap
//
//  Created by Ромка Бережной on 04.08.2023.
//

import CoreLocation
import Combine
import Foundation


final class UserLocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let locationSubject = PassthroughSubject<CLLocation, Never>()
    private let authrorizationSubject = PassthroughSubject<CLAuthorizationStatus, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    

    func requestPermission() async -> Bool {
        await withUnsafeContinuation({ continuation in
            self.authrorizationSubject
                .first()
                .map({
                    switch $0 {
                    case .authorizedAlways, .authorizedWhenInUse: return true
                    default: return false
                    }
                })
                .sink { hasAuthorization in
                    return continuation.resume(returning: hasAuthorization)
                }
                .store(in: &cancellables)
            
            DispatchQueue.main.async {
                switch self.locationManager.authorizationStatus {
                case .notDetermined:
                    self.requestPermissionWhenInUse()
                default:
                    self.authrorizationSubject.send(self.locationManager.authorizationStatus)
                }
            }
        })
    }
    
    
    private func requestPermissionWhenInUse() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    

    func startUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
    
    func fetchLocation() async -> CLLocationCoordinate2D {
        await withUnsafeContinuation({ continuation in
            self.locationSubject
                .first()
                .map({ $0.coordinate })
                .sink { coordinate in
                    return continuation.resume(returning: coordinate)
                }
                .store(in: &cancellables)
        })
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.locationSubject.send(location)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authrorizationSubject.send(status)
    }
}
