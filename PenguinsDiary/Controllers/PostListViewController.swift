//
//  PostListViewController.swift
//  PenguinsDiary
//
//  Created by Ruoxuan Wang on 8/13/21.
//

import UIKit

class PostListViewController: UITableViewController {

    var posts: [Post] = []
    let email = UserDefaults.standard.string(forKey: "email")
    let postList = UITableView()
    
    struct Cell {
        static let postListCell = "postListCell"
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        setupTableView()
        fetchPostData()
//
//        let rootVC = PostListViewController()
//        rootVC.title = "My Posts"
//        let navVC = UINavigationController(rootViewController: rootVC)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
        
    func setupTableView() {
        view.addSubview(postList)
        setupTableViewDelegate()
        postList.register(PostListCell.self, forCellReuseIdentifier: Cell.postListCell)
    }
    
    func setupTableViewDelegate() {
        postList.delegate = self
        postList.dataSource = self
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postList.dequeueReusableCell(withIdentifier: Cell.postListCell) as! PostListCell
        let post = posts[indexPath.row]
        cell.setupPostCell(with: .init(title: post.title, imageURL: post.headerImageURL))
        return cell
    }
    

    func fetchPostData() {
        DBManager.shared.getPersonalPosts(email: email ?? "") { posts in
            self.posts = posts
            self.tableView.reloadData()
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
        }
    }
}


//extension PostListViewController {
//    func fetchPostData( ) -> [Post] {
//        let post1 = Post(id: "1", createdAt: 1, title: "post1", body: "111", headerImageURL: nil)
//        let post2 = Post(id: "2", createdAt: 2, title: "post2", body: "222", headerImageURL: nil)
//        return [post1, post2]
// }
// }
