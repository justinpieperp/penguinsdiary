//
//  ViewController.swift
//  PenguinsDiary
//
//  Created by Ruoxuan Wang on 7/17/21.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var posts: [Post] = []
    let postList = UITableView()
    let createButton = UIButton()
        
    struct Cell {
        static let postListCell = "postListCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray4
        setupTableView()
        fetchPostData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        postList.frame = view.bounds
        createButton.frame = CGRect(
            x: view.frame.width - 88,
            y: view.frame.height - 88 - view.safeAreaInsets.bottom,
            width: 60,
            height: 60
        )
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
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postList.dequeueReusableCell(withIdentifier: Cell.postListCell) as! PostListCell
        let post = posts[indexPath.row]
        cell.setupPostCell(with: .init(title: post.title, imageURL: post.headerImageURL))
        return cell
    }
    
    func fetchPostData() {
        DBManager.shared.getAllPosts { posts in
            self.posts = posts
            DispatchQueue.main.async {
                self.postList.reloadData()
            }
        }
    }
}


