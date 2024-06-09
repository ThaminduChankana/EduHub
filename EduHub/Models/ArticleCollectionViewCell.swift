//
//  ArticleCollectionViewCell.swift
//  EduHub
//
//  Created by Thamindu Gamage on 2024-04-03.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleLabel: UILabel!
    
    func setup (with article : Article){
   
        if let imageURL = article.image {
            print(imageURL)
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
        articleLabel.text = article.title
        articleLabel.textAlignment = .center
        articleImage.contentMode = .scaleAspectFill
        articleImage.clipsToBounds = true
        articleImage.layer.cornerRadius = 8
    }
    
}
