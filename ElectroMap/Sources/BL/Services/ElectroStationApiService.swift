//
//  ElectroStationApiService.swift
//  ElectroMap
//
//  Created by Ромка Бережной on 04.08.2023.
//

import Alamofire
import Foundation


final class ElectroStationApiService {
    private let token: String = "595cf43d-11d6-4b49-9de6-1d8a0361271d"
    init() {}
    
    
    func fetchStations(lat: Double, lon: Double) async throws -> [ElectroStationModel] {
        let parameters: Dictionary<String, Any> = [
            "client": "james",
            "latitude": lat,
            "longitude": lon,
            "distanceunit": "miles",
            "maxresults": 250,
            "distance": 50,
            "verbose": false,
            "key": token
        ]
        
        return try await withUnsafeThrowingContinuation({ continuation in
            AF.request("https://api.openchargemap.io/v3/poi",
                       method: .get,
                       parameters: parameters,
                       encoding: URLEncoding.queryString
            )
            .responseDecodable(of: [ElectroStationModel].self) { response in
                switch response.result {
                case .success(let result):
                    return continuation.resume(returning: result)
                case .failure(let error):
                    return continuation.resume(throwing: error)
                }
            }
        })
    }
}
