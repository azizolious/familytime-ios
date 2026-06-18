//
//  RemoveURLVM.swift
//  FamilyTime
//
//  Created by Sufyan on 17/01/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//
//  Tier 1 migration (June 2026): CoreManager.deleteWebBlocker + DBManager.deletObjWebBlocker
//  → WebBlockerRepository.remove (async APIClient, DELETE /web-blocker). Public API unchanged.
//

import Foundation

class RemoveURLVM {
    var webBlockerArr = [WebBlockerObj]()
    var selectAll = false
    var isSearching = false
    var searchArr = [WebBlockerObj]()

    private let repo: WebBlockerRepositoryProtocol = WebBlockerRepository()

    func selection() {
        if selectAll == true {
            webBlockerArr = webBlockerArr.map { obj in
                var ob2 = obj
                ob2.isSelectd = true
                return ob2
            }
        } else {
            webBlockerArr = webBlockerArr.map { obj in
                var ob2 = obj
                ob2.isSelectd = false
                return ob2
            }
        }
    }

    func deleteData(callback: @escaping () -> ()) {
        let apps = (isSearching ? searchArr : webBlockerArr).filter { $0.isSelectd == true }
        Task { @MainActor in
            do {
                try await repo.remove(apps)
            } catch {
                print("❌ WebBlocker remove failed: \(error)")
            }
            callback()
        }
    }
}
