//
//  RefreshScrollView.swift
//  UploadToApi
//
//  Created by PHONG on 13/10/2021.
//

import SwiftUI

struct RefreshScrollView<Content: View>: UIViewRepresentable {
    var content: Content
    var onRefresh: (UIRefreshControl) -> ()
    var refreshControl = UIRefreshControl()

    
    init(@ViewBuilder content: @escaping () -> Content, onRefresh: @escaping (UIRefreshControl) -> ()) {
        self.content = content()
        
        self.onRefresh = onRefresh
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let view = UIScrollView()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        self.refreshControl.addTarget(context.coordinator, action: #selector(context.coordinator.onRefresh), for: .valueChanged)
        
        setUpView(view: view)
        view.refreshControl = self.refreshControl
        
        return view
        
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        setUpView(view: uiView)
    }
    
    func setUpView(view: UIScrollView){
        let hostView = UIHostingController(rootView: self.content.frame(maxHeight: .infinity))
        let constraints = [
            hostView.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            hostView.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            hostView.view.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor),
            
        ]
        
        view.showsVerticalScrollIndicator = false
       
        
        hostView.view.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.subviews.last?.removeFromSuperview()
        view.addSubview(hostView.view)
        view.addConstraints(constraints)
    }
    
    class Coordinator: NSObject {
        var parent: RefreshScrollView
        
        init(parent: RefreshScrollView){
            self.parent = parent
        }
        
        @objc func onRefresh() {
            parent.onRefresh(parent.refreshControl)
        }
    }
}
