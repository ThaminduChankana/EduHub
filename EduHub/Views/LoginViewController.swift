//
//  LoginViewController.swift
//  EduHub
//
//  Created by Thamindu Gamage on 2024-04-02.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    var firestore: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firestore = Firestore.firestore()
    }
    
    @IBAction func login(_ sender: UIButton) {
        // Check if both username and password fields are filled
        guard let name = userName.text, let password = password.text else {
            self.alertMessage(title: "Error", message: "Please fill all the fields")
            return
        }
        
        // Attempt to sign in with provided credentials
        Auth.auth().signIn(withEmail: name, password: password) { authResult, error in
            if let e = error {
                // Display error message if sign-in fails
                self.alertMessage(title: "Error", message: e.localizedDescription)
            } else {
                // If sign-in is successful, navigate to the home view
                if let userId = authResult?.user.uid {
                    // Save userId to Firestore
                    // Navigate to the home view
                    self.fetchUserDocument(userId: userId)
                    UserDefaults.standard.set(userId, forKey: "user")
                    let controller = self.storyboard?.instantiateViewController(identifier: "homeView") as! UINavigationController
                    controller.modalPresentationStyle = .fullScreen
                    controller.modalTransitionStyle = .flipHorizontal
                    self.present(controller, animated: true, completion: nil)
                    // Show success message
                    self.alertMessage(title: "Success", message: "Successfuly logged in")
                }
            }
            
            
        }
        
    }
    func fetchUserDocument(userId: String) {
        firestore.collection("users").whereField("id", isEqualTo: userId).limit(to: 1)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error : \(error.localizedDescription)")
                    return
                }
                
                guard let document = querySnapshot?.documents.first else {
                    print("No data found")
                    return
                }
                
                let userData = document.data()
                
                if let isAdmin = userData["adminUser"] as? Bool, let userName = userData["name"] {
                    UserDefaults.standard.set(isAdmin, forKey: "adminUser")
                    UserDefaults.standard.set(userName, forKey: "userName")
                    
                } else {
                    print("Field not found in user data")
                }
            }
    }
    
    func alertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}
