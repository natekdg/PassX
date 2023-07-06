import SwiftUI

struct PasscodeGeneratorView: View {
    @State private var passcode: String = "" // declare for passcode
    @State private var useLongPasscode: Bool = false // declare for 20 character option
    @State private var clearPasscode: Bool = false // declare for clearing passcode when the switch is activated
    @State private var isButtonAnimating: Bool = false // declare animation for password generation button
    @State private var isPasscodeAnimating: Bool = false // declare animation for passcode that is generated
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 16) {
                    List {
                        Section(header: Text("Options").font(.headline).fontWeight(.regular).foregroundColor(.orange)) {
                            OptionsView(useLongPasscode: $useLongPasscode, clearPasscode: $clearPasscode, passcode: $passcode) // options grid
                        }
                    }
                    .listStyle(PlainListStyle()) // plain list style (minimal)
                    
                    VStack { // Wrap the text and passcode in a VStack
                        Text("Your Passcode")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)
                            .frame(height: 29.0) // fixed height
                            .padding(.bottom, 16) // bottom padding
                        
                        Text(passcode) //generated passsword text
                            .font(.title)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.bottom, 6.0)
                            .frame(width: /*@START_MENU_TOKEN@*/400.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/)
                            .background(Color.black)
                            .cornerRadius(0)
                            .scaleEffect(isPasscodeAnimating ? 0.8 : 0.9)
                            .animation(.easeInOut(duration: 0.25))
                    }
                    
                    Button(action: {
                        generatePasscode() // actions for button
                        animateButton()
                    }) {
                        Text("Generate") // button ui
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.orange)
                            .cornerRadius(8)
                    }
                    .scaleEffect(isButtonAnimating ? 0.9 : 1.0) // button animation
                    .animation(.spring())
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16) // Use RoundedRectangle as the background
                        .fill(Color.black)
                )
            }
            .background(Color.black)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
    
    private func generatePasscode() {
        let passcodeLength: Int = useLongPasscode ? 20 : 10
        let characters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" // Characters able to be used in password generation
        let passcode = String((0..<passcodeLength).map { _ in characters.randomElement()! })
        self.passcode = passcode
        
        // Trigger the passcode generation animation
        isPasscodeAnimating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isPasscodeAnimating = false
        }
    }
    
    private func animateButton() {
        isButtonAnimating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isButtonAnimating = false
        }
    }
}

struct OptionsView: View {
    @Binding var useLongPasscode: Bool
    @Binding var clearPasscode: Bool
    @Binding var passcode: String
    
    var body: some View {
        Toggle(isOn: $useLongPasscode) {
            Text("20 Characters")
                .font(.title)
                .foregroundColor(.orange)
        }
        .toggleStyle(SwitchToggleStyle(tint: .orange))
        .onChange(of: useLongPasscode) { newValue in
            clearPasscode = true
        }
        .onChange(of: clearPasscode) { newValue in
            if newValue {
                passcode = ""
                clearPasscode = false
            }
        }
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
