//
//  RestAPI.swift
//  kursach
//
//  Created by semyon on 6/12/24.
//

import Foundation

struct Message : Decodable {
    let message: String
}

class PPTXRestAPI {
    private var _username: String?
    var username: String? {
        get {
            return _username
        }
        set {
            _username = newValue
        }
    }
    var url: String?
    
    func setUsername(username: String) -> Void {
        self.username = username
        return
    }
    
    func setUrl(url: String) -> Void {
        self.url = url
        return
    }
    
    init(url: String, username: String) {
        self.username = username
        self.url = url
    }
    
    func sendRequest(url: URL) -> String? {
        var result = ""
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error as Any)
                return
            }
            print("data:")
            print(data)
            print("response:")
            print(response!)
            
            do {
//                let resp = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                let resp = try JSONDecoder().decode(Message.self, from: data)
                print("resp:")
                print(resp.message)
                result = resp.message
            }
            catch {
                print("error:")
                print(error)
                result = "ERR REQUEST"
            }
        }
        task.resume()
        return result
        
    }
    
    func hb() -> String {
        if self.url == nil {
            return "url not set"
        }
        if self.username == nil {
            return "username not set"
        }
        
        guard let hbUrl = URL(string: (self.url! + "/" + self.username! + "/hb")) else { return "ERR HB URL" };
        return sendRequest(url: hbUrl) ?? "ERR HB RESULT"
    }
    
    func prev() -> String {
        if self.url == nil {
            return "url not set"
        }
        if self.username == nil {
            return "username not set"
        }
        
        guard let hbUrl = URL(string: (self.url! + "/" + self.username! + "/prev")) else { return "ERR PREV" };
        return sendRequest(url: hbUrl) ?? "ERR_PREV"
    }
    
    func next() -> String {
        if self.url == nil {
            return "url not set"
        }
        if self.username == nil {
            return "username not set"
        }
        
        guard let hbUrl = URL(string: (self.url! + "/" + self.username! + "/next")) else { return "ERR NEXT" };
        return sendRequest(url: hbUrl) ?? "ERR_PREV"
    }
}
