//
//  AccessToken.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 11.10.25.
//

struct AccessToken: Codable {
    
    var accessToken: String
    var refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access"
        case refreshToken = "refresh"
    }
}
