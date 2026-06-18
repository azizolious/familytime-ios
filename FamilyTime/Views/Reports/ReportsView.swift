//
//  ReportsView.swift
//  FamilyTime
//
//  Reports hub. SwiftUI, iOS 17, @Observable view models via @State.
//  No UIKit, no networking in views, no force-unwraps.
//

import SwiftUI

/// Reports hub: lists the available activity report kinds plus the social-chat
/// report, and surfaces an honest note about iOS data-collection limitations.
struct ReportsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Activity") {
                    ForEach(ReportKind.allCases) { kind in
                        NavigationLink(kind.title) {
                            ReportListView(kind: kind)
                        }
                    }
                    NavigationLink("Social Chat") {
                        SocialReportView()
                    }
                }

                Section {
                    Text("Web, YouTube, TikTok and social-chat reports show data collected on the child's Android device. Call-log and SMS reports are limited by iOS and are not yet available here.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Reports")
        }
    }
}

#Preview {
    ReportsView()
}
