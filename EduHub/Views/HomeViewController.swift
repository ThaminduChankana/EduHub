//
//  HomeViewController.swift
//  EduHub
//
//  Created by Thamindu Gamage on 2024-04-03.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var publishedBlogsCollectionView: UICollectionView!
    @IBOutlet weak var myBlogsCollectionView: UICollectionView!
    var firestore: Firestore!
    
    var blogCategories: [ArticleCategory] = []
    var publishedBlogs: [Article] = []
    var myBlogs: [Article] = []
    var user: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firestore = Firestore.firestore()
        loadBlogCategories()
        loadPublishedBlogs()
        registerCells()
        
        if let userId = UserDefaults.standard.string(forKey: "user") {
            user = userId
            print(user)
            print("Id")
        } else {
            print("User ID not found in UserDefaults")
        }
        loadMyBlogs(user: user)
        
        
    }
    
    private func registerCells() {
        categoryCollectionView.register(UINib(nibName: BlogCategoryCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: BlogCategoryCollectionViewCell.identifier)
        publishedBlogsCollectionView.register(UINib(nibName: PublishedBlogCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PublishedBlogCollectionViewCell.identifier)
        myBlogsCollectionView.register(UINib(nibName: MyBlogCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MyBlogCollectionViewCell.identifier)
    }
    
    
    func loadBlogCategories() {
        // Fetch blog categories from Firestore
        firestore.collection("categories").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching blog categories: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No blog categories")
                return
            }
            
            self.blogCategories = documents.compactMap { document in
                let data = document.data()
                let id = document.documentID
                let name = data["name"] as? String ?? ""
                let imageURLString = data["image"] as? String ?? ""
                let imageURL = URL(string: imageURLString)
                
                return ArticleCategory(id: id, name: name, image: imageURL)
            }
            
            DispatchQueue.main.async {
                self.categoryCollectionView.reloadData()
            }
        }
    }
    
    func loadPublishedBlogs() {
        // Fetch published blogs from Firestore
        firestore.collection("articles")
            .whereField("special", isEqualTo: true)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching blogs: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No blogs")
                    return
                }
                
                print(documents)
                self.publishedBlogs = documents.compactMap { document in
                    let data = document.data()
                    let name = data["title"] as? String ?? ""
                    let imageURLString = data["image"] as? String ?? ""
                    let imageURL = URL(string: imageURLString)
                    let description = data["description"] as? String ?? ""
                    let authorName = data["authorName"] as? String ?? ""
                    let special = data["special"] as? Bool ?? false
                    let category = data["category"] as? String ?? ""
                    let user = data["user"] as? String ?? ""
                    
                    return Article(title: name, image: imageURL, description: description, authorName: authorName, category: category,special: special, user: user)
                }
                
                DispatchQueue.main.async {
                    self.publishedBlogsCollectionView.reloadData()
                }
            }
    }
    
    
    
    
    func loadMyBlogs(user: String) {
        // Fetch user's own blogs from Firestore
        firestore.collection("articles")
            .whereField("special", isEqualTo: false)
            .whereField("user", isEqualTo: user)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching blogs: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No blogs")
                    return
                }
                
                self.myBlogs = documents.compactMap { document in
                    let data = document.data()
                    let name = data["title"] as? String ?? ""
                    let imageURLString = data["image"] as? String ?? ""
                    let imageURL = URL(string: imageURLString)
                    let authorName = data["authorName"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let category = data["category"] as? String ?? ""
                    let special = data["special"] as? Bool ?? false
                    let user = data["user"] as? String ?? ""
                    
                    return Article(title: name, image: imageURL, description: description, authorName: authorName, category: category,special: special, user:user)
                }
                
                DispatchQueue.main.async {
                    self.myBlogsCollectionView.reloadData()
                }
            }
    }
    
    
}
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case categoryCollectionView:
            return blogCategories.count
        case publishedBlogsCollectionView:
            return publishedBlogs.count
        case myBlogsCollectionView:
            return myBlogs.count
        default:
            return 0
        }
        
    }
    // cell initialization
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case categoryCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BlogCategoryCollectionViewCell.identifier, for: indexPath) as! BlogCategoryCollectionViewCell
            cell.initializeCell(category: blogCategories[indexPath.row])
            return cell
        case publishedBlogsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PublishedBlogCollectionViewCell.identifier, for: indexPath) as! PublishedBlogCollectionViewCell
            cell.initializeCell(category: publishedBlogs[indexPath.row])
            return cell
        case myBlogsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyBlogCollectionViewCell.identifier, for: indexPath) as! MyBlogCollectionViewCell
            cell.initializeCell(category: myBlogs[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    // clicking behaviour
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == publishedBlogsCollectionView || collectionView == myBlogsCollectionView {
            let controller = SingleBlogViewController.instantiate()
            
            controller.article = collectionView == publishedBlogsCollectionView ? publishedBlogs[indexPath.row] : myBlogs[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        } else if collectionView == categoryCollectionView {
            let controller = CategoryArticleListViewController.instantiate()
            controller.category = blogCategories[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
}



