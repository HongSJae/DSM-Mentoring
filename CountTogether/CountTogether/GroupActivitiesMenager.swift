import Foundation
import Combine
import GroupActivities

@MainActor
class GroupActivitiesMenager: ObservableObject {
    @Published var count = 0
    @Published var session: GroupSession<CounterTogether>?
    private var messenger: GroupSessionMessenger?
    private var subscriptions = Set<AnyCancellable>()

    private func sendMessage(count: Int) {
        Task {
            try? await messenger?.send(CountMessage(currentCount: count))
        }
    }

    public func startingSharing() {
        Task {
            try? await CounterTogether().activate()
        }
    }

    public func plus() {
        self.count += 1
        self.sendMessage(count: self.count)
    }

    public func minus() {
        self.count -= 1
        self.sendMessage(count: self.count)
    }

    public func configureGroupSession(_ session: GroupSession<CounterTogether>) {
        self.count = 0
        self.session = session
        let messenger = GroupSessionMessenger(session: session)
        self.messenger = messenger

        session.$state
            .sink { state in
                if case .invalidated = state {
                    self.session = nil
                    self.count = 0
                    self.messenger = nil
                    self.subscriptions = .init()
                }
            }
            .store(in: &subscriptions)

        session.$activeParticipants
            .sink { [weak self] old in
                let new = old.subtracting(session.activeParticipants)
                Task {
                    try? await messenger.send(CountMessage(currentCount: self?.count ?? 0), to: .only(new))
                }
            }
            .store(in: &subscriptions) // 왜 주소 참조함?

        Task {
            for await (message, _) in messenger.messages(of: CountMessage.self) {
                self.count = message.currentCount
            }
        }

        session.join()
    }
}
