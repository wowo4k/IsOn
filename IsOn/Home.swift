//
//  Home.swift
//  IsOn
//
//  Created by ARMIN WOWORSKY on 04.06.22.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var appDelegate: AppDelegate
    
    @State var currentTab: String = "IsOn"
    @Namespace var animation
    
    var body: some View {
        VStack {
            CustomSegmentedControl()
                .padding()
            
            
            if currentTab == "IsOn" {
                
                HStack {
                    Text("IsOn")

                }
                
                    
            }
            else {
                HStack {
                    Text("About")

                }
            }
        
            
//            ScrollView(.vertical, showsIndicators: false) {
//                VStack(spacing: 10){
//                    if let coins = appModel.coins{
//                        ForEach(coins){coin in
//                            VStack(spacing: 8){
//                                CardView(coin: coin)
//                                Divider()
//                            }
//                            .padding(.horizontal)
//                            .padding(.vertical,8)
//                        }
//                    }
//                }
//            }
            Spacer()
            HStack{
                Button {
                    
                    appDelegate.changeIcon()
                
                    
                    
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
    
    // MARK: Custom Segmented Control
    @ViewBuilder
    func CustomSegmentedControl()->some View{
        HStack(spacing: 0){
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
