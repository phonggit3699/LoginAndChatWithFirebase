//
//  CustomTabViewBar.swift
//  UploadToApi
//
//  Created by PHONG on 23/09/2021.
//

import SwiftUI

struct CustomTabViewBar: View {
    @Binding var selectionTab: String
    @Namespace var animation
    @EnvironmentObject var notificationVM: NotifyViewModel
    @Environment (\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 0){
            Spacer()
            ForEach(TabButtons, id: \.self){ value in
                TabViewButton(selectionTab: $selectionTab, content: value, animation: animation).environmentObject(notificationVM)
                Spacer()
            }
            
        }.frame(maxWidth: .infinity)
        .border(width: 1, edges: [.top], color: Color("tabviewbg"))
        .background(colorScheme == .dark ? Color.black : Color.white)
    }
}

struct CustomTabViewBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabViewBar(selectionTab: .constant("New Feed")).environmentObject(NotifyViewModel())
    }
}

struct TabButtonModel: Hashable {
    var systemImage1: String
    var systemImage2: String
    var label: String
    var typeBadge: String
}

var TabButtons = [TabButtonModel(systemImage1: "house", systemImage2: "house.fill", label: "New Feed", typeBadge: "newfeed"),

                  TabButtonModel(systemImage1: "message", systemImage2: "message.fill",label: "Chats", typeBadge: "chat"),
                                    
                  TabButtonModel(systemImage1: "bell", systemImage2: "bell.fill", label: "Notifications", typeBadge: "notification"),
                  
                  TabButtonModel(systemImage1: "magnifyingglass", systemImage2: "magnifyingglass", label: "Search", typeBadge: "search")]
