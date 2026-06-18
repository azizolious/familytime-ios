//
//  APIEnvelope.swift
//  FamilyTime
//
//  Created by Ahmad on 19/05/2026.
//  Copyright © 2026 YumyApps. All rights reserved.
//

import Foundation

struct APIEnvelope<T: Codable>: Codable {
    let data: T
}
