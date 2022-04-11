//
//  CreatePostViewController.swift
//  PenguinsDiary
//
//  Created by Ruoxuan Wang on 7/17/21.
//

import UIKit

class CreatePostViewController: UIViewController {

    let postTitle = UITextField()
    let postBody = UITextView()
    let headerImage = UIImageView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigation()
        setupEditor()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        postTitle.frame = CGRect(x: 20, y: view.safeAreaInsets.top
                                 , width: view.width - 40, height: 50)
        postBody.frame = CGRect(x: 20, y: postTitle.bottom, width: view.width - 40, height: 200)
        headerImage.frame = CGRect(x: 20, y: postBody.bottom + 20, width: 100, height: view.height - 250 - view.safeAreaInsets.top)
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
    }

    func setupNavigation( ) {
        self.navigationController?.navigationBar.tintColor = .systemTeal
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
    }
    
    func setupEditor( ) {
        postTitle.placeholder = "Title"
        postBody.isEditable = true
        postBody.backgroundColor = .secondarySystemBackground
        // postBody.font = .systemFont(ofSize: 28)
        
        headerImage.image = UIImage(systemName: "photo.on.rectangle.angled")
        headerImage.contentMode = .scaleAspectFit
        headerImage.clipsToBounds = true
        headerImage.isUserInteractionEnabled = true
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        headerImage.addGestureRecognizer(tapImage)
        
        view.addSubview(postTitle)
        view.addSubview(postBody)
        view.addSubview(headerImage)
    }
    
    @objc func didTapCancel( ) {
        let alert = UIAlertController(title: "Return", message: "Do you want to exit without saving?", preferredStyle: .alert)
        let letfAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let rightAction = UIAlertAction(title: "I'm sure", style: .default, handler: {_ in
            //self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(letfAction)
        alert.addAction(rightAction)
        present(alert, animated: true, completion: nil)
    }

    @objc func didTapPost( ) {
        
        let postID = UUID().uuidString
        
        guard
            let title = postTitle.text,
            let body = postBody.text,
            let headerImage = headerImage.image,
            let email = UserDefaults.standard.string(forKey: "email")
        else { return }
        
        StorageManager.shared.setHeaderImage(email: email, postID: postID, image: headerImage) { success in
            guard success else { return }
            
            StorageManager.shared.getHeaderImageURL(email: email, postID: postID) { url in
                guard let url = url else { return }
                
                let post = Post(
                    id: postID,
                    createdAt: Date().timeIntervalSince1970,
                    title: title,
                    body: body,
                    headerImageURL: url)
                
                DBManager.shared.createPost(post: post, email: email) { success in
                    guard success else { return }
                }
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapImage( ) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
}


extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        headerImage.image = image
        
    }
}
