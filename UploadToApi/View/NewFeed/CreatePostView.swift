//
//  CreatePostView.swift
//  UploadToApi
//
//  Created by PHONG on 13/10/2021.
//

import SwiftUI

struct CreatePostView: View {
    
    @State private var showSheet: Bool = false
    
    @Binding var  avatarImg: UIImage?
    
    init(avatarImg: Binding<UIImage?>) {
        _avatarImg = avatarImg
    }
    
    var body: some View {
        
        VStack{
            HStack(spacing: 8){
                // Avatar
                ZStack{
                    if avatarImg != nil{
                        Image(uiImage: avatarImg!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())
                    }else{
                        Image("Circle-icons")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 48, height: 48)
                            .clipShape(Circle())
                    }
                }
                
                Button {
                    // show sheet createPost
                    showSheet.toggle()
                    
                } label: {
                    Text("What's on your mind?")
                        .font(.body)
                        .foregroundColor(.black)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(Capsule().fill(Color("lightGray2")))
                }

            }
            .frame(maxWidth: .infinity)
            .padding([.top, .horizontal], 8)
            
            Rectangle()
                .fill(Color("lightGray"))
                .frame(maxWidth: .infinity, maxHeight: 8)
        }
        .frame(maxWidth: .infinity)
        .fullScreenCover(isPresented: $showSheet) {
            CreatePostSheet(showSheet: $showSheet, avatarImg: avatarImg)
        }
    }
}

