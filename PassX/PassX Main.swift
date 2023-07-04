//
//  ContentView.swift
//  PassX
//
//  Created by nate on 7/3/23.
//

import SwiftUI

struct PasscodeGeneratorView: View {
    @State private var passcode: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            Text(passcode)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            //generate passcode button
            Button(action: generatePasscode) {
                Text("Generate Secure Passcode")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.black)
        .onAppear {
            generatePasscode()
        }
    }
    
    //password generation fuction
    private func generatePasscode() {
        let characters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        let passcode = String((0..<10).map { _ in characters.randomElement()! })
        self.passcode = passcode
    }
}

struct ContentView: View {
    var body: some View {
        PasscodeGeneratorView()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
