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
    // restAPI.setUsername(username: "user1")
    // restAPI.setUrl(url: "http://192.168.0.111:10050/")
    
    var restAPI = PPTXRestAPI(url: "http://192.168.0.111:10050",
                              username: "user1")
    restAPI.setUsername(username: "user2")
    
    var body: some View {
        Text("Hello, stupid laggy world!")
            .padding()
        HStack(){
            Button("PrevSlide") {
                print("smth")
            }
            .buttonStyle(GrowingButton())
            //.controlSize(.large)
            Button("HB") {
                print(restAPI.hb())
            }
            .buttonStyle(GrowingButton())
            //.controlSize(.large)
            Button("NextSlide") {
                print(restAPI.next())
            }
            .buttonStyle(GrowingButton())
            //.controlSize(.large)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
