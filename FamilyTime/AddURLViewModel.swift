//
//  AddURLViewModel.swift
//  FamilyTime
//
//  Created by Sufyan on 16/01/2024.
//  Copyright © 2024 YumyApps. All rights reserved.
//
//  Tier 1 migration (June 2026): CoreManager.postWebBlocker + DBManager.saveWebBlocker
//  → WebBlockerRepository.add (async APIClient, POST /web-blocker). Public API unchanged.
//

import Foundation

class AddURLViewModel {
    var newURLArr = [WebBlockerObj]()

    private let repo: WebBlockerRepositoryProtocol = WebBlockerRepository()

    func postData(callback: @escaping (String?) -> ()) {
        Task { @MainActor in
            do {
                try await repo.add(self.newURLArr)
                callback(nil)
            } catch {
                callback(error.localizedDescription)
            }
        }
    }
}
