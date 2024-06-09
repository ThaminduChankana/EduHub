//
//  RegisterViewController.swift
//  EduHub
//
//  Created by Thamindu Gamage on 2024-04-02.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var name: UITextField!
    
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func register(_ sender: UIButton) {
        guard let name = name.text,
              let username = username.text,
              let password = password.text,
              let confirmPassword = confirmPassword.text else {
            self.alertMessage(title: "Error", message: "Please fill all the fields")
            return
        }
        
        guard password == confirmPassword else {
            self.alertMessage(title: "Error", message: "Passwords are not matching")
            return
        }
        // Attempt to create a new user account
        Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
            if let e = error {
                // Display error message if registration fails
                self.alertMessage(title: "Error", message: e.localizedDescription)
            } else {
                // If registration is successful, save user data to Firestore
                
                
                if let userId = authResult?.user.uid {
                    let newUser = User(name: name, username: username, id: userId, adminUser: false)
                    saveUserToFirestore(user: newUser)
                    UserDefaults.standard.set(userId, forKey: "user")
                    UserDefaults.standard.set(false, forKey: "adminUser")
                } else {
                    self.alertMessage(title: "Error", message: "User ID not found")
                }
            }
            
        }
        
        
        
        func saveUserToFirestore(user: User) {
            let db = Firestore.firestore()
            db.collection("users").addDocument(data: [
                "name": user.name,
                "username": user.username,
                "id": user.id,
                "adminUser": false
            ]) { error in
                if let error = error {
                    self.alertMessage(title: "Error", message: error.localizedDescription)
                } else {
                    // If user data is successfully saved, navigate to the home view
                    
                    let controller = self.storyboard?.instantiateViewController(identifier: "homeView") as! UINavigationController
                    controller.modalPresentationStyle = .fullScreen
                    controller.modalTransitionStyle = .flipHorizontal
                    self.present(controller, animated: true, completion: nil)
                    // Show success message
                    self.alertMessage(title: "Success", message: "Registered successfully!")
                }
            }
            
        }
        
    }
    
    func alertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
