//
//  SearchContent.swift
//  UploadToApi
//
//  Created by PHONG on 25/09/2021.
//

import SwiftUI

struct SearchContent: View {
    @State private var searchResults:[SearchModel] = []
    @Binding var text: String
    @State private var isActive: Bool = false
    @State private var selectedsearchResult: SearchModel = SearchModel(id: "", keyword: "")
    @ObservedObject var UserVM = UserViewModel()
    @Binding var hideTabBar: Bool
    
    init(text: Binding<String>, hideTabBar: Binding<Bool>){
        _text = text
        _hideTabBar = hideTabBar
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
                    ForEach(searchResults.filter { text.isEmpty ? true : $0.keyword.lowercased().contains(text.lowercased()) }, id: \.self){searchResult in
                        Button {
                            DispatchQueue.main.async {
                                hideTabBar = true
                            }
                            isActive.toggle()
                            selectedsearchResult = searchResult 
                        } label: {
                            SearchCard(searchResult: searchResult, searchResults: $searchResults)
                        }
                    }
                }
                
                NavigationLink(
                    destination: ProfileView(idSearchResult: selectedsearchResult.id, hideTabBar: $hideTabBar),
                    isActive: $isActive,
                    label: {
                        EmptyView()
                    })

            }
        }
        .onChange(of: text) { newValue in
            UserVM.searchUser(keyword: newValue) { user in
                self.searchResults = user.map{ SearchModel(id: $0.id, keyword: $0.name) }
            }
        }
        .onAppear{
            getSearhResults { searchData in
                self.searchResults = searchData
            }
        }
        .onDisappear {
            saveSearhResults(searchResult: self.searchResults)
        }
    }
}

extension SearchContent {
    func saveSearhResults(searchResult: [SearchModel]){
        guard let saveResults = try? PropertyListEncoder().encode(searchResult) else {
            return
        }
        UserDefaults.standard.set(saveResults, forKey: "saveResults")
    }
    
    func getSearhResults(_ com: @escaping ([SearchModel]) -> Void){
        guard let saveResults = UserDefaults.standard.value(forKey: "saveResults") as? Data else { return }
        
        if let searchResults = try? PropertyListDecoder().decode([SearchModel].self, from: saveResults){
            DispatchQueue.main.async {
                com(searchResults)
                
            }
        }
    }
}

