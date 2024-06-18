//
//  DefaultsHandler.swift
//  kursach
//
//  Created by semyon on 6/17/24.
//

import Foundation

struct DefaultsHandler {
    static let urlKey = "urlString"
    static let usernameKey = "usernameString"
    static let defaults = UserDefaults.standard
    
    static func setUrl(value: String) -> Void {
        defaults.set(value, forKey: DefaultsHandler.urlKey)
    }
    
    static func getUrl() -> String {
        return defaults.string(forKey: DefaultsHandler.urlKey) ?? ""
    }
    
    static func setUsername(value: String) -> Void {
        defaults.set(value, forKey: DefaultsHandler.usernameKey)
    }
    
    static func getUsername() -> String {
        return defaults.string(forKey: DefaultsHandler.usernameKey) ?? ""
    }
}
