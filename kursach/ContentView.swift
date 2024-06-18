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
    
    @State var urlInput = DefaultsHandler.getUrl()
    @State var usernameInput = DefaultsHandler.getUsername()
    
    init() {
        restAPI = PPTXRestAPI(
            url: DefaultsHandler.getUrl(),
            username: DefaultsHandler.getUsername()
        )
    }
    
    var body: some View {
        VStack(){
            TextField(
                "URL",
                text: $urlInput,
                onCommit: {
                    restAPI.setUrl(url: urlInput)
                    DefaultsHandler.setUrl(value: urlInput)
                }
            ).padding()
            TextField(
                "Username",
                text: $usernameInput,
                onCommit: {
                    restAPI.setUsername(username: usernameInput)
                    DefaultsHandler.setUsername(value: usernameInput)
                }
            ).padding()
        }
        .padding([.bottom], 30)
        HStack(){
            Button("PrevSlide") {
                print(restAPI.prev())
            }
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
