//
//  NetworkRoutes.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 12.10.25.
//

import Foundation

enum NetworkRoutes {
    
    private static let baseURL: String = "http://127.0.0.1:8080/api/"
    
    case register
    case login
    case verify
    case resendVerify
    case updateProfile
    case updateAvatar
    
    var url: URL? {
        var path: String
        switch self {
        case .register:
            path = NetworkRoutes.baseURL + "auth/register/"
        case .login:
            path = NetworkRoutes.baseURL + "auth/login/"
        case .verify:
            path = NetworkRoutes.baseURL + "auth/verify-code/"
        case .resendVerify:
            path = NetworkRoutes.baseURL + "auth/resend-verify-code/"
        case .updateProfile:
            path = NetworkRoutes.baseURL + "user/profile/"
        case .updateAvatar:
            path = NetworkRoutes.baseURL + "user/avatar/"
        }
        
        return URL(string: path)
    }
    
    var httpMethod: HTTPMethod {
        switch self {
            
        case .register, .login, .verify, .resendVerify: .post
        case .updateProfile, .updateAvatar: .patch
            
        }
    }
}
