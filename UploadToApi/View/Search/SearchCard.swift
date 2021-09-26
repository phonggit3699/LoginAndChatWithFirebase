//
//  SearchCard.swift
//  UploadToApi
//
//  Created by PHONG on 25/09/2021.
//

import SwiftUI

struct SearchCard: View {
    
    var keyword: String
    
    @Environment(\.colorScheme) var colorScheme
    
    init(keyword: String){
        self.keyword = keyword
    }
    
    var body: some View {
        HStack{
            Text(keyword)
                .foregroundColor(colorScheme == .dark ? .white : .black)
            Spacer()
            
            Button {
                print("delete row")
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .foregroundColor(colorScheme == .dark ? .white : .gray)
                    .frame(width: 15, height: 15)
            }


           
        }.padding(.horizontal)
    }
}

struct SearchCard_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
