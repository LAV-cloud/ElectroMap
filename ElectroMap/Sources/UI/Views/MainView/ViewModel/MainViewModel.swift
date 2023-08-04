//
//  MainViewModel.swift
//  ElectroMap
//
//  Created by Ромка Бережной on 04.08.2023.
//

import Combine
import CoreLocation
import GoogleMaps
import Foundation


@MainActor
final class MainViewModel: ObservableObject {
    @Published private (set) var state: MainViewState = .loading
    private var userLocation: CLLocationCoordinate2D
    private let apiService: ElectroStationApiService
    private let locationService: UserLocationService
    let googleMapVM: GoogleMapViewModel
    
    private var task: Task<Void, Error>? = nil
    private var cancellables: Set<AnyCancellable> = []
    
    
    init(apiService: ElectroStationApiService = .init(),
         locationService: UserLocationService = .init()) {
        self.apiService = apiService
        self.locationService = locationService
        self.userLocation = .mock
        self.googleMapVM = .init(location: self.userLocation, markers: [])
    }
    
    
    func focusOnUser() {
        self.googleMapVM.setCamera(self.userLocation)
    }
    
    
    func didAppear() {
        Task {
            guard await self.locationService.requestPermission() else {
                self.state = .deniedAccess
                return
            }
            self.locationService.startUpdatingLocation()
            let location = await self.fetchLocation()
            await self.fetchStations(lat: location.latitude, lon: location.longitude)
            self.state = .content
            self.googleMapVM.setCamera(location)
        }
    }
    
    
    private func fetchLocation() async -> CLLocationCoordinate2D {
        let location = await self.locationService.fetchLocation()
        self.userLocation = location
        return location
    }
    
    
    private func fetchStations(lat: Double, lon: Double) async {
        do {
            let stations = try await self.apiService.fetchStations(lat: lat, lon: lon)
            let markers = stations.map({ GMSMarker(position: .init(latitude: $0.addressInfo.lat, longitude: $0.addressInfo.lon)) })
            self.googleMapVM.updateMarkers(markers)
        } catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    
    enum MainViewState {
        case content
        case loading
        case deniedAccess
    }
}
