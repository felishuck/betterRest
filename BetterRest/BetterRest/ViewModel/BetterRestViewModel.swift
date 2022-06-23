//
//  BetterRest.swift
//  TabViewTest
//
//  Created by Félix Tineo Ortega on 23/6/22.
//

import CoreML
import Foundation

class BetterRestViewModel: ObservableObject {
    @Published var stimatedSleep: Double = 8.0
    @Published var cupsOfCoffe: Int = 1
    @Published var wakeUp: Date = defaultWakeUp
    var timeToGoToBed: Date {
        whatTimeGoToBed(stimatedSleep: stimatedSleep, wakeUp: wakeUp, cupsOfCoffe: cupsOfCoffe)
    }
    @Published var isErrorAlertShown = false
    @Published var errorTitle = ""
    @Published var errorMessage = ""

    static var defaultWakeUp: Date {
        var dateComponets = DateComponents()
        dateComponets.hour = 7
        return Calendar.current.date(from: dateComponets) ?? Date.now
    }
    
    func whatTimeGoToBed(stimatedSleep: Double, wakeUp: Date, cupsOfCoffe: Int)->Date{
        
        var resultDate = Date.now
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hoursInSeconds = (components.hour ?? 0 ) * 3600
        let minutesInSeconds = (components.minute ?? 0) * 60
        
        do{
            let configuration = MLModelConfiguration()
            let stimateRest = try RestCalculator(configuration: configuration)
            let prediction = try stimateRest.prediction(wake: Double(hoursInSeconds + minutesInSeconds), estimatedSleep: stimatedSleep, coffee: Double(cupsOfCoffe))
            
            resultDate = wakeUp - prediction.actualSleep
            
        } catch {
            errorTitle = "Error"
            errorMessage = "Ups! There was an error computing the time"
            isErrorAlertShown = true
        }
        
        return resultDate
}
}
