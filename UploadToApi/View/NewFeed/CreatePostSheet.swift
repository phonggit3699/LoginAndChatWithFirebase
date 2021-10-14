//
//  CreatePostSheet.swift
//  UploadToApi
//
//  Created by PHONG on 13/10/2021.
//

import SwiftUI

struct CreatePostSheet: View {
    
    @Binding var showSheet: Bool
    
    var avatarImg: UIImage?
    
    @AppStorage("currentUser") var user = ""
    
    @State private var postContentText: String = ""
    
    @State private var showPlaceholder: Bool = true
    
    init(showSheet: Binding<Bool>, avatarImg: UIImage?){
        UITextView.appearance().backgroundColor = .clear
        _showSheet = showSheet
        self.avatarImg = avatarImg
    }
    
    var body: some View {
        VStack{
            // sheet header
            HStack{
                Button {
                    showSheet.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .font(.system(size: 18, weight: .semibold))
                }
                
                Spacer()
                
                Button {
                    showSheet.toggle()
                } label: {
                    Text("Post")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .padding(8)
                        .background( postContentText.isEmpty ? Color("mainBg").opacity(0.5) : Color("mainBg"))
                        .cornerRadius(8)
                }.disabled(postContentText.isEmpty)
                
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .border(width: 1, edges: [.bottom], color: Color("lightGray"))
            .overlay(
                Text("Create Post")
                    .foregroundColor(.black)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                , alignment: .center
            )
            
            // information
            
            HStack(spacing: 10){
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
                
                // title
                Text(user)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(8)
            
            // Post Text
            ZStack(alignment: .topLeading){
                // custom placeholder for texteditor
                if postContentText.isEmpty {
                    Text("What's on your mind?")
                        .foregroundColor(.gray)
                        .offset(x: 3, y: 8)
                }
                
                TextEditor(text: $postContentText)
                    .background(Color.clear)
                
            }
            .padding(8)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

