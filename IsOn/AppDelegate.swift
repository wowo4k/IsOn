//
//  AppDelegate.swift
//  IsOn
//
//  Created by Armin WOWORSKY on 08.06.22.
//

import Foundation
import SwiftUI

import Foundation
import Embassy
import Telegraph

// MARK: Setting Up Menu Bar Icon and Menu Bar Popover area
class AppDelegate: NSObject,ObservableObject, NSApplicationDelegate {

    
    
    @Published var isCameraOn: Bool = false
    
    // MARK: Properties
    @Published var statusItem: NSStatusItem?
    @Published var popover = NSPopover()
    
    //var isOn: Bool = false
    let queue = DispatchQueue(label: "com.envoy.embassy-tests.http-server", attributes: [])
    //var loop: SelectorEventLoop!
    var session: URLSession!
    
    var demo: TelegraphDemo!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        setUpMacMenu()
        initServer()
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
 
    func initServer() {
        
//        demo = TelegraphDemo()
//        demo.start()
        
        let loop = try! SelectorEventLoop(selector: try! SelectSelector())
        let server = DefaultHTTPServer(eventLoop: loop, port: 9080) {
            (
                environ: [String: Any],
                startResponse: ((String, [(String, String)]) -> Void),
                sendBody: ((Data) -> Void)
            ) in
            // Start HTTP response
            startResponse("200 OK", [])
            let pathInfo = environ["PATH_INFO"]! as! String
            sendBody(Data("the path you're visiting is \(pathInfo.debugDescription)".utf8))
            // send EOF
            sendBody(Data())
        }

        // Start HTTP server to listen on the port
        try! server.start()

        print("Server running at localhost:8080")

        // Run event loop
        loop.runForever()
        
    }
}


