//
//  CountdownViewModel.swift
//  luminary-frontend
//
//  Created by Kaylee Ulep on 11/22/25.
//

import Foundation

class CountdownViewModel : ObservableObject {
    @Published var remainingMinutes: Int
    @Published var remainingSeconds: Int
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    init(totalMinutes: Int, totalSeconds: Int = 0) {
        self.remainingMinutes = totalMinutes
        self.remainingSeconds = totalSeconds
    }
}
