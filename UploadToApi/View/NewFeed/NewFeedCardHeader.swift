//
//  NewFeedCardHeader.swift
//  UploadToApi
//
//  Created by PHONG on 13/10/2021.
//

import SwiftUI

struct NewFeedCardHeader: View {
    var title: String
    var subTitle: String
    var time: String
    
    init(title: String, subTitle: String, time: String) {
        self.title = title
        self.subTitle = subTitle
        self.time = time
    }
    
    var body: some View {
        HStack(spacing: 10){
            // Avatar
            Image("Circle-icons")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 48, height: 48)
                .clipShape(Circle())
            
            // title
            VStack(alignment: .leading, spacing: 3){
                Text(title)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                HStack(spacing: 8) {
                    Text(subTitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Image(systemName: "circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 3, height: 3)
                    
                    Text(time)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // option button
            
            HStack(spacing: 10){
                
                Button {
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                }

            }
        }
        .padding(8)
    }
}


