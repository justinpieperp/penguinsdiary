//
//  TabBarViewController.swift
//  PenguinsDiary
//
//  Created by Ruoxuan Wang on 7/17/21.
//

import UIKit

class TabBarController: UITabBarController {
    
    var currentEmail = UserDefaults.standard.string(forKey: "email")

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    func setupTabBar() {
        UITabBar.appearance().tintColor = .systemTeal
        UITabBar.appearance().backgroundColor = .systemGray6
        UITabBar.appearance().unselectedItemTintColor = .black
        setViewControllers([setupHomeNavController(), setupPostVC(), setupProfileNavController()], animated: true)
    }
    
    func guestProfileController( ) -> UINavigationController {
        let guestProfileVC = SignInViewController()
        guestProfileVC.tabBarItem = UITabBarItem(title: "Sign In", image: UIImage(systemName: "person.fill"), tag: 2)
        let guestProfileNav = UINavigationController(rootViewController: guestProfileVC)
        return guestProfileNav
    }
    
    func guestPostController( ) -> UIViewController {
        let guestPostVC = GuestPostViewController()
        guestPostVC.tabBarItem = UITabBarItem(title: "Diaries", image: UIImage(systemName: "book.closed"), tag: 0)
        let guestPostNav = UINavigationController(rootViewController: guestPostVC)
        return guestPostNav
    }
    
    func setupHomeNavController( ) -> UINavigationController {
        let homeVC = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeVC.title = "Discover"
        homeVC.tabBarItem = UITabBarItem(title: "Discover", image: UIImage(systemName: "lasso.and.sparkles"), tag: 1)
        homeNav.navigationBar.prefersLargeTitles = true
        return homeNav
    }
    
    func setupPostVC( ) -> UINavigationController {
        guard currentEmail != nil else { return guestPostController() as! UINavigationController }
        let rootVC = PostListViewController()
        rootVC.title = "My Posts"
        rootVC.tabBarItem = UITabBarItem(title: "Diaries", image: UIImage(systemName: "book.closed"), tag: 0)
        
        let nav = UINavigationController(rootViewController: rootVC)
        rootVC.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Create Post",
            style: .plain,
            target: self,
            action: #selector(tappedRightButton)
        )
        
        return nav
    }
    
    @objc private func tappedRightButton() {
        
        let rootVC = CreatePostViewController()
        // navigationController?.pushViewController(vc, animated: true) does not work
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
        print("tapped")

    }
    
    func setupProfileNavController( ) -> UINavigationController {
        guard currentEmail != nil else { return guestProfileController() }
        let profileVC = ProfileViewController(currentEmail: currentEmail!)
        let profileNav = UINavigationController(rootViewController: profileVC)
        // profileVC.title = "Profile"
        // profileNav.navigationBar.prefersLargeTitles = true
        profileVC.tabBarItem = UITabBarItem(title: "Me", image: UIImage(systemName: "person.fill"), tag: 2)
        return profileNav
    }
    
    func getTabBarHeight() -> CGFloat {
        return tabBar.frame.size.height;
    }
}
