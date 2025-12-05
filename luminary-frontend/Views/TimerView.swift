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
            ZStack{
                Image("star_bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea() // covers entire screen
                
                
                VStack(spacing: 40){
                    // -- the "set a timer" text"
                    ZStack{
                        Rectangle()
                            .fill(Color.warmPurple)
                            .frame(maxWidth: .infinity, maxHeight: 60)
                            .cornerRadius(5)
                            .padding(.top)
                            .opacity(0.6)
                        
                        Text("set a focus timer")
                            .font(.custom("CormorantInfant-SemiBold", size: 27))
                            .foregroundStyle(Color.amour)
                            .padding(.top)
                    }
                    .padding(.top, 150)
                
                    
                    Spacer()
                    
                    
                    
                    //the hours and minutes pickers
                    HStack{
                        VStack {
                            Text("hours")
                                .font(.custom("CormorantInfant-SemiBold", size: 25))
                                .foregroundColor(.white)
                            
                            Picker("Hours", selection: Binding(
                                get: { sessionManager.remainingHours },
                                set: { newValue in
                                    sessionManager.remainingHours = newValue
                                    sessionManager.totalHours = newValue   // ← store chosen value
                                    print("DEBUG — Hours selected: remaining=\(sessionManager.remainingHours), total=\(sessionManager.totalHours)")
                                }
                            )) {
                                // Allow up to 5 hours for the session
                                ForEach(0..<6, id: \.self) { hour in
                                    Text("\(hour) hr")
                                        .font(.custom("CormorantInfant-SemiBold", size: 22))
                                        .tag(hour)
                                        .foregroundColor(.white)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(width: 120, height: 180)
                            .clipped()
                            .labelsHidden()
                        }
                        
                        VStack {
                            Text("minutes")
                                .font(.custom("CormorantInfant-SemiBold", size: 25))
                                .foregroundColor(.white)
                            
                            Picker("Minutes", selection: Binding(
                                get: { sessionManager.remainingMinutes },
                                set: { newValue in
                                    sessionManager.remainingMinutes = newValue
                                    sessionManager.totalMinutes = newValue  // ← store chosen value
                                }
                            )) {
                                // Iterate through 0 to 120 minutes (up to 2 hours)
                                ForEach(1..<60, id: \.self) { minute in
                                    Text("\(minute) min")
                                        .font(.custom("CormorantInfant-SemiBold", size: 22))
                                        .tag(minute)
                                        .foregroundColor(.white)
                                }
                            }
                            .pickerStyle(.wheel)
                            // Adjusted frame width to look good when centered
                            .frame(width: 150, height: 180)
                            .clipped()
                            .labelsHidden()
                        }
                    }
                    .padding(.bottom, 320)
                    
                }
                
                   
                
                

            }
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
        
        
        /// Called when countdown reaches zero
        let onCompleted: () -> Void

        
        init(onCompleted: @escaping () -> Void) {
                self.onCompleted = onCompleted
            }
        
        
        var body : some View {
            VStack{
                if (sessionManager.sessionActive){
                    VStack{
                        Text(String(format: "%02d:%02d:%02d",
                                    max(0, sessionManager.remainingHours),
                                    max(0, sessionManager.remainingMinutes),
                                    max(0, sessionManager.remainingSeconds)))
                            .font(.custom("CormorantInfant-SemiBold", size: 50))
                                    .foregroundStyle(Color.warmPurple)
                    }
                    .frame(width: 200, height: 200)
                    .onAppear {
                        startTimer()
                    }
                    .onDisappear {
                        timer?.invalidate()
                        timer = nil
                        sessionManager.sessionActive = false
                        
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
                    if sessionManager.remainingHours == 0 &&
                       sessionManager.remainingMinutes == 0 &&
                       sessionManager.remainingSeconds == 0 {
                        // finished
                        timer?.invalidate()
                        timer = nil
                        onCompleted()
                        return
                    }

                    if sessionManager.remainingSeconds > 0 {
                        sessionManager.remainingSeconds -= 1
                    } else {
                        // seconds == 0
                        if sessionManager.remainingMinutes > 0 {
                            sessionManager.remainingMinutes -= 1
                            sessionManager.remainingSeconds = 59
                        } else if sessionManager.remainingHours > 0 {
                            sessionManager.remainingHours -= 1
                            sessionManager.remainingMinutes = 59
                            sessionManager.remainingSeconds = 59
                        }
                    }
                }
        }
    }


struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        SetTimeView()
            .environmentObject(SessionManager())
    }
}
