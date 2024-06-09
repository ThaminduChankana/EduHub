//
//  PublishedBlogCollectionViewCell.swift
//  EduHub
//
//  Created by Thamindu Gamage on 2024-04-10.
//

import UIKit

class PublishedBlogCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var blogCategory: UILabel!
    @IBOutlet weak var blogTitle: UILabel!
    @IBOutlet weak var blogImage: UIImageView!
    @IBOutlet weak var blogAuthor: UILabel!
    static let identifier = "PublishedBlogCollectionViewCell"
    
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
        // Setting blog title, author, and category
        blogTitle.text = category.title
        blogAuthor.text = "Author : " + category.authorName
        blogCategory.text = "Category : " + category.category
        
    }
    
    
}
