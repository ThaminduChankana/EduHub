//
//  ArticleListToCategoryTableViewCell.swift
//  EduHub
//
//  Created by Thamindu Gamage on 2024-04-12.
//

import UIKit

class ArticleListToCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var articleImage: UIImageView!
    
    @IBOutlet weak var articleTitle: UILabel!
    
    static let identifier = "ArticleListToCategoryTableViewCell"
    
    // Cell Initialization
    func initializeCell( category: Article){
        // Loading image asynchronously
        if let imageURL = category.image {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL) {
                    if let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.articleImage.image = image
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
        // Setting article title
        articleTitle.text = category.title
        
    }
}
