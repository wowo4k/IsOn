//
//  ContentView.swift
//  IsOn
//
//  Created by ARMIN WOWORSKY on 04.06.22.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @EnvironmentObject var data: AppDelegate
    
    @State var secondsElapsed = 0
    @State var runCounter = 0
    @State var timer: Timer.TimerPublisher = Timer.publish(every: 1, on: .main, in: .common)
    @State var connectedTimer: Cancellable? = nil
   
    var body: some View {
        VStack () {
            Text("IsOn!!")
        }.onAppear {
            self.instantiateTimer()
            
            
            
        }.onDisappear {
            self.cancelTimer()
        }.onReceive(timer) { _ in
            
            //print("Timer Event!!")
            self.secondsElapsed += 1
            self.runCounter += 1
            
            if self.runCounter >= 30 {
                
                print("ForceWrite \(runCounter)")
                if data.isCameraon(forceWrite: true) {
                    self.runCounter = 0
                }
                
            }
            else {
                print("Non ForceWrite \(runCounter)")
                if data.isCameraon(forceWrite: false) {
                    self.runCounter = 0
                }
            }
        }
    }
    
    
    func instantiateTimer() {
        
        print("ContentView instantiateTimer")
        self.timer = Timer.publish(every: 1, on: .main, in: .common)
        self.connectedTimer = self.timer.connect()
        return
    }
    
    func cancelTimer() {
        print("ContentView cancelTimer")
        self.connectedTimer?.cancel()
        return
    }
    
    func resetCounter() {
        print("ContentView resetCounter")
        self.secondsElapsed = 0
        return
    }
    
    func restartTimer() {
        print("ContentView restartTimer")
        self.secondsElapsed = 0
        self.cancelTimer()
        self.instantiateTimer()
        return
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
