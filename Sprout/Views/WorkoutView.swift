//
//  WorkoutView.swift
//  Test
//
//  Created by Neal Ahuja (student LM) on 2/19/25.
//

import SwiftUI

struct WorkoutView: View {
    //    @Binding var w: Workout
    @ObservedObject var w: Workout
    @State private var showingAddWorkout = false
    @State private var showingHistoryView = false
    @State private var selectedHistoryEntry:     WorkoutHistoryEntry?
    @State private var showingHistoryDetail = false
    @Binding var workoutHistory: [WorkoutHistoryEntry]
//    var sampleHistory: [WorkoutHistoryEntry] {
//        [WorkoutHistoryEntry(date: Date().addingTimeInterval(-86400), workout: Workout(name: w.name, cat: w.cat, set: w.set, rep: w.rep, weight: w.weight)),
//         WorkoutHistoryEntry(date: Date().addingTimeInterval(-172800), workout: Workout(name: w.name, cat: w.cat, set: w.set, rep: w.rep, weight: w.weight))]
//    }
    
    
    
    
    var body: some View {
        VStack{
            VStack{
                
                ZStack{
                    
                    Text(w.cat)
                        .font(.title)
                        .bold()
                        .foregroundColor(.green)
                    
                    
                    //                HStack{
                    //                    Text("Back")
                    //                        .padding()
                    //                        .font(.caption)
                    //                        .bold()
                    //                        .foregroundColor(.black)
                    //                        .padding(-10)
                    //                        .background(Color.green)
                    //                        .cornerRadius(7)
                    //                        .padding(.horizontal)
                    //                    Spacer()
                    //                    Text("History")
                    //                        .padding()
                    //                        .font(.caption)
                    //                        .bold()
                    //                        .foregroundColor(.black)
                    //                        .padding(-10)
                    //                        .background(Color.green)
                    //                        .cornerRadius(7)
                    //                        .padding(.horizontal)
                    //
                    //                }
                    
                    
                }
                Spacer()
                
                HStack {
                    
                    Button(action: {
                        if w.set > 1 {
                            w.set -= 1
                            //                        w.rep.removeLast()
                            //                        w.weight.removeLast()
                            w.weight[w.weight.count - 1] = 0
                            
                        }
                        
                    }){
                        Image(systemName: "minus")
                            .foregroundColor(.red)
                    } .padding(.horizontal)
                    
                    
                    
                    Spacer()
                    Text(w.name.uppercased())
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    Button(action: {
                        if (w.set < 7) {
                            w.set += 1
                            w.rep.append(0)
                            w.weight.append(0)
                        }
                    }){
                        Image(systemName: "plus")
                            .foregroundColor(.green)
                    } .padding(.horizontal)
                }
                
                Rectangle()
                    .fill(Color.green)
                    .frame(height: 5)
                    .padding(.horizontal)
                
                
                
                HStack (alignment: .center){
                    Spacer()
                    Text("Weight")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .bold()
                    Spacer()
                    Text("Reps")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .bold()
                    Spacer()
                    
                }
                
                ForEach(0..<w.set, id:\.self) { i in
                    HStack (alignment: .center){
                        Spacer()
                        if (w.weight[i] != -5) {
                            TextField("0", text: Binding(
                                
                                get: { "\(w.weight[i])" },
                                set: { if let val = Int($0) { w.weight[i] = val } }
                                
                            ))
                            
                            .foregroundColor(.gray)
                            .frame(width: 50, alignment: .center)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                        }
                        
                        Spacer()
                        
                        TextField("0", text: Binding(
                            get: { "\(w.rep[i])" },
                            set: { if let val = Int($0) { w.rep[i] = val } }
                        ))
                        .foregroundColor(.gray)
                        .frame(width: 50)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        
                        Spacer()
                    }
                    
                    
                }
                
                
                HStack {
                    
                    Button(action: {
                        let newEntry = WorkoutHistoryEntry(
                            date: Date(),
                            workout: Workout(name: w.name, cat: w.cat, set:w.set, rep: w.rep, weight: w.weight))
                        workoutHistory.append(newEntry)
                    })  {
                        Text("Save")
                            .foregroundColor(.white)
                            .padding(.horizontal, 100)
                            .padding(.vertical, 3)
                            .background(Color.green)
                            .cornerRadius(7)
                            .padding()
                           
                        
                    }
              
                }
                Spacer()
            }
       
            Button(action: {
                showingHistoryView = true
            }) {
                VStack {
                    Image(systemName: "arrow.up")
                        .foregroundColor(.green)
                    Text("History")
                        .padding(4)
                        .font(.caption)
                        .bold()
                        .foregroundColor(.green)
                }
            }
        }
        
        
        
//        .sheet(isPresented: $showingHistoryView) {
//            WorkoutHistoryView(historyEntries: workoutHistory, onSelect: { (selected: WorkoutHistoryEntry) in
//                selectedHistoryEntry = selected
//                showingHistoryView = false
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    withAnimation { showingHistoryDetail = true }
//                }
//            })
//        }
        
        .sheet(isPresented: $showingHistoryView) {
            WorkoutHistoryView(historyEntries: workoutHistory)
        }


    }
}


//#Preview {
//    WorkoutView(w: Workout(name: "Bench Press", cat: "Push", set: 3, rep: [8, 10, 12], weight: [135, 145, 155]), workoutHistory: Binding<[WorkoutHistoryEntry]>)
//}

