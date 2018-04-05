//
//  ViewController.swift
//  Architecture
//
//  Created by Bohdan Orlov on 27/02/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import UIKit

public class RootViewController: UIViewController {
    public var didAppear: (() -> Void)?
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.didAppear?()
        self.didAppear = nil
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

