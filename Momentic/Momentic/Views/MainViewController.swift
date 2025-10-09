//
//  MainViewController.swift
//  Momentic
//
//  Created by Yaraslau Merynau on 9.10.25.
//

import UIKit

class MainViewController: UIViewController, FlowController {
    var completionHandler: ((()) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}
