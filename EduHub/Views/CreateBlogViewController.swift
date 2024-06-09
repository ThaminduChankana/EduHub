//
//  CreateBlogViewController.swift
//  EduHub
//
//  Created by Thamindu Gamage on 2024-04-10.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class CreateBlogViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var blogImage: UIImageView!
    @IBOutlet weak var blogTitle: UITextField!
    
    @IBOutlet weak var blogDescription: UITextView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func submit(_ sender: UIButton) {
        
        guard let blogTitle = blogTitle.text, !blogTitle.isEmpty,
              let blogDescription = blogDescription.text, !blogDescription.isEmpty,
              let blogImage = blogImage.image else {
            self.alertMessage(title: "Error", message: "All fields must be filled")
            print("Error: All fields must be filled")
            return
        }
        
        uploadImageToFirebaseStorage(image: blogImage) { [weak self] imageURL in
            guard let self = self, let imageURL = imageURL else {
                self?.alertMessage(title: "Error", message: "Failed to upload image to Firebase")
                print("Error: Failed to upload image to Firebase")
                return
            }
            if let userId = UserDefaults.standard.string(forKey: "user") {
                let isAdmin = UserDefaults.standard.bool(forKey: "adminUser")
                let userName = UserDefaults.standard.string(forKey: "userName")
                if isAdmin {
                    let blog = Article(title: blogTitle, image: imageURL, description: blogDescription, authorName: userName ?? "", category: "Technology", special: true, user: userId)
                    self.saveBlogToFirestore(blog: blog)
                    
                } else {
                    let blog = Article(title: blogTitle, image: imageURL, description: blogDescription, authorName: "Self", category: "None", special: false, user: userId)
                    self.saveBlogToFirestore(blog: blog)
                }
            } else {
                print("User ID not found in UserDefaults")
            }
            
        }
        
    }
    
    func uploadImageToFirebaseStorage(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("images/\(UUID().uuidString).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                self.alertMessage(title: "Error", message: "Failed to upload image to Firebase")
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            imageRef.downloadURL { url, error in
                if let error = error {
                    self.alertMessage(title: "Error", message: "Error getting download URL")
                    print("Error getting download URL: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                completion(url)
            }
        }
    }
    
    func saveBlogToFirestore(blog: Article) {
        let db = Firestore.firestore()
        let blogData = blog.toDictionary()
        db.collection("articles").addDocument(data: blogData) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
                self.alertMessage(title: "Error", message: "Error adding document")
            } else {
                let controller = self.storyboard?.instantiateViewController(identifier: "homeView") as! UINavigationController
                controller.modalPresentationStyle = .fullScreen
                controller.modalTransitionStyle = .flipHorizontal
                self.present(controller, animated: true, completion: nil)
                print("Article added successfully!")
                self.alertMessage(title: "Success", message: "Article added successfully!")
            }
        }
    }
    var admin: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tapgasture()
        
        blogImage.layer.cornerRadius = 10
        blogImage.clipsToBounds = true
        
        if let adminUser = UserDefaults.standard.string(forKey: "adminUser") {
            admin = adminUser
        } else {
            print("User ID not found in UserDefaults")
        }
    }
    
    func tapgasture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        blogImage.isUserInteractionEnabled = true
        blogImage.addGestureRecognizer(tap)
    }
    
    @objc func imageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            blogImage.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func alertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
}
