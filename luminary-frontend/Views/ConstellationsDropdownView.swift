//
//  ConstellationsDropdownView.swift
//  luminary-frontend
//
//  Created by Tyler on 12/4/25.
//


import SwiftUI

struct ConstellationsDropdownView: View {
    /// Parent controls/reads the selected constellation
    @Binding var selectedConstellation: Constellation

    @State private var constellations: [Constellation] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 12) {
            if isLoading {
                ProgressView("Loading constellations…")
                    .padding(.vertical, 8)
            }

            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            // Use server-backed list (fallback to current selection name if empty)
            Menu(constellations.isEmpty ? selectedConstellation.name : selectedConstellation.name) {
                ForEach(constellations, id: \.self) { constellation in
                    Button(constellation.name) {
                        selectedConstellation = constellation
                    }
                }
            }
            .padding(16)
            .foregroundStyle(Color.white)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.black))
        }
        .task {
            // load when the view appears
            await loadConstellations()
        }
    }

    @MainActor
    private func loadConstellations() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let serverConstellations = try await NetworkManager.shared.fetchAllConstellations()
            constellations = serverConstellations

            // Initialize the selected value if it hasn't been set yet
            if constellations.isEmpty == false && !constellations.contains(selectedConstellation) {
                selectedConstellation = constellations[0]
            }

            errorMessage = nil
        } catch {
            errorMessage = "Unable to load constellations."
            print("fetchAllConstellations error:", error)
        }
    }
}

