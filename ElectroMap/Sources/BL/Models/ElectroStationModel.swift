//
//  ElectroStationPinModel.swift
//  ElectroMap
//
//  Created by Ромка Бережной on 04.08.2023.
//

import Foundation


//  MARK: - Model
struct ElectroStationModel {
    let id: Int
    let uuid: String
    let addressInfo: AddressInfo

    struct AddressInfo {
        let lat, lon: Double
    }
}


//  MARK: - Extension Model For Codable
extension ElectroStationModel: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case uuid = "UUID"
        case addressInfo = "AddressInfo"
    }


    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let uuid = try container.decode(String.self, forKey: .uuid)
        let addressInfo = try container.decode(AddressInfo.self, forKey: .addressInfo)

        self.init(id: id, uuid: uuid, addressInfo: addressInfo)
    }


    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.uuid, forKey: .uuid)
        try container.encode(self.addressInfo, forKey: .addressInfo)
    }
}


//  MARK: - Extension Model.AddressInfo For Codable
extension ElectroStationModel.AddressInfo: Codable {
    enum CodingKeys: String, CodingKey {
        case lat = "Latitude"
        case lon = "Longitude"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let lat = try container.decode(Double.self, forKey: .lat)
        let lon = try container.decode(Double.self, forKey: .lon)
        
        self.init(lat: lat, lon: lon)
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.lat, forKey: .lat)
        try container.encode(self.lon, forKey: .lon)
    }
}
