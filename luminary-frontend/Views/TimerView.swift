//
//  TimerView.swift
//  luminary-frontend
//
//  Created by Kaylee Ulep on 11/22/25.

//is it ok to have multiple views related to timer in here?
//
import SwiftUI

//
struct SetTimeView : View {
    //    @State private var selectedMinutes = 5
    //    @State private var selectedSeconds = 0
    @EnvironmentObject var sessionManager : SessionManager
    
    var body : some View {
        NavigationStack{
            Text("Set timer duration")
            Picker("Minutes", selection: $sessionManager.remainingMinutes) {
                ForEach(1..<121, id: \.self) { Text("\($0) mins") }
            }
            .pickerStyle(.wheel)
            .clipped()
            
            Picker("Seconds", selection: $sessionManager.remainingSeconds) {
                ForEach(0..<60, id: \.self) { Text("\($0) sec") }
            }
            .pickerStyle(.wheel)
            .clipped()
            
            
            //right now i don't want to have this button because it adds an unnecessary step to the stack!!
            //            NavigationLink(
            //                "Save timer timesss",
            //                destination: SessionStartView()
            //            )
            //        }
        }
        
    }
}
    struct CountdownView : View {
        //    @State private var remainingMinutes: Int
        //    @State private var remainingSeconds: Int
        @State private var timer: Timer? = nil
        @EnvironmentObject var sessionManager : SessionManager
        
        //    init(totalMinutes: Int, totalSeconds: Int = 0){
        //        remainingMinutes = totalMinutes
        //        remainingSeconds = totalSeconds
        //    }
        
        
        var body : some View {
            VStack{
                if (sessionManager.sessionActive){
                    VStack{
                        Text("\(sessionManager.remainingMinutes) minutes")
                            .font(.system(size: 25, weight: .bold))
                        Text("\(sessionManager.remainingSeconds) seconds")
                            .font(.system(size: 25, weight: .bold))
                    }
                    .frame(width: 200, height: 200)
                    .onAppear {
                        startTimer()
                    }
                    .onDisappear {
                        timer?.invalidate()
                        timer = nil
                        //right now, we dont need to set it to fail and stuff because imagine what happens when you get out of the clock into the success screen?
                        //but i guess we should say timer is not active
                        
                        //but we do reset back to defaults
                        sessionManager.remainingMinutes = 5
                        sessionManager.remainingSeconds = 0
                        
                    }
                } else {
                    Text("No active session")
                }
            }
        }
        private func startTimer() {
            // prevent multiple timers
            guard timer == nil else { return }
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if sessionManager.remainingSeconds > 0 {
                    sessionManager.remainingSeconds -= 1
                } else if sessionManager.remainingMinutes > 0 {
                    sessionManager.remainingMinutes -= 1
                    sessionManager.remainingSeconds = 59
                } else {
                    print("timer finished")
                    timer?.invalidate()
                    timer = nil
                    //here, we should route to session finished view... right now we dont do that tho
                    //perhaps we call a different function that lets us go there bc idk how we would do that here
                    //ISSUE!! it repeatedly prints timer finished even after i leave
                    sessionManager.sessionActive = false
                }
            }
        }
    }


struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        SetTimeView()
    }
}
