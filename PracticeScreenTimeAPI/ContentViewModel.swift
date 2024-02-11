//
//  ContentViewModel.swift
//  PracticeScreenTimeAPI
//
//  Created by Johnny Toda on 2024/02/04.
//

import Foundation
import FamilyControls

final class ContentViewModel: ObservableObject {
    @Published var model: ScreenTimeAPIClient

    init(model: ScreenTimeAPIClient = ScreenTimeAPIClient()) {
        self.model = model
    }

    // FIXME: 現状うまく処理が走ってない。
    lazy var selection = model.selectionToDiscourage
}
