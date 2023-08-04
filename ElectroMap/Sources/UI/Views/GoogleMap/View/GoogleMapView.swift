//
//  GoogleMapView.swift
//  ElectroMap
//
//  Created by Ромка Бережной on 03.08.2023.
//

import SwiftUI
import GoogleMaps


struct GoogleMapView: UIViewRepresentable {
    @ObservedObject private var vm: GoogleMapViewModel
    
    
    init(vm: GoogleMapViewModel) {
        self._vm = ObservedObject(wrappedValue: vm)
    }
    
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: self.vm.camera)
        self.vm.setClusters(view: mapView)
        mapView.isMyLocationEnabled = true
        
        return mapView
    }
    
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        uiView.clear()
        self.vm.setClusters(view: uiView)

        guard self.vm.cameraChanging else {
            return
        }
        uiView.animate(to: self.vm.camera)
        self.vm.cameraChanged()
    }
}


struct GoogleMapView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleMapView(vm: .init(location: .mock))
    }
}


//  MARK: - Static mock for Coordinate
extension CLLocationCoordinate2D {
    static let mock: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0)
}

