//
//  MainView.swift
//  ElectroMap
//
//  Created by Ромка Бережной on 04.08.2023.
//

import SwiftUI


struct MainView: View {
    @StateObject private var vm: MainViewModel = .init()
    
    var body: some View {
        GoogleMapView(vm: self.vm.googleMapVM)
            .onAppear { self.vm.didAppear() }
            .overlay {
                switch self.vm.state {
                case .content:
                    MapControllerOverlay()
                case .deniedAccess:
                    DeniedOverlay()
                case .loading:
                    LoadingOverlay()
                }
            }
            .ignoresSafeArea(.all)
    }
    
    
    @ViewBuilder
    private func MapControllerOverlay() -> some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button(action: {
                    self.vm.focusOnUser()
                }) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .clipShape(Circle())
                        .padding(.bottom)
                }
            }
        }
        .padding()
    }
    
    
    @ViewBuilder
    private func DeniedOverlay() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                Image(systemName: "location.slash.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .clipShape(Circle())
                    .padding(.bottom)
            }
        }
        .padding()
    }
    
    
    @ViewBuilder
    private func LoadingOverlay() -> some View {
        ZStack {
            Color.black.opacity(0.2)
            
            ProgressView()
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
