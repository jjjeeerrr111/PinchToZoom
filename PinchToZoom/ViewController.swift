//
//  ViewController.swift
//  PinchToZoom
//
//  Created by Jeremy Sharvit on 2017-08-26.
//  Copyright © 2017 com.zoom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var tableView:UITableView!
    var posts:[Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .orange
        
        for _ in 0...10 {
            let post = Post(imageUrl: "exampleURL", caption: "This is supposed to be a long description like an instagram post caption with #hashtags and emojis 😘😊😅🙈")
            posts.append(post)
        }
        setUpTableView()
        
    }

    func setUpTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let const:[NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        ]
        
        NSLayoutConstraint.activate(const)
        
        tableView.register(PostCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.clear
        tableView.backgroundColor = .white
        
    }

}

extension ViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PostCell
        cell.caption.text = posts[indexPath.row].caption
        return cell
    }
}
