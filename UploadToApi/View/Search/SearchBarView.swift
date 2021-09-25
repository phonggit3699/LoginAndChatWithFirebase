//
//  SearchBarView.swift
//  UploadToApi
//
//  Created by PHONG on 24/09/2021.
//

import SwiftUI
import UIKit

struct SearchBarView: UIViewRepresentable {

    @Binding var text: String
    var placeholder: String

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        searchBar.barTintColor = UIColor.init(Color.blue)
        searchBar.tintColor = UIColor.init(Color.green)
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar,
                      context: Context) {
        uiView.text = text
        if self.text != "" {
            uiView.showsCancelButton = true
        }
        else{
            uiView.showsCancelButton = false
        }
        
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            self.text = ""
            searchBar.resignFirstResponder()
        }
    }
}
