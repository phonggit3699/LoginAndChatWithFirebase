//
//  ChatCard.swift
//  UploadToApi
//
//  Created by PHONG on 04/09/2021.
//

import SwiftUI

struct ChatCard: View {
    var name: String
    
    @Environment(\.colorScheme) var colorScheme
    
    init(name: String){
        self.name = name
    }
    
    var body: some View {
        HStack(spacing: 10){
            ZStack(alignment: .bottomTrailing){
                Circle()
                    .fill(Color.gray)
                    .frame(width: 50, height: 50)
                ZStack{
                    Circle()
                        .stroke( colorScheme == .light ? Color.white : Color.black, lineWidth: 3)
                        .frame(width: 12, height: 12)
                    Circle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)
                }.offset(x: -1, y: -1)
            }
            VStack(alignment: .leading){
                Text(name)
                    .fontWeight(.bold)
                    .foregroundColor( colorScheme == .light ? .black : .white )
                
                Text("Message ds;aldkasl;dklas;kdl;sadkl;askdl;askd;kls;a")
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .padding(.horizontal)
    }
}

struct ChatCard_Previews: PreviewProvider {
    static var previews: some View {
        ChatCard(name: "VIP")
    }
}
