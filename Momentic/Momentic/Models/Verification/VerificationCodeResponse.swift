//
//  VerificationResponse.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 20.10.25.
//

struct VerificationResponse: Codable {
    let success: Bool
    let message: String
    let token: AccessToken?
}
