//
//  TabViewButton.swift
//  UploadToApi
//
//  Created by PHONG on 23/09/2021.
//

import SwiftUI

struct TabViewButton: View {
    @Binding var selectionTab: String
    var content: TabButtonModel
    var animation: Namespace.ID
    @State var bagde: Int = 0
    @EnvironmentObject var notificationVM: NotifyViewModel
    
    var body: some View {
        Button {
            withAnimation {
                selectionTab = content.label
            }
        } label: {
            VStack(spacing: 2){
                ZStack{
                    Rectangle()
                        .fill(Color.clear)
                        .frame( height: 3)
                    
                    if selectionTab == content.label {
                        Rectangle()
                            .fill(Color.blue)
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "Tab", in: animation)
                    }
                }.padding(.bottom, 3)
                
                ZStack(alignment: .topTrailing){
                    
                    Image(systemName: selectionTab == content.label ? content.systemImage2 : content.systemImage1)
                        .resizable()
                        .foregroundColor(selectionTab == content.label ? .blue : .gray)
                        .frame(width: 25, height: 25)
                    
                    
                    //badge
                    switch content.typeBadge {
                    case "chat":
                        if notificationVM.countNewChat > 0 {
                            Text(String(notificationVM.countNewChat))
                                .foregroundColor(.white)
                                .font(.system(size: 9))
                                .padding(3)
                                .frame(width: 20, height: 20)
                                .background(Color.red)
                                .clipShape(Circle())
                                .offset(x: 8, y: -2)
                        }
                    case "newfeed":
                        if notificationVM.countNewFeed > 0 {
                            Text(String(notificationVM.countNewFeed))
                                .foregroundColor(.white)
                                .font(.system(size: 9))
                                .padding(3)
                                .frame(width: 20, height: 20)
                                .background(Color.red)
                                .clipShape(Circle())
                                .offset(x: 8, y: -2)
                        }
                    case "notification":
                        if notificationVM.countNewNotification > 0 {
                            Text(String(notificationVM.countNewNotification))
                                .foregroundColor(.white)
                                .font(.system(size: 9))
                                .padding(3)
                                .frame(width: 20, height: 20)
                                .background(Color.red)
                                .clipShape(Circle())
                                .offset(x: 8, y: -2)
                        }
                    default:
                        Text("")
                          
                    }
                    
                }
                
                Text(content.label)
                    .font(.caption2)
                    .foregroundColor(selectionTab == content.label ? .blue : .gray)
            }
        }
    }
}

