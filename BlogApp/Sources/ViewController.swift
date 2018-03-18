//
//  ViewController.swift
//  BlogApp
//
//  Created by Bohdan Orlov on 17/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import UIKit
import Domain
import UI

class ViewController: UIViewController {

    override func viewDidLoad() {
        _ = Domain()
        _ = UI()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

