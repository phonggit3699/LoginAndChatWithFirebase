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
    @Binding var hideNavBar: Bool
    var placeholder: String
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        searchBar.tintColor = UIColor.init(Color.blue)
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar,
                      context: Context) {
        uiView.text = text
        
        if self.hideNavBar {
            uiView.showsCancelButton = true
        }
        else{
            uiView.showsCancelButton = false
        }
        
        
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        
        var parent:SearchBarView
        
        init(parent:SearchBarView) {
            self.parent = parent
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            parent.text = searchText
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            parent.hideNavBar = true
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            parent.text = ""
            
            parent.hideNavBar = false
            
            searchBar.resignFirstResponder()
        }
    }
}
