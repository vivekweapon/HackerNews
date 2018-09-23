//
//  LoginViewController.swift
//  HackerNews
//
//  Created by Vivekananda Cherukuri on 24/09/18.
//  Copyright © 2018 Vivekananda Cherukuri. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn


class LoginViewController:UIViewController,GIDSignInUIDelegate{
   
    let googleSignInButton:GIDSignInButton = {
        let button = GIDSignInButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        GIDSignIn.sharedInstance().uiDelegate = self

    }
    
    func setupViews(){
        self.view.addSubview(googleSignInButton)
        setUpConstraints()
    }
    
    func setUpConstraints(){
        googleSignInButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        googleSignInButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        googleSignInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        googleSignInButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
}
