//
//  ScreenTimeAPIClient.swift
//  PracticeScreenTimeAPI
//
//  Created by Johnny Toda on 2024/02/09.
//

import Foundation
import FamilyControls
import ManagedSettings
import DeviceActivity


class ScreenTimeAPIClient: ObservableObject {
//    static let shared = ScreenTimeAPIClient()
    private let store = ManagedSettingsStore()
    private let center = DeviceActivityCenter()

//    private init() {}

    /// ブロックするアプリを設定
    var selectionToDiscourage = FamilyActivitySelection() {
        // プロパティの変更前に実行
        willSet {
            print ("got here \(newValue)")

            // アプリとアプリカテゴリ(ex: SNS,Game..)のトークンを取得し、ManagedSettingsStoreに渡す
            store.shield.applications = newValue.applicationTokens.isEmpty ? nil : newValue.applicationTokens
            store.shield.applicationCategories = ShieldSettings
                .ActivityCategoryPolicy
                .specific(
                    newValue.categoryTokens
                )
            store.shield.webDomainCategories = ShieldSettings
                .ActivityCategoryPolicy
                .specific(
                    newValue.categoryTokens
                )
        }
    }

    /// 他のアプリに影響を及ぼすことに対するリクエストをユーザーに送る
    func authorize() async throws {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
    }

    func initiateMonitoring() {
        let schedule = DeviceActivitySchedule(
            intervalStart: DateComponents(hour: 0, minute: 0),
            intervalEnd: DateComponents(hour: 23, minute: 59),
            repeats: true,
            warningTime: nil
        )

        do {
            try center.startMonitoring(.daily, during: schedule)
        } catch {
            print ("Could not start monitoring \(error)")
        }
        store.dateAndTime.requireAutomaticDateAndTime = true
        store.account.lockAccounts = true
        store.passcode.lockPasscode = true
        store.siri.denySiri = true
        store.appStore.denyInAppPurchases = true
        store.appStore.maximumRating = 200
        store.appStore.requirePasswordForPurchases = true
        store.media.denyExplicitContent = true
        store.gameCenter.denyMultiplayerGaming = true
        store.media.denyMusicService = false
    }

    func stopMonitoring() {
        center.stopMonitoring()
    }

    func encourageAll(){
        store.shield.applications = []
        store.shield.applicationCategories = ShieldSettings
            .ActivityCategoryPolicy
            .specific(
                []
            )
        store.shield.webDomainCategories = ShieldSettings
            .ActivityCategoryPolicy
            .specific(
                []
            )
    }
}

extension DeviceActivityName {
    static let daily = Self("daily")
}
