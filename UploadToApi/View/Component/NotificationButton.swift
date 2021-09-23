//
//  NotificationButton.swift
//  UploadToApi
//
//  Created by PHONG on 22/09/2021.
//

import SwiftUI

struct NotificationButton: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack(alignment: .topTrailing){
            Button(action: {
               
            }, label: {
                Image(systemName: "bell")
                    .resizable()
                    .foregroundColor(self.colorScheme == .dark ? .white : .black)
                    .clipShape(Circle())
                    .frame(width: 25, height: 25)
            })
            
            if 1 > 0 {
                Text("1")
                    .foregroundColor(.white)
                    .font(.system(size: 10))
                    .padding(5)
                    .background(Color.red)
                    .frame(width: 15, height: 15)
                    .clipShape(Circle())
                    .offset(y: -2)
            }
        }
    }
}

struct NotificationButton_Previews: PreviewProvider {
    static var previews: some View {
        NotificationButton()
    }
}
