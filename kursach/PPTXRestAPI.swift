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
    @Published var errFeedback: String = "init"
    
    var queue = DispatchQueue.global(qos: .background)
    var hbTimer: Timer?
    
    func setUsername(un: String) -> Void {
        self.username = un
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
            let hbResult = self.hb()
            print("hbResult:")
            print(hbResult)
            
            switch hbResult {
            case "Active":
                self.errFeedback = "Green"
            case "Not active":
                self.errFeedback = "Yellow"
            case ("Presenter not found"):
                self.errFeedback = "Red"
            default:
                self.errFeedback = "Black"
            }
            print(self.errFeedback)
        }
        
        self.queue.async {
            RunLoop.current.add(self.hbTimer!, forMode: RunLoop.Mode.default)
            RunLoop.current.run()
        }
    }
    
    func sendRequest(url: URL) -> String? {
        var result = ""
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error as Any)
                return
            }
//            print("data:")
//            print(data)
//            print("response:")
//            print(response!)
            
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
        print("return result")
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
        let requestResult = sendRequest(url: hbUrl) ?? "ERR HB RESULT"
        print("reqRes")
        print(requestResult)
        return requestResult
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
