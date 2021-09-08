//
//  SettingView.swift
//  UploadToApi
//
//  Created by PHONG on 05/09/2021.
//

import SwiftUI

struct SettingView: View {
    @State var username: String = ""
    @State var isPrivate: Bool = true
    @State var notificationsEnabled: Bool = false
    @State var darkMode: Bool = false
    @State var autoDarkMode: Bool = true
    @State private var previewIndex = 0
    var previewOptions = ["Always", "When Unlocked", "Never"]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Form {
            Section(header: Text("Theme")) {
                Toggle(isOn: $autoDarkMode) {
                    Text("Auto Dark Mode")
                }
                
                Toggle(isOn: $darkMode) {
                    Text("Dark Mode")
                }
            }
            
            Section(header: Text("NOTIFICATIONS")) {
                Toggle(isOn: $notificationsEnabled) {
                    Text("Enabled")
                }
                Picker(selection: $previewIndex, label: Text("Show Previews")) {
                    ForEach(0 ..< previewOptions.count) {
                        Text(self.previewOptions[$0])
                    }
                }
            }
            
            Section(header: Text("ABOUT")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                }
            }
            
            Section {
                Button(action: {
                    print("Perform an action here...")
                }) {
                    Text("Reset All Settings")
                }
            }
        }.onChange(of: self.darkMode, perform: { value in
            if value {
                self.autoDarkMode = false
                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .dark
            }else{
                UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .light
            }
            
        })
        .onChange(of: self.autoDarkMode, perform: { value in
            if value {
                self.darkMode = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .unspecified
                }
            }
        })
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
