//
//  SingleBlogViewController.swift
//  EduHub
//
//  Created by Thamindu Gamage on 2024-04-10.
//

import UIKit

class SingleBlogViewController: UIViewController {

    @IBOutlet weak var blogTitle: UILabel!
    
    
    @IBOutlet weak var blogImage: UIImageView!
    
    
    @IBOutlet weak var blogDescription: UITextView!
    
    var article: Article!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateView()

        blogImage.layer.cornerRadius = 10
        blogImage.clipsToBounds = true
        blogDescription.isEditable = false
    }
    
    private func populateView (){
        if let imageURL = article.image {
                    DispatchQueue.global().async {
                        if let imageData = try? Data(contentsOf: imageURL) {
                            if let image = UIImage(data: imageData) {
                                DispatchQueue.main.async {
                                    self.blogImage.image = image
                                }
                            } else {
                                print("Error: Couldn't create UIImage from data.")
                            }
                        } else {
                            print("Error: Couldn't load image data from URL.")
                        }
                    }
                } else {
                    print("Error: Image URL is nil.")
                }
        
        blogTitle.text = article.title
        blogDescription.text = article.description
        
    }

  
}
