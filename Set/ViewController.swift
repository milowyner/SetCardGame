//
//  ViewController.swift
//  Set
//
//  Created by Milo Wyner on 1/28/19.
//  Copyright © 2019 Milo Wyner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var cardButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in cardButtons {
            button.layer.cornerRadius = 8.0
            button.layer.shadowOpacity = 0.2
            button.layer.shadowRadius = 6.0
            button.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        }
    }


}

