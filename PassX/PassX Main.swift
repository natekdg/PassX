import SwiftUI
import UIKit
import UniformTypeIdentifiers


struct PasscodeGeneratorView: View {
    @State private var passcode: String = ""            // declare for passcode
    @State private var useLongPasscode: Bool = false            // declare for 20 character option
    @State private var clearPasscode: Bool = false          // declare for clearing passcode when the switch is activated
    @State private var isButtonAnimating: Bool = false          // declare animation for password generation button
    @State private var isPasscodeAnimating: Bool = false            // declare animation for passcode that is generated
    @State private var savedPasswords: [String] = []
    @State private var showSavedPasswords: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 16) {
                    List {
                        Section(header: 
                            Text("Options")
                            .font(.custom("Helvetica.ttc", size: 25))
                            .fontWeight(.bold)
                            .foregroundColor(.white)) {
                            OptionsView(useLongPasscode: $useLongPasscode, clearPasscode: $clearPasscode, passcode: $passcode)          // options grid
                        }
                    }
                    .listStyle(PlainListStyle())            // plain list style (minimal)
                    
                    VStack {            // wrap the text and passcode in VStack
                        Text("Your Passcode")           // the text for "Your Passcode"
                            .font(.custom("Helvetica.ttc", size: 30))           // custom font from assets
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(height: 29.0)            // fixed height
                            .padding(.bottom, 16)           // bottom padding
                        
                        Text(passcode) //generated passsword text
                            .font(.custom("Helvetica.ttc", size: 23))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.bottom, 6.0)
                            .onTapGesture(count: 2) {
                                let clipboard = UIPasteboard.general
                                clipboard.setValue(passcode, forPasteboardType: UTType.plainText.identifier)        // function for copying the password
                            }
                            .frame(width: 398.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/92.0)
                            .background(Color.black)
                            .cornerRadius(0)
                            .animation(.easeInOut(duration: 0.35))          // animation for the generated password to fade in
                    }
                    
                    
                    HStack {
                        Button(action: {
                            showSavedPasswords.toggle()
                        }) {
                            Image(systemName: "list.bullet")
                                .font(.title)
                                .foregroundColor(.orange)
                                .foregroundColor(.orange)
                        }
                        .sheet(isPresented: $showSavedPasswords) {
                            SavedPasswordsView(savedPasswords: $savedPasswords)
                        }
                        
                        
                        
                        Spacer()
                            .frame(width: 61.0)
                        
                        Button(action: {
                            generatePasscode() // actions for button
                            animateButton()
                            savePasscode()
                        }) {
                            Text("Generate") // button UI
                                .font(.custom("Helvetica.ttc", size: 30))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 25)
                                .padding(.vertical, 15)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.teal, Color.purple]), startPoint: .leading, endPoint: .trailing))
                                .opacity(20) // Adjusted opacity value
                                .cornerRadius(15)
                        }
                        .padding(.trailing, 12.0) // This shifts the button to the left

                        Spacer()

                        
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
    }
        
        private func generatePasscode() {
            let passcodeLength: Int = useLongPasscode ? 20 : 10
            let characters = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!?@" // Characters able to be used in password generation
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                isButtonAnimating = false
            }
        }
        
        private func savePasscode() {
            savedPasswords.append(passcode)
        }
        
    }
    
    struct OptionsView: View {
        @Binding var useLongPasscode: Bool
        @Binding var clearPasscode: Bool
        @Binding var passcode: String
        
        var body: some View {
            Toggle(isOn: $useLongPasscode) {
                Text("20 Characters")
                    .font(.custom("Helvetica.ttc", size: 23))
                    .foregroundColor(.white)
            }
            .toggleStyle(SwitchToggleStyle(tint: .purple))
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

struct SavedPasswordsView: View {
    @Binding var savedPasswords: [String]

    var body: some View {
        NavigationView {
            List {
                
                ForEach(savedPasswords, id: \.self) { password in
                    Text(password)
                        .foregroundColor(.white)
                        .font(.custom("Helvetica.ttc", size: 16))
                        .listRowBackground(Color.black) // Sets the background of each list to be black
                }
                .onDelete(perform: deletePassword)
            }
            .listStyle(DefaultListStyle())
            .navigationBarTitle("Saved Passwords")
            .foregroundColor(.white)
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .foregroundColor(.orange)    }

    private func deletePassword(at offsets: IndexSet) {
        savedPasswords.remove(atOffsets: offsets)
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

