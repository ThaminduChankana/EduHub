//
//  ViewController.swift
//  EduHub
//
//  Created by Thamindu Gamage on 2024-04-02.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        if(Core.shared.isNewUser()){
            print(Core.shared.isNewUser())
            let vc = storyboard?.instantiateViewController(identifier: "WelcomeViewController") as! WelcomeViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc,animated: true)
        } else {
            let vc = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            vc.modalPresentationStyle = .fullScreen
            present(vc,animated: true)
        }
    }


}

class Core {
    
    static let shared = Core()
    
    func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}
