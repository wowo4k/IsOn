//
//  AppDelegate.swift
//  IsOn
//
//  Created by Armin WOWORSKY on 08.06.22.
//

import Foundation
import SwiftUI

import InfluxDBSwift
import InfluxDBSwiftApis

// MARK: Setting Up Menu Bar Icon and Menu Bar Popover area
class AppDelegate: NSObject,ObservableObject, NSApplicationDelegate {

    
    
    @Published var isCameraOn: Bool = false
    
    
    @Published var deviceName: String = "unkown"
    
    var isCameraOnPrev: Bool = false
    
    
    // MARK: Properties
    @Published var statusItem: NSStatusItem?
    @Published var popover = NSPopover()
    
    
    // INfluxDB Cloud Parameter
    var url = "https://eu-central-1-1.aws.cloud2.influxdata.com"
    var token = "UBW3UeRCmnt0-0cJBdDHEtND3AE8a34xxnhp8Jj5G_2N8FljRb_5BCQVsEaY_6AUu0jIqmCzrD1fatTZ4aGAww=="
    var bucket = "unkown"
    var org = "mrjerz@pm.me"
    var orgID = "ee725db6ff88f614"
    
    let retention: Int64 = 3600*24*30
    
    //var isOn: Bool = false
    let queue = DispatchQueue(label: "com.envoy.embassy-tests.http-server", attributes: [])
    //var loop: SelectorEventLoop!
    var session: URLSession!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        setUpMacMenu()
        
        if let deviceName = Host.current().localizedName {
            self.deviceName = deviceName
            self.bucket = "ison"
        }
        
        checkCreateBucket()
        
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
        
        if let menuButton = statusItem?.button{
            
            
//            if let image = NSImage(named: "Image") {
            
            
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
    
    
    func isCameraon(forceWrite: Bool) -> Bool {
        
        isCameraOn = IsOn.isCameraOn()
        if isCameraOn != isCameraOnPrev {
            
            print (" Camera change detected: \(isCameraOn)" )
            
            changeIcon ()
            writeInfluxDB()
            isCameraOnPrev = isCameraOn
            
            return true
            
        }
        else {
            
            if forceWrite {
                writeInfluxDB()
                return true
            }
            
        }
        
        return false
        
    }
    
    func checkCreateBucket() {
        
        // Initialize Client and API
        let client = InfluxDBClient(url: url, token: token)
        let api = InfluxDB2API(client: client)

        // Bucket configuration
        let request = PostBucketRequest(orgID: self.orgID
                                        , name: self.bucket, description: "Monitoring bucket for IsCamerOn", rp: "keine Ahnung", retentionRules: [RetentionRule(type: RetentionRule.ModelType.expire, everySeconds: self.retention)], schemaType: .implicit)

        // Create Bucket
        api.bucketsAPI.postBuckets(postBucketRequest: request) { bucket, error in
            // For error exit
            if let error = error {
                print(error.description)
                self.atExit(client: client, error: error)
            }

            if let bucket = bucket {
                // Create Authorization with permission to read/write created bucket
                let bucketResource = Resource(
                        type: Resource.ModelType.buckets,
                        id: bucket.id!,
                        orgID: self.orgID
                )
                
                
//                // Authorization configuration
//                let request = AuthorizationPostRequest(
//                        description: "Authorization to read/write bucket: \(self.bucket)",
//                        orgID: self.org,
//                        permissions: [
//                            Permission(action: Permission.Action.read, resource: bucketResource),
//                            Permission(action: Permission.Action.write, resource: bucketResource)
//                        ])
//
//                // Create Authorization
//                api.authorizationsAPI.postAuthorizations(authorizationPostRequest: request) { authorization, error in
//                    // For error exit
//                    if let error = error {
//                        self.atExit(client: client, error: error)
//                    }
//
//                    // Print token
//                    if let authorization = authorization {
//                        let token = authorization.token!
//                        print("The bucket: '\(bucket.name)' is successfully created.")
//                        print("The following token could be use to read/write:")
//                        print("\t\(token)")
//                        self.atExit(client: client)
//                    }
//                }
            }
        }

        
        
    }
 
    func writeInfluxDB() {
        
        // Initialize Client with default Bucket and Organization
        let client = InfluxDBClient(
                url: url,
                token: token,
                options: InfluxDBClient.InfluxDBOptions(bucket: self.bucket, org: self.org))
    
        //
        // Record defined as Data Point
        //
        let recordPoint = InfluxDBClient
                .Point("ison")
                .addTag(key: "machine", value: self.deviceName)
                //.addField(key: "value", value: .int(2))
                .addField(key: "isCameraOn", value: .boolean(self.isCameraOn) )
                .addField(key: "camera_on", value: .int(self.isCameraOn ? 1 : 0) )
        
                .addField(key: "isMicrophoneOn", value: .boolean(self.isCameraOn) )
                .addField(key: "microphone_on", value: .int(self.isCameraOn ? 1 : 0) )
        
        
        
        
        
        client.makeWriteAPI().write(points: [recordPoint]) { result, error in
            // For handle error
            if let error = error {
                self.atExit(client: client, error: error)
            }

            // For Success write
            if result != nil {
                print("Written data:\n\n\([recordPoint].map { "\t- \($0)" }.joined(separator: "\n"))")
                print("\nSuccess!")
            }

            self.atExit(client: client)
        }

    }

    private func atExit(client: InfluxDBClient, error: InfluxDBClient.InfluxDBError? = nil) {
        // Dispose the Client
        client.close()
    }
    
    
    
    //Preference Mgmt
    func savePreferences() {
        
        print("savePreferences")
    }
}


