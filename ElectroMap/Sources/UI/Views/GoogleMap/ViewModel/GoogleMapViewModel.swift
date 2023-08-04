//
//  GoogleMapViewModel.swift
//  ElectroMap
//
//  Created by Ромка Бережной on 03.08.2023.
//

import CoreLocation
import GoogleMaps
import Foundation
import GoogleMapsUtils


@MainActor
final class GoogleMapViewModel: ObservableObject {
    private (set) var zoom: Float
    private (set) var cameraChanging: Bool = false
    @Published private (set) var camera: GMSCameraPosition
    @Published private (set) var markers: [GMSMarker]
    
    
    private var clusterManager: GMUClusterManager?
    
    
    init(location: CLLocationCoordinate2D, zoom: Float = 15, markers: [GMSMarker] = []) {
        self.zoom = zoom
        self.camera = .camera(
            withLatitude: location.latitude,
            longitude: location.longitude,
            zoom: zoom)
        self.markers = markers
    }
    
    
    func updateMarkers(_ markers: [GMSMarker]) {
        self.markers = markers
    }
    
    
    func setCamera(_ location: CLLocationCoordinate2D) {
        self.cameraChanging = true
        self.camera = .camera(
            withLatitude: location.latitude,
            longitude: location.longitude,
            zoom: zoom)
    }
    
    
    func cameraChanged() {
        self.cameraChanging = false
    }
    
    
    func setClusters(view: GMSMapView) {
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: view, clusterIconGenerator: iconGenerator)
        clusterManager = GMUClusterManager(map: view, algorithm: algorithm, renderer: renderer)
        
        markers.forEach { clusterManager?.add($0) }
        clusterManager?.cluster()
    }
}
