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
        ZStack(){
//            Rectangle()
//                .padding(16)
//                .background(RoundedRectangle(cornerRadius: 16).fill(Color.warmPurple))
            
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
                        Button {
                            selectedConstellation = constellation
                        } label : {
                            Text("\(constellation.name) [\(constellation.weight) stars]")
                                .font(.custom("CormorantInfant-SemiBold", size: 16))
                                .foregroundColor(Color.warmPurple)
                        }
                    }
                }
                .padding(16)
                .font(.custom("CormorantInfant-SemiBold", size: 16))
                .foregroundColor(Color.warmPurple)
                .frame(width: 240, height: 50)
                .background(RoundedRectangle(cornerRadius: 16).fill(Color.veryLightPurple))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.mediumOrchid, lineWidth: 2.8) // <-- This adds the border
                )
            }
            .task {
                // load when the view appears
                await loadConstellations()
            }
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

