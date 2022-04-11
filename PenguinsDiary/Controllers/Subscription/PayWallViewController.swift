//
//  PayWallViewController.swift
//  PenguinsDiary
//
//  Created by Ruoxuan Wang on 8/4/21.
//

import UIKit

class PayWallViewController: UIViewController {
    
    private let headerView = PayWallHeaderView()
    
    private let descView = PayWallDescriptionView()
    
    // Declaration: buttons
    private let subscribeButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .systemTeal
        btn.setTitle("Subscribe", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        return btn
    }()
    
    private let restoreButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Restore Purchases", for: .normal)
        btn.setTitleColor(.systemTeal, for: .normal)
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        return btn
    }()
    
    // Declaration: terms of services: textView
    private let termsView: UITextView = {
        let terms = UITextView()
        terms.isEditable = false
        terms.textAlignment = .center
        terms.font = .systemFont(ofSize: 14)
        terms.text = "By allowing users to try your subscription at the moment they’re most interested in its value, you increase the likelihood that they will subscribe. There are several ways you can provide a preview of the subscription experience."
        return terms
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upgrade Your Account"
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        view.addSubview(descView)
        view.addSubview(subscribeButton)
        view.addSubview(restoreButton)
        view.addSubview(termsView)
        setUpButtons()
        setUpCloseButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height/3.2)
        termsView.frame = CGRect(x: 10, y: view.height - 100, width: view.width - 20, height: 100)
        restoreButton.frame = CGRect(x: 25, y: termsView.top - 70, width: view.width - 50, height: 50)
        subscribeButton.frame = CGRect(x: 25, y: restoreButton.top - 60, width: view.width - 50, height: 50)
        descView.frame = CGRect(x: 0, y: headerView.bottom, width: view.width, height: subscribeButton.top - view.safeAreaInsets.top - headerView.height)
    }
    
    private func setUpButtons() {
        subscribeButton.addTarget(self, action: #selector(didTapSubscribeButton), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(didTapRestoreButton), for: .touchUpInside)
    }
    
    private func setUpCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCloseButton))
    }
    
    @objc private func didTapSubscribeButton() {
        
    }
    
    @objc private func didTapRestoreButton(){
        
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}
