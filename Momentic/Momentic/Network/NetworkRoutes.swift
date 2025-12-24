//
//  NetworkRoutes.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 12.10.25.
//

import Foundation

enum NetworkRoutes {
    
    private static let baseURL: String = "https://momentic.lol/"
    
    case register
    case login
    case verify
    case resendVerify
    case updateProfile
    case updateAvatar
    case logs
    case fetchComments(videoID: String)
    case postComment(videoID: String)
    
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
        case .logs:
            path = NetworkRoutes.baseURL + "logs/"
        case .fetchComments(let videoID):
            path = NetworkRoutes.baseURL + "videos/\(videoID)/comments/"
        case .postComment(let videoID):
            path = NetworkRoutes.baseURL + "videos/\(videoID)/comments/"
        }
        
        return URL(string: path)
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .register, .login, .verify, .resendVerify, .logs:
            return .post
        case .updateProfile, .updateAvatar:
            return .patch
        case .fetchComments:
            return .get
        case .postComment:
            return .post
        }
    }
}
