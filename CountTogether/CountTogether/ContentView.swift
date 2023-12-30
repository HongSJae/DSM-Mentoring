import SwiftUI

struct ContentView: View {
    @State var count = 0
    var body: some View {
        VStack {
            Text("\(count)")
                .foregroundStyle(.white)

            HStack {
                Button("up") { count += 1 }

                Button("down") { count -= 1 }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
}

#Preview {
    ContentView()
}
