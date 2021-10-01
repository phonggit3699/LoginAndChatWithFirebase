//
//  SearchCard.swift
//  UploadToApi
//
//  Created by PHONG on 25/09/2021.
//

import SwiftUI

struct SearchCard: View {
    
    var searchResult: SearchModel = SearchModel(id: "", keyword: "")
    @Binding var searchResults: [SearchModel]
    
    @Environment(\.colorScheme) var colorScheme
    
    init(searchResult: SearchModel, searchResults: Binding<[SearchModel]>){
        self.searchResult = searchResult
        _searchResults = searchResults
    }
    
    var body: some View {
        HStack{
            Text(searchResult.keyword)
                .foregroundColor(colorScheme == .dark ? .white : .black)
            Spacer()
            
            Button {
                withAnimation {
                    if !searchResults.isEmpty {
                        self.searchResults.remove(at: getIndex(keyword: self.searchResult.keyword))
                    } 
                }
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .foregroundColor(colorScheme == .dark ? .white : .gray)
                    .frame(width: 15, height: 15)
            }
        }
        .padding(.horizontal)
    }
}


extension SearchCard{
    public func getIndex( keyword: String ) -> Int{
        if let index = self.searchResults.firstIndex(where: { searchResult.id == $0.id }){
            return index
        }else{
            return 0
        }
    }
}
