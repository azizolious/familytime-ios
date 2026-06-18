import SwiftUI

/// SwiftUI host for the existing `LiveChat/` Response platform — the Support tab.
///
/// This is INTEGRATION glue only: it wires the presentational `LiveChatView`
/// (from the `LiveChat/` module) to the module's public `LiveChatService` /
/// `LiveVisitorManager`. It does NOT modify any `LiveChat/` internals and does
/// NOT reimplement the service. Advanced behaviours that live in the legacy
/// UIKit controllers (socket-driven live updates, optimistic send + retry, full
/// pagination/scroll restoration) are inherited from the module and are a
/// follow-up for full SwiftUI parity.
@MainActor
@Observable
final class SupportChatModel {
    private(set) var messages: [ChatMessage] = []
    var messageText: String = ""
    private(set) var isLoading = false
    private(set) var isLoadingMore = false
    private(set) var hasMoreMessages = false
    private(set) var errorMessage: String?

    private var conversationId: Int?
    private let service = LiveChatService.shared
    private let visitor = LiveVisitorManager.shared

    var isConversationResolved: Bool { visitor.isConversationResolved }

    func start() async {
        isLoading = true
        defer { isLoading = false }
        await visitor.start()
        do {
            let convId: Int
            if let existing = visitor.currentConversation?.id {
                convId = existing
            } else if let created = try await service.createConversation().id {
                convId = created
            } else {
                errorMessage = "Could not start a support conversation."
                return
            }
            conversationId = convId
            messages = try await service.fetchMessages(conversationId: convId)
            hasMoreMessages = !messages.isEmpty
            errorMessage = nil
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func send() async {
        let text = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, let convId = conversationId else { return }
        messageText = ""
        do {
            let sent = try await service.sendMessage(conversationId: convId, message: text)
            messages.append(sent)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func loadMore() async {
        guard !isLoadingMore, let convId = conversationId, let firstId = messages.first?.id else { return }
        isLoadingMore = true
        defer { isLoadingMore = false }
        do {
            let older = try await service.fetchMessages(conversationId: convId, before: firstId)
            hasMoreMessages = !older.isEmpty
            messages.insert(contentsOf: older, at: 0)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct SupportView: View {
    @State private var model = SupportChatModel()

    var body: some View {
        NavigationStack {
            LiveChatView(
                messages: model.messages,
                messageText: model.messageText,
                isLoadingMore: model.isLoadingMore,
                hasMoreMessages: model.hasMoreMessages,
                isConversationResolved: model.isConversationResolved,
                onTextChange: { model.messageText = $0 },
                onSend: { Task { await model.send() } },
                onBack: {},
                onLoadMore: { Task { await model.loadMore() } },
                retryMessage: { _ in Task { await model.send() } },
                startConversation: { Task { await model.start() } }
            )
            .navigationTitle("Support")
            .navigationBarTitleDisplayMode(.inline)
            .overlay { if model.isLoading { ProgressView() } }
            .task { await model.start() }
            .alert("Support", isPresented: .constant(model.errorMessage != nil)) {
                Button("OK") {}
            } message: {
                Text(model.errorMessage ?? "")
            }
        }
    }
}
