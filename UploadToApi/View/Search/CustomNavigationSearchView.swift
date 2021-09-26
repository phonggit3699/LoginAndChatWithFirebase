//
//  CustomNavigationSearchView.swift
//  UploadToApi
//
//  Created by PHONG on 25/09/2021.
//

import SwiftUI
import UIKit

struct CustomNavigationSearchView<V: View>: UIViewControllerRepresentable {
    @Binding var text: String
    var view: V
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UINavigationController{
        
        let childView = UIHostingController(rootView: view)
    
        let controller = UINavigationController(rootViewController: childView)
        
        controller.navigationBar.topItem?.title = "Search"
        controller.navigationBar.prefersLargeTitles = false
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = context.coordinator
        
        controller.navigationBar.topItem?.hidesSearchBarWhenScrolling = false
        controller.navigationBar.topItem?.searchController = searchController
        return controller
        
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        
        var parent:CustomNavigationSearchView
        
        init(parent:CustomNavigationSearchView) {
            self.parent = parent
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            parent.text = searchText
        }
    
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            parent.text = ""
            
            searchBar.resignFirstResponder()
        }
    }

    
}


