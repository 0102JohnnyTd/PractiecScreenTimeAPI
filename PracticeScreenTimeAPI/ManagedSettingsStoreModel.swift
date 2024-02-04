//
//  ManagedSettingsStoreModel.swift
//  PracticeScreenTimeAPI
//
//  Created by Johnny Toda on 2024/02/04.
//

import Foundation
import ManagedSettings
import FamilyControls

/// アプリの利用制限に関する処理を管理
final class ManagedSettingsStoreModel {
    private let store = ManagedSettingsStore(named: ManagedSettingsStore.Name.default)

    /// アプリの使用制限を開始
    func startBlocking(selection: FamilyActivitySelection) {
        store.application.denyAppRemoval = true
        store.shield.applicationCategories = .specific(selection.categoryTokens)
        store.shield.applications = selection.applicationTokens
    }

    /// アプリの使用制限を解除
    func stopBlocking() {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        store.clearAllSettings()
    }
}
