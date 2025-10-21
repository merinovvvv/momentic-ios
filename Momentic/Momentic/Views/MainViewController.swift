//
//  MainViewController.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 9.10.25.
//

import UIKit

class MainViewController: UIViewController, FlowController {
    typealias T = Void
    
    var completionHandler: ((T) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}
