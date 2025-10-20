//
//  VerificationCode.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 20.10.25.
//

struct VerifyCodeRequest: Encodable {
    let email: String
    let code: String
}
