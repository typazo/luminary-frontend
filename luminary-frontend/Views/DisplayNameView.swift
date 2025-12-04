//
//  DisplayNameView.swift
//  luminary-frontend
//
//  Created by Tyler on 11/23/25.
//

import SwiftUI


struct DisplayNameView: View {
    @State private var inputName = ""
    @FocusState private var nameFieldIsFocused: Bool
    @EnvironmentObject var settings: UserSettings

    var body: some View {
        VStack(spacing: 20) {
            Text("create display name")
                .font(.custom("CormorantInfant-SemiBold", size: 26.31))
                .foregroundColor(.veryLightPurple)
                .padding(.bottom, 25)

            TextField("what's the name of your galaxy?", text: $inputName)
                .font(.custom("CormorantInfant-SemiBold", size: 14.07))
                .foregroundColor(.warmPurple) //must fix color
                .frame(width: 253.33, height: 92.33)
                .padding(.horizontal, 20)
                .padding(.bottom, 25)
                .background(Color(hex: 0xF8CDFB))
//                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textFieldStyle(.plain)
                .cornerRadius(10)
//                .padding()
                .focused($nameFieldIsFocused)
                .submitLabel(.done)
                .onSubmit {
                    Task { await saveName() }
                }
            
            Spacer().frame(height: 27) //for padding
            
            
            Button {
                Task { await saveName() }
            } label: {
                ZStack {
                    // --- IMAGE BACKGROUND ---
                    Image("start_button") // Replace with your actual image asset name
                        .resizable()
                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 253.33, height: 92.33) // Match your TextField's size, or adjust as needed
                    
                    // --- TEXT CONTENT ---
                    Text("start your journey")
                        .font(.custom("CormorantInfant-SemiBold", size: 21.31))
                        // Set the text color to ensure visibility over the image
                        .foregroundColor(.veryLightPurple) // Choose a color that stands out against the image
                }
                
            }
            .frame(width: 184.51, height: 51.11)
            
            .disabled(inputName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
        
    }

    @MainActor
    private func saveName() async {
        nameFieldIsFocused = false
        let trimmed = inputName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            print("DisplayNameView: Attempted save with empty name")
            return
        }

        do {
            let user = try await NetworkManager.shared.ensureUserExists(using: settings, fallbackDisplayName: trimmed)
            print("DisplayNameView: Created or found user → \(user)")
        } catch {
            print("DisplayNameView: Failed to create/find user → \(error)")
        }
    }
}

struct DisplayNameView_Previews: PreviewProvider {
    static var previews: some View {
        DisplayNameView()
    }
}
