//
//  GuestProfileViewController.swift
//  PenguinsDiary
//
//  Created by Ruoxuan Wang on 11/16/21.
//

import UIKit

class GuestPostViewController: UIViewController {

    let message = UILabel()
    let loginBtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
        view.addSubview(message)
        view.addSubview(loginBtn)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        message.frame = CGRect(x: view.left, y: view.top, width: view.width, height: 100)
        message.center = view.center
        loginBtn.frame = CGRect(x: message.left, y: message.bottom, width: view.width/2, height: 40)
        loginBtn.center.x = view.center.x

    }
    
    func setup() {
        message.text = "Please Sign In."
        message.textAlignment = .center
        message.backgroundColor = .white
        loginBtn.setTitle("Sign In", for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.backgroundColor = .systemTeal
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        loginBtn.layer.cornerRadius = 8
        loginBtn.addTarget(self, action: #selector(tapLoginBtn), for: .touchUpInside)
    }
    
    @objc func tapLoginBtn() {
        let view = SignInViewController()
        navigationController?.present(view, animated: true, completion: nil)
    }
}
