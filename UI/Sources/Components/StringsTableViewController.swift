//
//  StringsTableViewController.swift
//  UI
//
//  Created by Bohdan Orlov on 26/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit
import Layoutless

public protocol StringsRendering {
    var data: StringsData { get set }
}

public struct StringsData {
    let strings: [String]
    
    public init(strings: [String]) {
        self.strings = strings
    }
}

public typealias StringsRenderingViewController = StringsRendering & UIViewController

public class StringsTableViewController: UIViewController, StringsRendering {
    public var data: StringsData = StringsData(strings: []) {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let layout = self.tableView.fillingParent()
        layout.layout(in: self.view)
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.rowHeight = 90
        return tableView
    }()
}

extension StringsTableViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.strings.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Note: no cell reuse, don't do this for production:
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.numberOfLines = 3
        cell.textLabel?.text = self.data.strings[indexPath.row]
        return cell
    }
}
