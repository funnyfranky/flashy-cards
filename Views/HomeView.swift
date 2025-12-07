import SwiftUI

struct HomeView: View {
    @StateObject var vm = FlashcardSetViewModel()

    @State private var showAdd = false
    @State private var selectedSet: FlashcardSet?

    var body: some View {
        NavigationView {
            VStack {

                // MARK: - iOS LIST (swipe-to-delete)
                #if os(iOS)
                List {
                    ForEach(vm.sets, id: \.self) { set in
                        NavigationLink(destination: FlashcardSetDetailView(set: set)) {
                            Text(set.title ?? "")
                        }
                    }
                    .onDelete(perform: vm.deleteSet)
                }
                .listStyle(.insetGrouped)
                .onAppear { vm.fetchSets() }

                // Bottom + button
                HStack {
                    Button {
                        showAdd = true
                    } label: {
                        Text("+")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }

                    Spacer()
                }
                .padding()
                #endif


                // MARK: - macOS LIST (selection + minus button)
                #if os(macOS)
                List(selection: $selectedSet) {
                    ForEach(vm.sets, id: \.self) { set in
                        Text(set.title ?? "")
                            .tag(set as FlashcardSet?)
                    }
                }
                .listStyle(.inset)
                .onAppear { vm.fetchSets() }

                HStack {
                    Button {
                        showAdd = true
                    } label: {
                        Text("+")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }

                    Button {
                        if let set = selectedSet,
                           let index = vm.sets.firstIndex(of: set) {
                            vm.deleteSet(at: IndexSet(integer: index))
                            selectedSet = nil
                        }
                    } label: {
                        Text("–")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                    .disabled(selectedSet == nil)

                    Spacer()
                }
                .padding()
                #endif

            }
            .navigationTitle("Flashcard Sets")
        }
        .sheet(isPresented: $showAdd) {
            AddSetView(vm: vm)
        }
    }
}
