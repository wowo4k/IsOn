//
//  IsOnApp.swift
//  IsOn
//
//  Created by ARMIN WOWORSKY on 04.06.22.
//

import SwiftUI

@main
struct IsOnApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

