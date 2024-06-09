//
//  MyBlogCollectionViewCell.swift
//  EduHub
//
//  Created by Thamindu Gamage on 2024-04-10.
//

import UIKit

class MyBlogCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var blogImage: UIImageView!
    @IBOutlet weak var blogTitle: UILabel!
    static let identifier = "MyBlogCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Apply corner radius to the blog image
        blogImage.layer.cornerRadius = 10
        blogImage.clipsToBounds = true
    }
    
    // Cell Initialization
    func initializeCell( category: Article){
        // Loading image asynchronously
        if let imageURL = category.image {
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
        
        // Setting blog title
        blogTitle.text = category.title
        
    }
    
}
