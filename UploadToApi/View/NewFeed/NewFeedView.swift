//
//  NewFeedView.swift
//  UploadToApi
//
//  Created by PHONG on 22/09/2021.
//

import SwiftUI

struct NewFeedView: View {
    @Binding var avatarImg: UIImage?
    
    init(avatarImg: Binding<UIImage?>) {
        _avatarImg = avatarImg
    }
    
    var body: some View {
        RefreshScrollView(content: {
            
            CreatePostView(avatarImg: $avatarImg)
            
            LazyVStack{
                ForEach(1...3, id: \.self){post in
                    NewFeedCard()
                }
            }
        }, onRefresh: { refreshControl in
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                refreshControl.endRefreshing()
            }
        })
        .padding(.bottom, getSafeArea().bottom + 25) // padding = size of safe area botton + height of tab bar
    }
}

