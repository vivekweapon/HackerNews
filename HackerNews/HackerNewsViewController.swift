//
//  HackerNewsViewController.swift
//  HackerNews
//
//  Created by Vivekananda Cherukuri on 21/09/18.
//  Copyright © 2018 Vivekananda Cherukuri. All rights reserved.
//

import UIKit

class HackerNewsViewController: UIViewController {
    
    let hackerNewsTableView:UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "Top Stories"
        hackerNewsTableView.delegate = self
        hackerNewsTableView.dataSource = self
        hackerNewsTableView.register(HackerNewsCell.self, forCellReuseIdentifier: "HackerNewsCell")
        hackerNewsTableView.separatorStyle = .none
        self.view.addSubview(hackerNewsTableView)
        setUpConstraints()
    }
    
    func setUpConstraints(){
        self.hackerNewsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.hackerNewsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.hackerNewsTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.hackerNewsTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
    }

}
extension HackerNewsViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let hackerNewsCell = hackerNewsTableView.dequeueReusableCell(withIdentifier: "HackerNewsCell", for: indexPath) as! HackerNewsCell
        return hackerNewsCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    
}

