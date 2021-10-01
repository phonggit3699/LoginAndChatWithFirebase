//
//  SearchView.swift
//  UploadToApi
//
//  Created by PHONG on 24/09/2021.
//

import SwiftUI

struct SearchView: View {
    @State var text: String = ""
    @State var hideNavBar: Bool = false
    @Binding var hideTabBar: Bool
    
    init(hideTabBar: Binding<Bool>){
        _hideTabBar = hideTabBar
    }
    
    var body: some View {
        VStack{
            SearchBarView(text: self.$text, hideNavBar: self.$hideNavBar, placeholder: "Search")
            SearchContent(text: $text, hideTabBar: $hideTabBar)
        }.navigationBarHidden(hideNavBar)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(hideTabBar: .constant(false))
    }
}
