//
//  NewFeedCard.swift
//  UploadToApi
//
//  Created by PHONG on 13/10/2021.
//

import SwiftUI

struct NewFeedCard: View {
    var body: some View {
        VStack(spacing: 0){
            
            NewFeedCardHeader(title: "Test", subTitle: "Phong", time: "9h")
            
            NewFeedCardContent(contentText: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.", contentImageUrl: nil)
            
            NewFeedCardReactBar()
            Rectangle()
                .fill(Color("lightGray"))
                .frame(maxWidth: .infinity, maxHeight: 8)
        }.frame(maxWidth: .infinity)
    }
}

struct NewFeedCard_Previews: PreviewProvider {
    static var previews: some View {
        NewFeedCard()
    }
}
