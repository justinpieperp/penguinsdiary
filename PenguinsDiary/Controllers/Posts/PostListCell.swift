//
//  postListCellTableViewCell.swift
//  PenguinsDiary
//
//  Created by Ruoxuan Wang on 8/12/21.
//

import UIKit

class PostListCellViewModel {
    let title: String
    let imageURL: URL?
    var imageData: Data?
    
    init(title: String, imageURL: URL?) {
        self.title = title
        self.imageURL = imageURL
    }
}

class PostListCell: UITableViewCell {

    let postTitleLabel = UILabel()
    let postImageView = UIImageView()
    // var postID: String
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(postTitleLabel)
        addSubview(postImageView)
        
        setupPostTitleLable()
        setupPostImageView()
        setTitleConstraints()
        setImageConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func setupPostCell(post: Post) {
//        // postID = post.id
//        postTitleLabel.text = post.title
//        // postImageView.image = post.headerImageURL
//        postImageView.image = UIImage(named: "test")
//
//    }
    
    func setupPostCell(with viewModel: PostListCellViewModel) {
        postTitleLabel.text = viewModel.title
        
        if let data = viewModel.imageData {
            postImageView.image = UIImage(data: data)
        }
        else if let imageURL = viewModel.imageURL {
            // fetch image&cache
            let task = URLSession.shared.dataTask(with: imageURL) { data, _, _ in
                guard let data = data else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self.postImageView.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
    
    func setupPostTitleLable( ) {
        postTitleLabel.numberOfLines = 0
        postTitleLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setupPostImageView( ) {
        postImageView.layer.cornerRadius = 8
        postImageView.clipsToBounds = true
    }
    
    func didTapCell( ) {
        
    }
}

extension PostListCell {
    
    func setTitleConstraints( ) {
        postTitleLabel.translatesAutoresizingMaskIntoConstraints                                                = false
        postTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                                = true
        postTitleLabel.leadingAnchor.constraint(equalTo: postImageView.trailingAnchor, constant: 20).isActive   = true
        postTitleLabel.heightAnchor.constraint(equalToConstant: 80).isActive                                    = true
        postTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive               = true
    }

    func setImageConstraints( ) {
        postImageView.translatesAutoresizingMaskIntoConstraints                                                 = false
        postImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive                                 = true
        postImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive                   = true
        postImageView.heightAnchor.constraint(equalToConstant: 80).isActive                                     = true
        postImageView.widthAnchor.constraint(equalTo: postImageView.heightAnchor, multiplier: 16/9).isActive    = true
    }
}
