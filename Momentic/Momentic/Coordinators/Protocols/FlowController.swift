//
//  FlowController.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 7.10.25.
//

protocol FlowController {
    
    associatedtype T
    var completionHandler: ((T) -> ())? { get set }
}
