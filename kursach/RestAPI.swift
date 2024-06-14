//
//  RestAPI.swift
//  kursach
//
//  Created by semyon on 6/12/24.
//

import Foundation

class RestAPI : ObservableObject {
    var username: String?
    var url: String?
    
    func setUsername(un: String) {
        self.username = un
    }
    
    func setUrl(url: String) {
        self.url = url
    }
    
    init() {
        
    }
    
    func sendRequest(url: URL) -> String? {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error as Any)
                return
            }
            
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(response)
            }
            catch {
                print(error)
            }
        }
        task.resume()
        return "OK"
        
    }
    
    func hb() -> String {
        if self.url == nil {
            return "url not set"
        }
        if self.username == nil {
            return "username not set"
        }
        
        guard let hbUrl = URL(string: self.url! + "/" + self.username! + "hb") else { return "ERR HB" };
        return sendRequest(url: hbUrl) ?? "ERRHB"
    }
}
