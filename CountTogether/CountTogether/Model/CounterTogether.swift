import GroupActivities

struct CounterTogether: GroupActivity {
    var metadata: GroupActivityMetadata {
        var metadata = GroupActivityMetadata()

        metadata.title = "CounterTogehter"
        metadata.type = .generic

        return metadata
    }
}
