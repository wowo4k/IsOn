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
    
    var body: some View {
        VStack {
            CustomSegmentedControl()
                .padding()
            
            
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
                HStack {
                    Text("About!")

                }
            }
        
            
            
            Spacer()
            HStack{
                Button {
                    
                    //data.changeIcon()
 
                } label: {
                    Image(systemName: "gearshape.fill")
                }

                Spacer()
                
                Button {
                    
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
//        .background(content: {
//            RoundedRectangle(cornerRadius: 8, style: .continuous)
//                .fill(Color.gray.opacity(0.5))
//                .matchedGeometryEffect(id: "Tab", in: animation)
//        })
//        .contentShape(Rectangle())
        
        
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
