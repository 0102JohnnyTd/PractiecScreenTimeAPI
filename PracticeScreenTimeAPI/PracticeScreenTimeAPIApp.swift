//
//  PracticeScreenTimeAPIApp.swift
//  PracticeScreenTimeAPI
//
//  Created by Johnny Toda on 2024/02/04.
//

import SwiftUI
import FamilyControls
import ManagedSettings

@main
struct PracticeScreenTimeAPIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    Task {
                        do {
                            try await ScreenTimeAPIClient.shared.authorize()
                        } catch {
                            print("FamilyControls承認エラーが発生:", error)
                        }
                    }
                }
        }
    }
}
