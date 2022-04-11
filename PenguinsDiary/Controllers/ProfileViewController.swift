//
//  ProfileViewController.swift
//  PenguinsDiary
//
//  Created by Ruoxuan Wang on 7/17/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private var user: User?
    let currentEmail: String

    init(currentEmail: String) {
        self.currentEmail = currentEmail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        fetchUserData()
        setupHeader()
        setupLogOutButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupHeader(
        username: String? = nil,
        profilePicRef: String? = nil
    ) {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5))
        headerView.backgroundColor = .systemBlue
        headerView.isUserInteractionEnabled = true
        headerView.clipsToBounds = true
        view.addSubview(headerView)
        
        let profilePic = UIImageView(image: UIImage(systemName: "person.circle"))
        profilePic.tintColor = .white
        profilePic.contentMode = .scaleAspectFit
        profilePic.frame = CGRect(
            x: (view.width-(view.width/4))/2,
            y: (headerView.height-(view.width/4))/2.5,
            width: view.width/4,
            height: view.width/4
        )
        profilePic.layer.masksToBounds = true
        profilePic.layer.cornerRadius = profilePic.width/2
        profilePic.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePic))
        profilePic.addGestureRecognizer(tap)
        headerView.addSubview(profilePic)

        let usernameField = UILabel(frame: CGRect(x: 20, y: profilePic.bottom, width: view.width-40, height: 100))
        
        if let username = username {
            usernameField.text = username
        }
        
        usernameField.textAlignment = .center
        usernameField.textColor = .white
        usernameField.font = .systemFont(ofSize: 20, weight: .regular)
        headerView.addSubview(usernameField)

        let emailField = UILabel(frame: CGRect(x: 20, y: profilePic.bottom+20, width: view.width-40, height: 100))
        emailField.font = .systemFont(ofSize: 20, weight: .regular)
        emailField.text = currentEmail
        emailField.textAlignment = .center
        emailField.textColor = .white
        headerView.addSubview(emailField)
                
        if let ref = profilePicRef {
            StorageManager.shared.downloadProfilePictureUrl(path: ref) { url in
                guard let url = url else { return }
                let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data else {
                        return
                    }
                    DispatchQueue.main.async {
                        profilePic.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
        }
    }
    
    func fetchUserData() {
        DBManager.shared.getUser(email: currentEmail) { [weak self] user in
            guard let user = user else {
                return
            }
            
            self?.user = user

            // UI updates must be done on the main thread
            DispatchQueue.main.async {
                self?.setupHeader(
                    username: user.username,
                    profilePicRef: user.profilePicRef
                )
            }
        }
        print(user?.username)
        print(user?.profilePicRef)
    }
    
    func setupLogOutButton() {
        
        let tabBarController = TabBarController()
        let tabBarHeight = tabBarController.getTabBarHeight()
        let singleItemHeight = view.height/15;
        let logOutButton = UIButton(frame: CGRect(x: view.left, y: view.bottom - tabBarHeight - 100, width: view.width, height: singleItemHeight))
        logOutButton.setTitle("Log Out", for: .normal)
        logOutButton.setTitleColor(.systemTeal, for: .normal)
        logOutButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        logOutButton.backgroundColor = .systemGray
        logOutButton.addTarget(self, action: #selector(didTapLogOut), for: .touchUpInside)
        view.addSubview(logOutButton)
    }
        
    @objc private func didTapProfilePic() {
        // 确认现在的email是自己的 is this necessary?
        guard let userEmail = UserDefaults.standard.string(forKey: "email"),
                userEmail == currentEmail else {
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc private func didTapLogOut() {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you'd like to log out?", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "Cancel", style: .cancel
                                          , handler: nil)
        let action2 = UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            AuthManager.shared.signOut { success in
                if success {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(nil, forKey: "email")
                        UserDefaults.standard.set(nil, forKey: "username")

                        let VC = TabBarController()
                        VC.modalPresentationStyle = .fullScreen
                        self.present(VC, animated: true, completion: nil)
                    }
                }
            }
        })
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true)
    }
}

    
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        StorageManager.shared.uploadProfilePicture(email: currentEmail, image: image) { [weak self] success in
            guard let strongSelf = self else { return }
            if success {
                DBManager.shared.updateProfilePicture(email: strongSelf.currentEmail) { updated in
                    guard updated else { return }
                    DispatchQueue.main.async {
                        strongSelf.fetchUserData()
                    }
                }
            }
        }
    }
}
