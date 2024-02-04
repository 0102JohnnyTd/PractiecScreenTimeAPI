//
//  ContentView.swift
//  PracticeScreenTimeAPI
//
//  Created by Johnny Toda on 2024/02/04.
//

import SwiftUI
import FamilyControls

struct ContentView: View {
    @State private var selection = FamilyActivitySelection()
    @State private var isPresented = false

    var body: some View {
        Button {
            isPresented = true
        } label: {
            Text("選択する")
        }
        .familyActivityPicker(
            isPresented: $isPresented,
            selection: $selection
        )
    }
}

#Preview {
    ContentView()
}

//struct ContentView: View {
//
//    @StateObject var viewModel: ContentViewModel
//    @State private var isPresented = false
//
//    var body: some View {
//        Button {
//            isPresented = true
//        } label: {
//            Text("選択する")
//        }
//        .familyActivityPicker(
//            isPresented: $isPresented,
//            selection: $viewModel.selection
//        )
//    }
//}
