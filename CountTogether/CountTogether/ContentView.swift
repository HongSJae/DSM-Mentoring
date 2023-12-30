import SwiftUI
import GroupActivities

struct ContentView: View {
    @StateObject var groupActivitiesMenager: GroupActivitiesMenager = .init()
    @StateObject var groupStateObserver = GroupStateObserver()

    var body: some View {
        VStack {
            Text("\(groupActivitiesMenager.count)")

            HStack {
                Button("up", action: groupActivitiesMenager.plus)

                Button("down", action: groupActivitiesMenager.minus)
            }

            if groupActivitiesMenager.session == nil &&
                groupStateObserver.isEligibleForGroupSession {
                Button("SHARE", action: groupActivitiesMenager.startingSharing)
            }
        }
        .task {
            for await session in CounterTogether.sessions() {
                groupActivitiesMenager.configureGroupSession(session)
            }
        }
    }
}

#Preview {
    ContentView()
}
