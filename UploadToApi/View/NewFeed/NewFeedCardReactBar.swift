//
//  NewFeedCardReactBar.swift
//  UploadToApi
//
//  Created by PHONG on 13/10/2021.
//

import SwiftUI

struct NewFeedCardReactBar: View {
    var body: some View {
        VStack(spacing: 0){
            // count reaction, comments, shareds
            HStack(spacing: 15){
                Image("like")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
                
                Image("heart")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 20, height: 20)
                    .offset(x: -20)
                
                // Total count of all reaction
                Text("140")
                    .font(.callout)
                    .fontWeight(.regular)
                    .foregroundColor(.gray)
                    .offset(x: -30)
                
                Spacer()
                
                // Total count of commets
                Text("9 Comments")
                    .font(.callout)
                    .fontWeight(.regular)
                    .foregroundColor(.gray)
                
                // Total count of shareds
                Text("9 Shareds")
                    .font(.callout)
                    .fontWeight(.regular)
                    .foregroundColor(.gray)
                
            }
            .padding(10)
            
            Divider()
                .padding(.horizontal)
            
            HStack(spacing: 0){
                
                // Button Like
                Button {
                    
                } label: {
                    HStack(spacing: 5){
                        Image(systemName: "hand.thumbsup")
                            .resizable()
                            .foregroundColor(.gray)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 18, height: 18)
                        
                        Text("Like")
                            .foregroundColor(.gray)
                            .font(.body)
                            .fontWeight(.semibold)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                }
                
                Spacer()
                
                // Button Comment
                Button {
                    
                } label: {
                    HStack(spacing: 5){
                        Image(systemName: "bubble.left")
                            .resizable()
                            .foregroundColor(.gray)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 18, height: 18)
                        
                        Text("Comment")
                            .foregroundColor(.gray)
                            .font(.body)
                            .fontWeight(.semibold)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                }
                
                Spacer()
                // Button Shared
                Button {
                    
                } label: {
                    HStack(spacing: 5){
                        Image(systemName: "arrowshape.turn.up.right")
                            .resizable()
                            .foregroundColor(.gray)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 18, height: 18)
                        
                        Text("Share")
                            .foregroundColor(.gray)
                            .font(.body)
                            .fontWeight(.semibold)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                }
                
            }.padding(.horizontal, 30)
            .padding(10)
            
            
            
        }
        .frame(maxWidth: .infinity)
        .border(width: 1, edges: [.top], color: Color("lightGray"))
    }
}

struct NewFeedCardReactBar_Previews: PreviewProvider {
    static var previews: some View {
        NewFeedCardReactBar()
    }
}
