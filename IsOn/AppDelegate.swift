//
//  AppDelegate.swift
//  IsOn
//
//  Created by Armin WOWORSKY on 08.06.22.
//

import Foundation
import SwiftUI

// MARK: Setting Up Menu Bar Icon and Menu Bar Popover area
class AppDelegate: NSObject,ObservableObject, NSApplicationDelegate {
    
    @Published var isCameraOn: Bool = false
    
    // MARK: Properties
    @Published var statusItem: NSStatusItem?
    @Published var popover = NSPopover()
    
    //var isOn: Bool = false
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setUpMacMenu()
    }
    
    func setUpMacMenu(){
        // MARK: Popover Properties
        popover.animates = true
        popover.behavior = .transient
        
        // MARK: Linking SwiftUI View
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = NSHostingView(rootView: Home().environmentObject(self))
        
        // MARK: Making it as Key Window
        popover.contentViewController?.view.window?.makeKey()
        
        // MARK: Setting Menu Bar Icon and Action
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        changeIcon ()
//        if let menuButton = statusItem?.button{
//            menuButton.image = .init(systemSymbolName: "dollarsign.circle.fill", accessibilityDescription: nil)
//            menuButton.action = #selector(menuButtonAction(sender:))
//        }
    }
    
    @objc func menuButtonAction(sender: AnyObject){
        // MARK: Showing/Closing Popover
        if popover.isShown{
            popover.performClose(sender)
        }
        else{
            if let menuButton = statusItem?.button{
                popover.show(relativeTo: menuButton.bounds, of: menuButton, preferredEdge: .minY)
            }
        }
    }
    
    @objc func changeIcon () {
        
        //isOn.toggle()
        
        if let menuButton = statusItem?.button{
            
            
            if let image = NSImage(systemSymbolName: isCameraOn ? "camera.on.rectangle.fill" : "camera.on.rectangle.fill",
                                   accessibilityDescription: "A multiply symbol inside a filled circle.") {
                    
                var config1 = NSImage.SymbolConfiguration(textStyle: .body,scale: .large)
                config1 = config1.applying(.init(paletteColors: [.systemGray, .systemGray]))
                
                var config2 = NSImage.SymbolConfiguration(textStyle: .body,scale: .large)
                config2 = config2.applying(.init(paletteColors: [.systemRed, .systemRed]))
                
                menuButton.image = image.withSymbolConfiguration(isCameraOn ? config2 : config1)
                
            }

            menuButton.action = #selector(menuButtonAction(sender:))
        }
        
    }
    
    
    func isCameraon() {
        
        isCameraOn = IsOn.isCameraOn()
        changeIcon ()
        
        print (" Camera is: \(isCameraOn)" )
    }
    
}
