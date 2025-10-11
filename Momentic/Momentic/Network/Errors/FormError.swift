//
//  FormError.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 11.10.25.
//

enum FormError: Error {
    case missingFields //ex. empty password
    case incorrectEntries //failed validation
}
