//
//  MockAccessTokenStorage.swift
//  MomenticTests
//
//  Created by Yaraslau Merynau on 12.10.25.
//

import Foundation
@testable import Momentic

final class MockAccessTokenStorage: AccessTokenStorageProtocol {
    
    var storedToken: AccessToken?
    var saveCallCount = 0
    var getCallCount = 0
    var deleteCallCount = 0
    var shouldSucceed = true
    
    func save(_ token: AccessToken) -> Bool {
        saveCallCount += 1
        if shouldSucceed {
            storedToken = token
            return true
        }
        return false
    }
    
    func get() -> AccessToken? {
        getCallCount += 1
        return storedToken
    }
    
    func delete() -> Bool {
        deleteCallCount += 1
        if shouldSucceed {
            storedToken = nil
            return true
        }
        return false
    }
}

