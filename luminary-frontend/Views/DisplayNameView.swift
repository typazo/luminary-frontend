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
                    Task { await saveName() }
                }

            Button("Continue") {
                Task { await saveName() }
            }
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
