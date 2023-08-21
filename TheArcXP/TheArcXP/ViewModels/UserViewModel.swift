//
//  UserViewModel.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 4/22/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import Foundation
import ArcXP

class UserViewModel: ObservableObject {
    @Published var user: UserProfile?
    
    func fetchUser(completion: @escaping UserCompletion) {
        Commerce.Identity.fetchUserProfile { [weak self] userResult in
            switch userResult {
            case .success(let profile):
                self?.user = profile
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updatePassword(oldPass: String, newPass: String, completion: @escaping ServiceCompletion) {
        Commerce.Identity.updatePassword(oldPassword: oldPass, newPassword: newPass) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func requestResetPassword(email: String, completion: @escaping ServiceCompletion) {
        Commerce.Identity.requestResetPassword(username: email) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
