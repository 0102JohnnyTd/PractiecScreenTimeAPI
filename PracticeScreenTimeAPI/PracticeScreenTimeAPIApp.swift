//
//  PracticeScreenTimeAPIApp.swift
//  PracticeScreenTimeAPI
//
//  Created by Johnny Toda on 2024/02/04.
//

import SwiftUI
import FamilyControls

@main
struct PracticeScreenTimeAPIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    Task {
                        do {
                            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                        } catch {
                            print("FamilyControls承認エラーが発生:", error)
                        }
                    }
                }
        }
    }
}
