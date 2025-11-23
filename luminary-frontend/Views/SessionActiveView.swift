//
//  SessionActiveView.swift
//  luminary-frontend
//
//  Created by Kaylee Ulep on 11/22/25.
//
//  A view for showing the current session.
//

import Foundation
import SwiftUI

struct CountdownView : View {
    @State private var remainingMinutes: Int
    @State private var remainingSeconds: Int
    @State private var timer: Timer? = nil
    @StateObject var sessionManager = SessionManager.shared
    
    //    @StateObject private var vm: CountdownViewModel
    
//    init(vm: CountdownViewModel){
////        self._vm = StateObject(wrappedValue: vm)
//    }
    
    init(totalMinutes: Int, totalSeconds: Int = 0){
        remainingMinutes = totalMinutes
        remainingSeconds = totalSeconds
    }
    
    var body : some View {
        VStack{
            if (sessionManager.sessionActive){
                VStack{
                    Text("\(remainingMinutes) minutes")
                        .font(.system(size: 25, weight: .bold))
                    Text("\(remainingSeconds) seconds")
                        .font(.system(size: 25, weight: .bold))
                }
                .frame(width: 200, height: 200)
                .onAppear {
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){
                        timer in
                        if remainingSeconds > 0 {
                            remainingSeconds -= 1
                        } else if remainingMinutes > 0 {
                            remainingMinutes -= 1
                            remainingSeconds = 59
                        } else {
                            // Timer finished
                            print("timer finished")
                            //here, we should route to session finished view... right now we dont do that tho
                            //perhaps we call a different function that lets us go there bc idk how we would do that here
                            //ISSUE!! it repeatedly prints timer finished even after i leave
                        }
                    }
                }
                Button("Cancel"){
                    
                }
            } else {
                Text("No active session")
            }
        }
    }
}
