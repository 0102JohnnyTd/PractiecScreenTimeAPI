//
//  ContentView.swift
//  PracticeScreenTimeAPI
//
//  Created by Johnny Toda on 2024/02/04.
//

import SwiftUI
import FamilyControls

struct ContentView: View {
    // TODO: viewModelからModelの処理を呼び出すと処理が走らない。
//    @StateObject var viewModel = ContentViewModel(model: ScreenTimeAPIClient())
    @StateObject var model = ScreenTimeAPIClient.shared
    @State private var selection = FamilyActivitySelection()
    @State private var isPresented = false

    var body: some View {
        Button {
            Task {
                try await model.authorize()
                isPresented = true
            }
        } label: {
            Text("封印するアプリを選択する")
        }
        .familyActivityPicker(
            isPresented: $isPresented,
            selection: $model.selectionToDiscourage
        )

        Button {
            model.revokeAuthorize()
        } label: {
            Text("封印する曜日/時間帯を選ぶ")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
