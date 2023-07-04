//
//  ContentView.swift
//  PassX
//
//  Created by nate on 7/3/23.
//

import SwiftUI

struct PasscodeGeneratorView: View {
    @State private var passcode: String = ""    //  line declares a state property called 'passcode'
    @State private var useLongPasscode: Bool = false    //  declares the state of the toggle switch for generating a long passcode (always set off)
        @State private var clearPasscode: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Your Passcode")
                .font(.largeTitle)
                .foregroundColor(.orange)
            
            Text(passcode)
                .font(.system(size: useLongPasscode ? 23 : 23))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .background(Color.black)
                .cornerRadius(8)
            
            Toggle(isOn: $useLongPasscode) {
                Text("Use 20 Characters")
                    .font(.title)
                    .foregroundColor(.white)
            }
            .toggleStyle(SwitchToggleStyle(tint: .orange))
            
            Button(action: generatePasscode) {
                Text("Generate")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.orange)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .onChange(of: useLongPasscode) { newValue in
            clearPasscode = newValue
        }
        .onChange(of: clearPasscode) { newValue in
            if newValue {
                passcode = ""
                clearPasscode = false
            }
        }
    }
    //password generation fuction
    private func generatePasscode() {
        let passcodeLength: Int = useLongPasscode ? 20 : 10
        let characters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        let passcode = String((0..<passcodeLength).map { _ in characters.randomElement()! })
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
