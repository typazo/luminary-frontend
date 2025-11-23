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
            
            
            NavigationLink("start timer",
                destination: CountdownView( vm: CountdownViewModel(totalMinutes: selectedMinutes, totalSeconds: selectedSeconds)
                )
            )
        }
    }
    
}

struct CountdownView : View {
    @StateObject private var vm: CountdownViewModel
    
    init(vm: CountdownViewModel){
        self._vm = StateObject(wrappedValue: vm)
    }
    
    var body : some View {
        VStack{
            Text("\(vm.remainingMinutes) minutes")
                .font(.system(size: 50, weight: .bold))
            Text("\(vm.remainingSeconds) seconds")
                .font(.system(size: 50, weight: .bold))
        }
        .frame(width: 200, height: 200)
        }
    }


struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        SetTimeView()
//        CountdownView()
    }
}
