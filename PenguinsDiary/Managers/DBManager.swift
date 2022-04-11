//
//  DBManager.swift
//  PenguinsDiary
//
//  Created by Ruoxuan Wang on 7/20/21.
//

import Foundation
import FirebaseFirestore

// class marked as final can not be inherited or overriden
final class DBManager {
    
    static let shared = DBManager()
    private let db = Firestore.firestore()
    private init() {}
    
    // var usersRef: Query { return db.collection("users") }
    // var postsRef: Query { return db.collection("posts") }
        
    public func createUser(
        user: User,
        completion: @escaping (Bool) -> Void
    ) {
        
        let formatedEmail = formatUserEmail(email: user.email)
        let data = [
            "id":       user.id,
            "username": user.username,
            "email":    formatedEmail
            ]
        db
            .collection("users")
            .document(formatedEmail)
            .setData(data) { error in completion(error == nil)
        }
    }

    
    public func getUser(
        email: String,
        completion: @escaping (User?) -> Void
    ){
        let formattedEmail = formatUserEmail(email: email)
        db
            .collection("users")
            .document(formattedEmail)
            .getDocument { snapshot, error in
                guard let data      = snapshot?.data() as? [String: String],
                      let username  = data["username"],
                      let id        = data["id"],
                      error == nil else {
                    return
            }
            
            let profilePicRef = data["profile_pic_ref"]
            let user = User(id: id, username: username, email: email, profilePicRef: profilePicRef)
            completion(user)
        }
        print("call get user function")
    }
    
    public func updateProfilePicture(
        email: String,
        completion: @escaping (Bool) -> Void
    ) {

        let formatedEmail = formatUserEmail(email: email)
        let path = "profile_pictures/\(formatedEmail)/photo.png"
        
        let dbRef = db
            .collection("users")
            .document(formatedEmail)
        
        dbRef.getDocument { snapshot, error in
            guard var data = snapshot?.data(), error == nil else {
                return
            }
            data["profile_pic_ref"] = path
            
            dbRef.setData(data) { error in
                completion(error == nil)
            }
        }
        print("Profile Photo Uploaded")
    }
    
    public func createPost(
        post: Post,
        email: String,
        completion: @escaping (Bool) -> Void
    ) {
        
        let data: [String: Any] = [
            "id":               post.id,
            "createdAt":        post.createdAt,
            "title":            post.title,
            "body":             post.body,
            "headerImageURL":   post.headerImageURL?.absoluteString ?? ""
        ]
        
        db
            .collection("users")
            .document(formatUserEmail(email: email))
            .collection("posts")
            .document(post.id)
            .setData(data) { err in
                completion(err == nil)
            }
    }
    
    public func getPersonalPosts(
        email: String,
        completion: @escaping ([Post]) -> Void
    ) {
        
        db
            .collection("users")
            .document(formatUserEmail(email: email))
            .collection("posts")
            .getDocuments { querySnapshot, err in
            guard let documents = querySnapshot?.documents.compactMap({ $0.data() }), err == nil else { return }
            
            let posts: [Post] = documents.compactMap({ dictionary in
                guard let id                = dictionary["id"] as? String,
                      let createdAt         = dictionary["createdAt"] as? TimeInterval,
                      let title             = dictionary["title"] as? String,
                      let body              = dictionary["body"] as? String,
                      let headerImageString = dictionary["headerImageURL"] as? String else { return nil }
                let post = Post(
                    id: id,
                    createdAt: createdAt,
                    title: title,
                    body: body,
                    headerImageURL: URL(string: headerImageString)
                )
                return post
            })
            completion(posts)
        }
    }
    
    public func getAllPosts(completion: @escaping ([Post]) -> Void) {
        db
            .collection("users")
            .getDocuments { querySnapshot, err in
                guard let documents = querySnapshot?.documents.compactMap({ $0.data() }),
                      err == nil else { return }
                let emails: [String] = documents.compactMap({ $0["email"] as? String })
                var posts: [Post] = []
                let group = DispatchGroup()
                for email in emails {
                    group.enter()
                    self.getPersonalPosts(email: email) { userPosts in
                        defer {
                            group.leave()
                        }
                        posts.append(contentsOf: userPosts)
                    }
                }
                group.notify(queue: .global()) {
                    completion(posts)
                }
            }
    }
    
    func formatUserEmail(email: String) -> String {
        let email = email
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        return email
    }
}

//public func getPersonalPosts(email: String, completion: @escaping ([Post]) -> Void) {
//
//    db.collection("users").document(formatUserEmail(email: email)).collection("posts").getDocuments { querySnapshot, err in
//        if let err = err { print("Error getting posts documents: \(err) ") } else {
//            for document in querySnapshot!.documents {
//                let id              = document["id"] as? String,
//                    createdAt       = document["createdAt"] as? TimeInterval,
//                    title           = document["title"] as? String,
//                    body            = document["body"] as? String,
//                    headerImageURL  = document["headerImageURL"] as? URL
//
//                let post = Post(id: id!, createdAt: createdAt!, title: title!, body: body!, headerImageURL: headerImageURL ?? "")
//                let posts = [post]
//                completion(posts)
//            }
//        }
//    }
//}
