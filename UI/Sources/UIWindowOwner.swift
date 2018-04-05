//
//  UIWindowOwner.swift
//  UI
//
//  Created by Bohdan Orlov on 05/04/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit

public protocol UIWindowOwner: AnyObject {
    var windows: [String: UIWindow] { get set }
}
