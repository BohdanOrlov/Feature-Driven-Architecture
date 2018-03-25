//  Created by Bohdan Orlov on 01/03/2018.
//  Copyright © 2018 Bohdan Orlov. All rights reserved.
//

import Foundation
import UIKit
import Domain

class PostsViewController: UIViewController {
    struct Data {
        let posts: [String]
    }
    
    var data: Data = Data(posts: []) {
        didSet {
            self.tablewView.reloadData()
        }
    }
    
    var didPrepareButtonContainer: ((UIView) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tablewView)
        self.tablewView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.tablewView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.tablewView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.tablewView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        let buttonContainer = UIView()
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(buttonContainer)
        buttonContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        buttonContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.didPrepareButtonContainer?(buttonContainer)
    }
    
    private lazy var tablewView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        return tableView
    }()
}

extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Note: no cell reuse, don't do this for production:
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = self.data.posts[indexPath.row]
        return cell
    }
    
    
}

class PostsScreenFeature {
    init(postsViewController: PostsViewController,
         viewControllerPresenting: ViewControllerPresenting,
         postsRepository: postsStoring,
         didPrepareButtonContainer: @escaping (UIView) -> Void) {
        postsViewController.didPrepareButtonContainer = didPrepareButtonContainer
        let posts: [String] = postsRepository.posts.map { $0.text }
        postsViewController.data = .init(posts: posts)
        viewControllerPresenting.present(viewController: postsViewController, completion: {
            
        })
        
    }
}
