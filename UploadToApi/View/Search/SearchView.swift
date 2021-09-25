//
//  SearchView.swift
//  UploadToApi
//
//  Created by PHONG on 24/09/2021.
//

import SwiftUI

struct SearchView: View {
    @State private var text: String = ""
    
    var body: some View {
        VStack{
            SearchBarView(text: $text, placeholder: "Search")
            
        }.frame(maxWidth: .infinity, maxHeight:  .infinity, alignment: .top)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
