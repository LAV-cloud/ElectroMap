//
//  ElectroMapApp.swift
//  ElectroMap
//
//  Created by Ромка Бережной on 03.08.2023.
//

import GoogleMaps
import SwiftUI

@main
struct ElectroMapApp: App {
    
    init() {
        GMSServices.provideAPIKey("AIzaSyBg-PCvyOxHbWnAFUTZnYyS-tk_n_83l34")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
