//
//  NewFeedCardContent.swift
//  UploadToApi
//
//  Created by PHONG on 13/10/2021.
//

import SwiftUI

struct NewFeedCardContent: View {
    var contentText: String
    var contentImageUrl: URL?
    @State private var isLimit: Bool = true
    
    init(contentText: String, contentImageUrl: URL?) {
        self.contentText = contentText
        self.contentImageUrl = contentImageUrl
    }
    
    var body: some View {
        VStack(spacing: 10){
            
            Text(contentText)
                .foregroundColor(.black)
                .font(.body)
                .lineLimit(isLimit ? 3 : nil)
                .padding(.horizontal, 7)
                .overlay(
                    GeometryReader { proxy in
                        Button {
            
                            isLimit.toggle()
                            
                        } label: {
                            HStack{
                                Text("...")
                                    .foregroundColor(.black)
                                
                                Text("See more")
                                    .foregroundColor(.gray)
                                
                            }
                            .padding(.trailing, 8)
                            .padding(.top, 4)
                            .background(Color.white)
                        }.opacity(isLimit ? 1 : 0)
                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .bottomTrailing)
                    }
                )
            
            Image("postImg")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
        }
    }
}

