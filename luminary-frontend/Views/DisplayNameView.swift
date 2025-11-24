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
            Text("Enter your display name")
                .font(.headline)

            TextField("Display Name", text: $inputName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .focused($nameFieldIsFocused)
                .submitLabel(.done)
                .onSubmit {
                    saveName()
                }

            Button("Continue") {
                saveName()
            }
            .disabled(inputName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
    }
    @MainActor
    private func saveName() {
        // Dismiss the keyboard first
        nameFieldIsFocused = false

        let trimmed = inputName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            print("DisplayNameView: Attempted save with empty name")
            return
        }

        // Save to UserSettings and UserDefaults
        DispatchQueue.main.async {
            self.settings.displayName = trimmed
            print("DisplayNameView: Set displayName to '\(trimmed)'")
        }

    }
}
