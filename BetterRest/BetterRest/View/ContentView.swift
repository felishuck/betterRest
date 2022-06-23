//
//  ContentView.swift
//  TabViewTest
//
//  Created by Félix Tineo Ortega on 30/5/22.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject private var viewModel = BetterRestViewModel()
    
    var body: some View {
        NavigationView {
            Form{
                
                Section(header: Text("When do you want to wake up?")) {
                    DatePicker("When you want to wake up?", selection: $viewModel.wakeUp, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                }
                
                Section (header: Text("How many hours of sleep?")) {
                    Stepper("\(viewModel.stimatedSleep.formatted()) hours", value: $viewModel.stimatedSleep, in: 4...12, step: 0.25)
                }

                Section(header: Text("How many cups of coffe?")){
                    Picker("\(viewModel.cupsOfCoffe == 1 ? "Cup" : "Cups")", selection: $viewModel.cupsOfCoffe) {
                        ForEach(1..<21, id: \.self){ numberOfCups in
                            Text("\(numberOfCups)")
                        }
                    }
                }
                
                Section(header: Text("Your ideal bed time is")){
                    HStack {
                        Spacer()
                        Text("\(viewModel.timeToGoToBed.formatted(date: .omitted, time: .shortened))")
                            .font(.largeTitle)
                        Spacer()
                    }
                }
                
            }.navigationTitle("Better Rest")
                .alert(viewModel.errorTitle, isPresented: $viewModel.isErrorAlertShown) {
                    Button("Ok") {}
                } message: {
                    Text(viewModel.errorMessage)
                }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
