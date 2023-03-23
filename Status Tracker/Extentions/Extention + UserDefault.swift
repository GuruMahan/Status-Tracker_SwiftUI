//
//  Extention + UserDefault.swift
//  CoreDataLogin
//
//  Created by Guru Mahan on 02/02/23.
//

import Foundation

extension UserDefaults{
    static let email = "Email"
    static let phoneNumber = "phoneNumber"
    static let password = "password"
    static let confirmPassword = "confirmPassword"
    
    static var emailId: String? {
        get{
            return self.standard.string(forKey: email)
        }
        set{
            self.standard.set(newValue, forKey: email)
        }
    }
    
    static var phoneNumberData: String? {
        get{
            return self.standard.string(forKey: phoneNumber)
        }
        set{
            self.standard.set(newValue, forKey: phoneNumber)
        }
    }
    
    static var passwordData: String? {
        get{
            return self.standard.string(forKey: password)
        }
        set{
            self.standard.set(newValue, forKey: password)
        }
    }
    
    static var confirmPasswordData: String? {
        get{
            return self.standard.string(forKey: confirmPassword)
        }
        set{
            self.standard.set(newValue, forKey: confirmPassword)
        }
    }
}
