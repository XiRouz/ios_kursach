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

class PPTXRestAPI : ObservableObject {
    var username: String?
    var url: String?
    @Published var hbFeedback: String = "Waiting for connection..."
    
    var queue = DispatchQueue.global(qos: .background)
    var hbTimer: Timer?
    
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
        
        hbTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { hbTimer in
            self.hb()
        }
        
        self.queue.async {
            RunLoop.current.add(self.hbTimer!, forMode: RunLoop.Mode.default)
            RunLoop.current.run()
        }
    }
    
    func sendRequest(url: URL, completion: @escaping(String) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data
//                let string = String(data: data, encoding: .utf8),
//                let dictionary = (text: string),
//                let message = dictionary["message"] as? String
            else {
                print("err")
                print(error)
//                DispatchQueue.main.async {
//                    completion(.failure(error ?? URLError(.badServerResponse)))
//                }
                return
            }
            do {
                let resp = try JSONDecoder().decode(Message.self, from: data)
                print("resp:")
                print(resp.message)
                DispatchQueue.main.async {
//                    completion(.success(resp))
                    completion(resp.message)
                }
            }
            catch {
                print("error:")
                print(error)
            }
        }
        task.resume()
    }
    
    func hb() -> Void {
        if self.url == nil {
            print("url not set")
            return
        }
        if self.username == nil {
            print("username not set")
            return
        }
        
        guard let hbUrl = URL(string: (self.url! + "/" + self.username! + "/hb")) else
        {
            print("ERR HB URL")
            return
        };
        var requestWentThrough = false
        sendRequest(url: hbUrl) { result in
            print("reqRes")
            print(result)
            requestWentThrough = true
            switch result {
            case "Active":
                self.hbFeedback = "You are active presenter!"
            case "Not active":
                self.hbFeedback = "You are not active presenter"
            case "Presenter not found":
                self.hbFeedback = "You are connected, but user not found"
            default:
                self.hbFeedback = "You are not connected"
            }
        }
        if !requestWentThrough {
            self.hbFeedback = "You are not connected"
        }
        return
    }
    func prev() -> Void {
        if self.url == nil {
            print("url not set")
            return
        }
        if self.username == nil {
            print("username not set")
            return
        }
        guard let prevUrl = URL(string: (self.url! + "/" + self.username! + "/prev"))
        else {
            print("ERR PREV")
            return
        };
        sendRequest(url: prevUrl) { result in
            print("prev result:")
            print(result)
        }
    }
    
    func next() -> Void {
        if self.url == nil {
            print("url not set")
            return
        }
        if self.username == nil {
            print("username not set")
            return
        }
        guard let hbUrl = URL(string: (self.url! + "/" + self.username! + "/next"))
        else {
            print("ERR NEXT")
            return
        };
        sendRequest(url: hbUrl) { result in
            print("next result:")
            print(result)
        }
    }
    
}
    

