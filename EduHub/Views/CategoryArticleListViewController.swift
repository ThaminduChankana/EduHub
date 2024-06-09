//
//  CategoryArticleListViewController.swift
//  EduHub
//
//  Created by Thamindu Gamage on 2024-04-12.
//

import UIKit
import Firebase

class CategoryArticleListViewController: UIViewController {
    
    var firestore: Firestore!
    var blogs: [Article] = []
    var category: ArticleCategory!
    
    @IBOutlet weak var articleList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        firestore = Firestore.firestore()
        loadBlogs()
        title = category.name
    }
    
    private func registerCells() {
        articleList.register(UINib(nibName: ArticleListToCategoryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ArticleListToCategoryTableViewCell.identifier)
    }
    
    func loadBlogs() {
        firestore.collection("articles")
            .whereField("special", isEqualTo: true)
            .whereField("category", isEqualTo: category.name)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching blogs: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No blogs")
                    return
                }
                
                self.blogs = documents.compactMap { document in
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
                    self.articleList.reloadData()
                }
            }
    }
    
    
    
    
}

extension CategoryArticleListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleListToCategoryTableViewCell.identifier) as! ArticleListToCategoryTableViewCell
        cell.initializeCell(category: blogs[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = SingleBlogViewController.instantiate()
        controller.article = blogs[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}
