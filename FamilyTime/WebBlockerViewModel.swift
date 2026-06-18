//
//  WebBlockerViewModel.swift
//  FamilyTime
//
//  Created by Sufyan on 15/01/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//
//  Tier 2 migration (June 2026): now an @Observable view model for the SwiftUI
//  WebBlockerView. Backed entirely by WebBlockerRepository (async APIClient).
//  No legacy infra (CommonModel / CoreManager / DBManager / UserDefaultsManager).
//

import Foundation
import Observation

@MainActor
@Observable
final class WebBlockerViewModel {
    private let repo: WebBlockerRepositoryProtocol
    private let selectedChild = SelectedChildStore.shared

    var webBlockerArr: [WebBlockerObj] = []
    var control = Control()
    var isLoading = false
    var isSaving = false
    var alertMessage: String?

    init(repo: WebBlockerRepositoryProtocol = WebBlockerRepository()) {
        self.repo = repo
    }

    var isEnabled: Bool { control.state == 1 }

    var allBlocked: Bool {
        !webBlockerArr.isEmpty && webBlockerArr.allSatisfy { $0.isBlocked == 1 }
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            control = try await repo.fetchWebBlockerControl()
            webBlockerArr = try await repo.fetchWebBlockers()
        } catch {
            alertMessage = String(localized: "alert_something_wrong_again")
        }
    }

    func setEnabled(_ enabled: Bool) async {
        guard let childIdStr = selectedChild.selectedChildID,
              let childId = Int(childIdStr),
              let featureId = control.featureID,
              let identifier = control.identifier else {
            alertMessage = String(localized: "alert_something_wrong_again")
            return
        }
        let newState = enabled ? 1 : 0
        do {
            let _: EmptyDecodableResponse = try await APIClient.shared.request(
                FamilyTimeEndpoint.updateControl(
                    childId: childId, featureId: featureId, state: newState, identifier: identifier))
            control.state = newState
        } catch {
            alertMessage = String(localized: "alert_something_wrong_again")
        }
    }

    func setBlocked(_ app: WebBlockerObj, blocked: Bool) {
        guard let idx = webBlockerArr.firstIndex(where: { $0.id == app.id }) else { return }
        webBlockerArr[idx].isBlocked = blocked ? 1 : 0
    }

    func setAll(_ blocked: Bool) {
        for i in webBlockerArr.indices { webBlockerArr[i].isBlocked = blocked ? 1 : 0 }
    }

    func save() async {
        isSaving = true
        defer { isSaving = false }
        do {
            try await repo.save(webBlockerArr)
        } catch {
            alertMessage = String(localized: "alert_something_wrong_again")
        }
    }

    func addURL(_ url: String) async {
        let trimmed = url.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        guard let childIdStr = selectedChild.selectedChildID, let childId = Int(childIdStr) else {
            alertMessage = String(localized: "alert_something_wrong_again")
            return
        }
        let newObj = WebBlockerObj(
            id: nil, superUserID: nil, childID: childId,
            url: trimmed, type: "custom", isBlocked: 1)
        isSaving = true
        defer { isSaving = false }
        do {
            try await repo.add([newObj])
            await load()
        } catch {
            alertMessage = String(localized: "alert_something_wrong_again")
        }
    }

    func remove(_ apps: [WebBlockerObj]) async {
        guard !apps.isEmpty else { return }
        isSaving = true
        defer { isSaving = false }
        do {
            try await repo.remove(apps)
            await load()
        } catch {
            alertMessage = String(localized: "alert_something_wrong_again")
        }
    }
}
