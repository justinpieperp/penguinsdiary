//
//  IAPManager.swift
//  PenguinsDiary
//
//  Created by Ruoxuan Wang on 7/26/21.
//

import Foundation
import Purchases

final class IAPManager {
    static let shared = IAPManager()
    
    private init() {}
    
    func isSubscriber() -> Bool {
        return false
    }
    
    func subscribe() {
        
    }
    
    func restorePurchases() {
        
    }
}
