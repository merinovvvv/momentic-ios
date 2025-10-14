//
//  NetworkRoutes.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 12.10.25.
//

import Foundation

enum NetworkRoutes {
    
    private static let baseURL: String = "http://127.0.0.1:8080/"
    
    case register
    case login
    //case refreshToken
    //case verifyCode
    //case fetchSecureData
    
    var url: URL? {
        var path: String
        switch self {
        case .register:
            path = NetworkRoutes.baseURL + "auth/register/"
        case .login:
            path = NetworkRoutes.baseURL + "auth/login/"
//        case .fetchSecureData:
//            path = NetworkRoutes.baseURL + "login_data/"
        }
        
        return URL(string: path)
    }
    
    var httpMethod: HTTPMethod {
        switch self {
            
        case .register, .login: .post
        //case .fetchSecureData: .get
            
        }
    }
}
