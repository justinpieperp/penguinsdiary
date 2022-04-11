//
//  SignUpViewController.swift
//  PenguinsDiary
//
//  Created by Ruoxuan Wang on 7/17/21.
//

import UIKit

class SignUpViewController: UITabBarController {
    
    // Declaration: Header View
    private let headerView = SignInHeaderView()
    
    // Declaration: username text fields
    private let usernameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Username"
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()
    
    // Declaration: email text fields
    private let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email"
        field.keyboardType = .emailAddress
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()
    
    // Declaration: password text fields
    private let pwdField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.isSecureTextEntry = true  // show asterisks when we type it on in
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()
    
    // Declaration: SignUp Button
    private let signUpButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .systemTeal
        btn.setTitle("Create Account", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        return btn
    }( )

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(pwdField)
        view.addSubview(signUpButton)
        
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 50, width: view.width, height: view.height/5)
        usernameField.frame = CGRect(x: 20, y: headerView.bottom + 60, width: view.width - 40, height: 50)
        emailField.frame = CGRect(x: 20, y: usernameField.bottom + 10, width: view.width - 40, height: 50)
        pwdField.frame = CGRect(x: 20, y: emailField.bottom + 10, width: view.width - 40, height: 50)
        signUpButton.frame = CGRect(x: 20, y: pwdField.bottom + 30, width: view.width - 40, height: 50)
    }
    
    @objc func didTapSignUpButton( ) {
        guard let username = usernameField.text, !username.isEmpty,
              let email = emailField.text, !email.isEmpty,
              let pwd = pwdField.text, !pwd.isEmpty else { return }
        
        AuthManager.shared.signUp(email: email, pwd: pwd) {
            success in
            if success {
                let newUser = User(id: UUID().uuidString , username: username, email: email, profilePicRef: nil)
                DBManager.shared.createUser(user: newUser) {
                    success in
                    guard success else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(username, forKey: "username")

                        let VC = TabBarController()
                        VC.modalPresentationStyle = .fullScreen
                        self.present(VC, animated: true)
                    }
                }
            } else {
                print("Failed to create account.")
            }
        }
    }
    

}
