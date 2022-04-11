//
//  StorageManager.swift
//  PenguinsDiary
//
//  Created by Ruoxuan Wang on 7/20/21.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private let container = Storage.storage()
    
    private init() {}
    
    public func uploadProfilePicture (
        email: String,
        image: UIImage?,
        completion: @escaping (Bool) -> Void
    ) {
        guard let data = image?.pngData() else { return }
        container
            .reference(withPath: "profile_pictures/\(formatEmail(email: email))/photo.png")
            .putData(data, metadata: nil) { metadata, error in
                guard metadata != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        print("Profile Photo Uploaded to storage: \(email)")
    }
    
    public func downloadProfilePictureUrl (
        path: String,
        completion: @escaping (URL?) -> Void)
        {
            container
                .reference(withPath: path)
                .downloadURL { url, _ in completion(url) }
            print("get profile Photo url")
        }
    
    public func setHeaderImage (
        email: String,
        postID: String,
        image: UIImage?,
        completion: @escaping (Bool) -> Void
    ) {
        guard let data = image?.pngData() else { return }
        container
            .reference(withPath: "post_header_images/\(formatEmail(email: email))/\(postID).png")
            .putData(data, metadata: nil) { metadata, error in
                guard metadata != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
        print("Uploaded Post Image to storage: \(email)/\(postID)")
        
    }
    
    public func getHeaderImageURL (
        email: String,
        postID: String,
        completion: @escaping (URL?) -> Void
    ) {
        container
            .reference(withPath: "post_header_images/\(formatEmail(email: email))/\(postID).png")
            .downloadURL { url, _ in
                completion(url)
            }
    }
    
    private func formatEmail(email: String) -> String {
        let formatedEmail = email.replacingOccurrences(of: ".", with: "_").replacingOccurrences(of: "@", with: "_")
        return formatedEmail
    }
    
}
