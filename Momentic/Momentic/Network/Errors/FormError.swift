//
//  FormError.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 11.10.25.
//

import Foundation

enum FormError: LocalizedError {
//    case missingFields //ex. empty password
//    case incorrectEntries //failed validation
    
    case invalidEmail
    case invalidPassword
    
    case invalidName
    case invalidSurname
    case invalidBio
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return NSLocalizedString("email_error_text", comment: "Wrong email format")
        case .invalidPassword:
            return NSLocalizedString("password_error_text", comment: "Wrong password format")
        case .invalidName:
            return NSLocalizedString("name_error_text", comment: "Wrong name format")
        case .invalidSurname:
            return NSLocalizedString("surname_error_text", comment: "Wrong surname format")
        case .invalidBio:
            return NSLocalizedString("bio_error_text", comment: "Wrong bio format")
        }
    }
}
