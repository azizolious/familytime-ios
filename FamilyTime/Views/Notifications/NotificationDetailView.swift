//
//  NotificationDetailView.swift
//  FamilyTime
//
//  Phase 2 Notifications — feed item detail.
//

import SwiftUI

struct NotificationDetailView: View {
    let item: FeedDatum

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if let url = URL(string: item.imageURL), !item.imageURL.isEmpty {
                    AsyncImage(url: url) { img in
                        img
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxHeight: 200)
                }

                Text(item.title)
                    .font(.title2)
                    .bold()

                Text(item.feedData)
                    .font(.body)

                if let cta = URL(string: item.webCta),
                   !item.webCta.isEmpty,
                   !item.actionText.isEmpty {
                    Link(item.actionText, destination: cta)
                        .font(.headline)
                }
            }
            .padding()
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}
