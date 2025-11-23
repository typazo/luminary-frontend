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
    @State private var selectedMinutes = 5
    @State private var selectedSeconds = 0
    
    var body : some View {
        NavigationStack{
            Text("Set timer duration")
            Picker("Minutes", selection: $selectedMinutes) {
                ForEach(1..<121, id: \.self) { Text("\($0) mins") }
            }
            .pickerStyle(.wheel)
            .frame(width: 100)
            .clipped()
            
            
//            NavigationLink(
//                "Start Timer",
//                destination: CountdownView(
//                    totalMinutes: selectedMinutes,
//                    totalSeconds: selectedSeconds
//                )
//            )
            
            NavigationLink(
                "Save timer timesss",
                destination: SessionStartView(minutes: selectedMinutes, seconds: selectedSeconds)
            )
        }
    }
    
}



struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        SetTimeView()
//        CountdownView()
    }
}
