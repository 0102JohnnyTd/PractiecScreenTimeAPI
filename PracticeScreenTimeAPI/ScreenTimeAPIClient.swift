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


final class ScreenTimeAPIClient: ObservableObject {
    private init() {}
    static let shared = ScreenTimeAPIClient()

    private let store = ManagedSettingsStore()
    private let center = DeviceActivityCenter()

    /// ブロックするアプリを設定
    var selectionToDiscourage = FamilyActivitySelection() {
        // プロパティの変更前に実行
        willSet {
            print("newValue.categoryTokens", newValue.categoryTokens)
            print ("got here \(newValue)")

            // アプリとアプリカテゴリ(ex: SNS,Game..)のトークンを取得し、ManagedSettingsStoreに渡す
            store.shield.applications = newValue.applicationTokens.isEmpty ? nil : newValue.applicationTokens
            store.shield.applicationCategories = ShieldSettings
                .ActivityCategoryPolicy
                .all(except:
                        newValue.applicationTokens
                )

            store.shield.webDomainCategories = ShieldSettings
                .ActivityCategoryPolicy
                .all(except:
                        newValue.webDomainTokens
                )
        }
    }

    func revokeAuthorize() {
        AuthorizationCenter.shared.revokeAuthorization { result in
            switch result {
            case .success:
                print("リクエスト承認を取り下げました")
            case .failure:
                print("リクエスト承認の取り下げに失敗しました")
            }
        }
    }

    /// 他のアプリに影響を及ぼすことに対するリクエストをユーザーに送る
    func authorize() async throws {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
        initiateMonitoring()
    }

    private func initiateMonitoring() {
        do {
            let schedule = DeviceActivitySchedule(
                intervalStart: DateComponents(hour: 10, minute: 22),
                intervalEnd: DateComponents(hour: 10, minute: 37),
                repeats: true
            )
            try center.startMonitoring(.daily, during: schedule)
        } catch {
            print ("Could not start monitoring \(error)")
        }
        store.application.denyAppRemoval = true
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
