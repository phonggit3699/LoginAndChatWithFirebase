//
//  NotificationCard.swift
//  UploadToApi
//
//  Created by PHONG on 23/09/2021.
//

import SwiftUI

struct NotificationCard: View {
    var notification: NotificationContent
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack(spacing: 10){
            
            Image("Circle-icons")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: 50, height: 50)
            
            
            VStack(alignment: .leading){
                Text(notification.title)
                    .fontWeight(.bold)
                    .foregroundColor( colorScheme == .light ? .black : .white )
                
                Text(notification.message)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
        }
    }
}

