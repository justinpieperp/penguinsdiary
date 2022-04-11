//
//  SignInViewController.swift
//  PenguinsDiary
//
//  Created by Ruoxuan Wang on 7/17/21.
//

import UIKit

class SignInViewController: UITabBarController {
    
    // Declaration: Header View
    private let headerView = SignInHeaderView()
    
    // Declaration: SignIn text fields
    private let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email"
        field.keyboardType = .emailAddress
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))  // left margin
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()
    
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
    
    // Declaration: SignIn Button
    private let signInButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .systemTeal
        btn.setTitle("Sign In", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        return btn
    }( )
    
    // Declaration: SignUp Button
    private let signUpButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Create Account", for: .normal)
        btn.setTitleColor(.systemTeal, for: .normal)
        return btn
    }( )

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        view.addSubview(emailField)
        view.addSubview(pwdField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        
//        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
//            if !IAPManager.shared.isSubscriber() {
//                let VC = PayWallViewController()
//                let navVC = UINavigationController(rootViewController: VC)
//                self.present(navVC, animated: true, completion: nil)
//            }
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 50, width: view.width, height: view.height/5)
        emailField.frame = CGRect(x: 20, y: headerView.bottom + 60, width: view.width - 40, height: 50)
        pwdField.frame = CGRect(x: 20, y: emailField.bottom + 10, width: view.width - 40, height: 50)
        signInButton.frame = CGRect(x: 20, y: pwdField.bottom + 30, width: view.width - 40, height: 50)
        signUpButton.frame = CGRect(x: 20, y: signInButton.bottom + 30, width: view.width - 40, height: 50)
    }
    
    @objc func didTapSignInButton( ) {
        guard let email = emailField.text,
              let pwd = pwdField.text,
              !email.isEmpty,
              !pwd.isEmpty else {
            return
        }
        
        AuthManager.shared.signIn(email: email, pwd: pwd) { [weak self] success in
            guard success else {
                return
            }
            
            DispatchQueue.main.async {
                UserDefaults.standard.set(email, forKey: "email")
                let VC = TabBarController()
                VC.modalPresentationStyle = .fullScreen
                self?.present(VC, animated: true)
            }
            
        }
    }
    
    @objc func didTapSignUpButton( ) {
        let VC = SignUpViewController()
        navigationController?.pushViewController(VC, animated: true)
        VC.navigationItem.largeTitleDisplayMode = .never
    }
    
}
