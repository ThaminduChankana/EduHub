//
//  BlogCategoryCollectionViewCell.swift
//  EduHub
//
//  Created by Thamindu Gamage on 2024-04-10.
//

import UIKit

class BlogCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    static let identifier = "BlogCategoryCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImage.layer.cornerRadius = 10
        categoryImage.clipsToBounds = true
    }
    // Cell Initialization
    func initializeCell( category: ArticleCategory){
        // Loading image asynchronously
        if let imageURL = category.image {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL) {
                    if let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.categoryImage.image = image
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
        // Setting category title
        categoryTitle.text = category.name
        
    }
    
    
}
