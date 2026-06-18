//
//  ChildCardView.swift
//  FamilyTime
//
//  A single child's summary card for the dashboard.
//  iOS 16 minimum — SwiftUI only, no UIKit, no force unwraps.
//

import SwiftUI

struct ChildCardView: View {
    let child: ChildData

    // Free packages that should surface an upgrade prompt.
    private let freePackageIDs: Set<Int> = [1, 6]

    private var name: String {
        child.childInfo?.name ?? "Unknown"
    }

    private var avatarURL: URL? {
        guard let src = child.childInfo?.profileImgSrc, !src.isEmpty else { return nil }
        return URL(string: src)
    }

    private var genderSymbol: String {
        switch child.childInfo?.gender?.lowercased() {
        case "male", "m", "boy":
            return "person.fill"
        case "female", "f", "girl":
            return "person.fill"
        default:
            return "person.crop.circle"
        }
    }

    private var isLocked: Bool {
        (child.childInfo?.phonelockStatus ?? 0) == 1
    }

    private var isFreePackage: Bool {
        if let packageID = child.childInfo?.packageID {
            return freePackageIDs.contains(packageID)
        }
        return false
    }

    private var screenTimeSummary: String {
        let remaining = child.dailyLimit?.remaining
        let duration = child.dailyLimit?.duration
        if let remaining = remaining, let duration = duration {
            return "\(remaining)/\(duration) min"
        } else if let duration = duration {
            return "\(duration) min limit"
        } else {
            return "No limit set"
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            avatar
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(name)
                        .font(.headline)
                    if isFreePackage {
                        upgradeBadge
                    }
                }
                Label(screenTimeSummary, systemImage: "hourglass")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            lockIndicator
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private var avatar: some View {
        if let avatarURL = avatarURL {
            AsyncImage(url: avatarURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    fallbackAvatar
                case .empty:
                    ProgressView()
                @unknown default:
                    fallbackAvatar
                }
            }
            .frame(width: 48, height: 48)
            .clipShape(SwiftUI.Circle())
        } else {
            fallbackAvatar
        }
    }

    private var fallbackAvatar: some View {
        Image(systemName: genderSymbol)
            .resizable()
            .scaledToFit()
            .foregroundColor(.accentColor)
            .frame(width: 48, height: 48)
    }

    private var upgradeBadge: some View {
        Text("Upgrade")
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 2)
            .background(Color.orange.opacity(0.2))
            .foregroundColor(.orange)
            .clipShape(Capsule())
    }

    private var lockIndicator: some View {
        Image(systemName: isLocked ? "lock.fill" : "lock.open")
            .foregroundColor(isLocked ? .red : .green)
            .accessibilityLabel(isLocked ? "Phone locked" : "Phone unlocked")
    }
}
