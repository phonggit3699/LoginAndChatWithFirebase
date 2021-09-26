//
//  SearchContent.swift
//  UploadToApi
//
//  Created by PHONG on 25/09/2021.
//

import SwiftUI

struct SearchContent: View {
    @State private var keywords = ["Phong", "Long", "Tu", "Ten that la dai ne"]
    @Binding var text: String
    
    init(text: Binding<String>){
        _text = text
    }
    
    var body: some View{
        VStack{
            ScrollView(.vertical, showsIndicators: false) {
                
                HStack{
                    Text("Recent Searches")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button {
                        print("all")
                    } label: {
                        Text("See all")
                            .foregroundColor(.blue)
                    }

                }.padding(.horizontal)
                
                LazyVStack{
                    ForEach(keywords.filter { text.isEmpty ? true : $0.lowercased().contains(text.lowercased()) }, id: \.self){keyword in
                        SearchCard(keyword: keyword)
                    }
                }
            }
        }
    }
}

struct SearchContent_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
