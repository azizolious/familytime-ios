//
//  WebBlockerViewModel.swift
//  FamilyTime
//
//  Created by Sufyan on 15/01/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//
//  Tier 1 migration (June 2026): legacy infra removed from this view model.
//  - CoreManager.patchWebBlocker / DBManager  → WebBlockerRepository (async APIClient)
//  - DBManager.getWebBlocker / fetchAppBlockControl → repo.fetchWebBlockers / fetchWebBlockerControl
//  - UserDefaultsConstants.SELECTED_CHILD_ID → SelectedChildStore.shared
//  - CommonModel.showAlert → log (the SwiftUI shell in Tier 2 surfaces user errors)
//  Public method signatures are unchanged so the (Tier 2) UIKit WebBlockerVC still compiles.
//

import Foundation

class WebBlockerViewModel {
    var webBlockerArr = [WebBlockerObj]()
    var control = Control()
    var selectedAll = false
    var reload: () -> () = {}

    private let repo: WebBlockerRepositoryProtocol = WebBlockerRepository()

    func initMethod() {
        Task { @MainActor in
            do {
                self.control = try await repo.fetchWebBlockerControl()
                self.webBlockerArr = try await repo.fetchWebBlockers()
            } catch {
                print("❌ WebBlocker load failed: \(error)")
            }
            self.selectAllTogle()
            self.reload()
        }
    }

    func selectAllTogle() {
        selectedAll = !webBlockerArr.isEmpty && webBlockerArr.allSatisfy { $0.isBlocked == 1 }
    }

    func fetchControl() {
        Task { @MainActor in
            if let c = try? await repo.fetchWebBlockerControl() {
                self.control = c
                self.reload()
            }
        }
    }

    func changeControl(state: Int, callBack: @escaping () -> ()) {
        Task { @MainActor in
            guard let childIdStr = SelectedChildStore.shared.selectedChildID,
                  let childId = Int(childIdStr),
                  let featureId = control.featureID,
                  let identifier = control.identifier else {
                print("❌ Missing required params (childId / featureId / identifier)")
                callBack()
                return
            }
            do {
                let _: EmptyDecodableResponse = try await APIClient.shared.request(
                    FamilyTimeEndpoint.updateControl(
                        childId: childId,
                        featureId: featureId,
                        state: state,
                        identifier: identifier))
                callBack()
                self.control.state = state
                self.reload()
            } catch {
                callBack()
                print("❌ updateControl failed: \(error)")
            }
        }
    }

    func patchData(callback: @escaping () -> ()) {
        Task { @MainActor in
            do {
                try await repo.save(self.webBlockerArr)
            } catch {
                print("❌ WebBlocker save failed: \(error)")
            }
            callback()
        }
    }

    func selection() {
        webBlockerArr = webBlockerArr.map { value in
            var obj = value
            obj.isBlocked = selectedAll ? 1 : 0
            return obj
        }
    }
}
