//
//  Home.swift
//  IsOn
//
//  Created by ARMIN WOWORSKY on 04.06.22.
//

import SwiftUI
import Combine

struct Home: View {
    
    @EnvironmentObject var data: AppDelegate
    
    @State var secondsElapsed = 0
    @State var timer: Timer.TimerPublisher = Timer.publish(every: 5, on: .main, in: .common)
    @State var connectedTimer: Cancellable? = nil
    
    @State var currentTab: String = "IsOn"
    @Namespace var animation
    
    @State var showPreferences: Bool = false
    
    var body: some View {
        VStack {
            CustomSegmentedControl()
                .padding()
            
            
            if showPreferences {
                
                PreferenceView()

            }
            else {
                if currentTab == "IsOn" {
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 10){
                            
                            VStack(spacing: 8){
                                CardView(text: "Is Camera On:", symbol: "camera.on.rectangle.fill", isOn: data.isCameraOn)
                                CardView(text: "Is Micro On:", symbol: "waveform.and.mic", isOn: false)
                                
                                //Divider()
                            }
                            .padding(.horizontal)
                            .padding(.vertical,8)

                        }
                    }
                    
                        
                }
                else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 10){
                            
                            VStack(spacing: 8){
                                Text("About")
                            }
                            .padding(.horizontal)
                            .padding(.vertical,8)

                        }
                    }
                }
  
            }
            
            
            
            Spacer()
            HStack{
                Button {
                    showPreferences.toggle()
 
                } label: {
                    Image(systemName: "gearshape.fill")
                }

                Spacer()
                
                Button {
                    NSApplication.shared.terminate(self)
                    
                } label: {
                    Image(systemName: "power")
                }
            }
            .padding(.horizontal)
            .padding(.vertical,10)
            .background{Color.black}
        }
        .frame(width: 320, height: 450)
        .background{Color("BG")}
        .preferredColorScheme(.dark)
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    func CardView(text: String, symbol: String, isOn: Bool)->some View {
        
        HStack(spacing: 0) {
            
                Text(text)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(6)
                    
            Image(systemName: "camera.on.rectangle.fill")
                .foregroundColor(isOn ? .red : .gray)
                .imageScale(.large)
                .padding(6)
            
            
        }
        .padding(10)
        .background{
            Color.gray.opacity(0.5)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
    }
   
    @ViewBuilder
    func PreferenceView()->some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 10){
                
                VStack(spacing: 8){
                    
                    Text("InfluxDB")

                    VStack(alignment: .leading) {
                        Text("url")
                        TextEditor(text: $data.url)
                            .navigationTitle("url")
                            .background(Color.clear)
                            //.textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading) {
                        Text("API token")
                        TextEditor(text: $data.token)
                            .navigationTitle("token")
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                    }
                    
                    VStack(alignment: .leading) {
                        Text("bucket")
                        TextEditor(text: $data.bucket)
                            .navigationTitle("bucket")
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                    }
                    
                    VStack(alignment: .leading) {
                        Text("org")
                        TextEditor(text: $data.org)
                            .navigationTitle("org")
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                    }
                    
                    VStack(alignment: .center) {
                        
                        Button {
                            data.savePreferences()
                        } label: {
                            Text("Save")
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical,8)
                .font(.body)

            }
        }
        .onAppear {
            print("showing Preference View!!")
        }
        .onDisappear {
            print("hidding Preference View!!")
        }
    }
    
    
    // MARK: Custom Segmented Control
    @ViewBuilder
    func CustomSegmentedControl()->some View{
        HStack(spacing: 0) {
            ForEach(["IsOn","About"],id: \.self){tab in
                Text(tab)
                    .fontWeight(currentTab == tab ? .semibold : .regular)
                    .foregroundColor(currentTab == tab ? .white : .gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical,6)
                    .background(content: {
                        if currentTab == tab{
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color("Tab"))
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            }
                    })

                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation{
                            currentTab = tab
                        }
                        self.showPreferences = false
                    }
            }
        }
        .padding(2)
        .background{
            Color.black
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
