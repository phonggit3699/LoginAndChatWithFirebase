//
//  FlexibleSheet.swift
//  UploadToApi
//
//  Created by PHONG on 15/08/2021.
//

import SwiftUI

enum SheetMode {
    case none
    case quarter
    case half
    case full
}

struct FlexibleSheet<Content: View>: View {
    
    let content: () -> Content
    @Binding var showSheet: Bool
    @State var offset: CGFloat = 0
    @State var lastOffset: CGFloat = 0
    @Environment(\.colorScheme) var colorScheme
    @GestureState private var translation: CGFloat = 0
    
    init(showSheet: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        
        self.content = content
        self._showSheet = showSheet
        
    }
    
    
    
    var body: some View {
        GeometryReader {proxy in
            VStack {
                //TODO: top controll
                ZStack {
                    Capsule()
                        .fill(Color.white)
                        .frame(width: 40, height: 8)
                        .padding(.vertical, 5)
                    
                    
                    
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.showSheet.toggle()
                            }
                            
                        }, label: {
                            Text("Cancel")
                        })
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                self.showSheet.toggle()
                            }
                        }, label: {
                            Text("Done")
                        })
                    }.padding(.vertical, 10)
                    .padding(.horizontal, 15)
                }
                Spacer()
                content()
                Spacer()
                
            }
            
            .background(Color("bg2"))
            .clipShape(CustomCorner())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(edges: .bottom)
            .gesture(DragGesture()
                        .updating($translation, body: { value, state, _ in
                            state = value.translation.height
                            self.onChange()
                        })
                        .onEnded({ value in
                            
                            if offset <  (proxy.frame(in: .global).height / 2) {
                                withAnimation(.spring()) {
                                    offset = 0
                                }
                            }else{
                                withAnimation {
                                    showSheet = false
                                }
                                
                            }
                            lastOffset = offset
                            
                        }))
            .onChange(of: self.showSheet, perform: { value in
                withAnimation {
                    if value {
                        self.offset =  getRect().height / 2
                    }else{
                        self.offset =  getRect().height
                    }
                }
                
            })
            .onAppear{
                offset = getRect().height
            }
            .offset(y: self.offset)
            
            
        }
        
    }
    func onChange(){
        DispatchQueue.main.async {
            if self.offset >= 0 {
                self.offset += self.translation
            }
        }
        
    }
}

struct FlexibleSheet_Previews: PreviewProvider {
    static var previews: some View {
                FlexibleSheet(showSheet: .constant(false)) {
                    VStack {
                        Text("Hello World")
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                }
    }
}

