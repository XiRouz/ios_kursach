//
//  ContentView.swift
//  kursach
//
//  Created by semyon on 6/8/24.
//

import SwiftUI

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            //.foregroundStyle(Color.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ContentView: View {
    @ObservedObject var restAPI : PPTXRestAPI
    
    var feedback = ""
    
    let queue = DispatchQueue.global(qos: .background)
    
    var hbTimer: Timer?
    
//    @State var errFeedback: String = "-"
    
    init() {
        restAPI = PPTXRestAPI(url: "http://192.168.0.111:10050",
                                  username: "user1")
        // restAPI.setUsername(username: "user1")
        // restAPI.setUrl(url: "http://192.168.0.111:10050/")
        
//        errFeedback = restAPI.errFeedback ?? "--"
    }
    
    var body: some View {
        HStack(){
            Button("PrevSlide") {
                print("smth")
                restAPI.setUsername(un: "user2")
            }
            .buttonStyle(GrowingButton())
            //.controlSize(.large)
            .buttonStyle(GrowingButton())
            //.controlSize(.large)
            Button("NextSlide") {
                print(restAPI.next())
            }
            .buttonStyle(GrowingButton())
            //.controlSize(.large)
        }
        HStack() {
            Text(restAPI.errFeedback)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
