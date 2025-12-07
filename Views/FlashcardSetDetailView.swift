//
//  FlashcardSetDetailView.swift
//  Flashy Cards
//
//  Created by Joshua Chapman on 12/6/25.
//

//import SwiftUI
//
//struct FlashcardSetDetailView: View {
//    @StateObject var cardVM: FlashcardViewModel
//    @State private var showAddCard = false
//    @State private var selectedCard: Flashcard?
//
//    init(set: FlashcardSet) {
//        _cardVM = StateObject(wrappedValue: FlashcardViewModel(set: set))
//    }
//
//    var body: some View {
//        VStack {
//            List(selection: $selectedCard) {
//                ForEach(cardVM.cards, id: \.self) { card in
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text(card.question ?? "").font(.headline)
//                            Text(card.answer ?? "").font(.subheadline)
//                        }
//                        Spacer()
//                        Button(action: { cardVM.toggleLearned(card: card) }) {
//                            Image(systemName: card.isLearned ? "checkmark.circle.fill" : "circle")
//                        }
//                    }
//                    .tag(card as Flashcard?)
//                }
//            }
//
//            // bottom controls
//            HStack {
//                // + Add Card
//                Button {
//                    showAddCard = true
//                } label: {
//                    Text("+")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                }
//
//                // – Delete Card
//                Button {
//                    if let card = selectedCard,
//                       let index = cardVM.cards.firstIndex(of: card) {
//                        cardVM.deleteCard(at: IndexSet(integer: index))
//                        selectedCard = nil
//                    }
//                } label: {
//                    Text("–")
//                        .font(.largeTitle)
//                        .fontWeight(.bold)
//                        .foregroundColor(.red)
//                }
//                .disabled(selectedCard == nil)
//
//                Spacer()
//            }
//            .padding()
//        }
//        .navigationTitle("Flashcards")
//        .sheet(isPresented: $showAddCard) {
//            AddFlashcardView(viewModel: cardVM)
//        }
//    }
//}

import SwiftUI

struct FlashcardSetDetailView: View {
    @StateObject var cardVM: FlashcardViewModel
    @State private var showAddCard = false

    @State private var isSelecting = false
    @State private var selectedCards = Set<Flashcard>()

    init(set: FlashcardSet) {
        _cardVM = StateObject(wrappedValue: FlashcardViewModel(set: set))
    }

    var body: some View {
        VStack {

            List(selection: isSelecting ? $selectedCards : .constant(Set<Flashcard>())) {
                ForEach(cardVM.cards, id: \.self) { card in

                    HStack {

                        // SELECTION MODE CHECKBOX
                        if isSelecting {
                            Button {
                                toggleSelection(card)
                            } label: {
                                Image(systemName: selectedCards.contains(card) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(.plain)
                        }

                        // CARD CONTENT
                        VStack(alignment: .leading) {
                            Text(card.question ?? "")
                                .font(.headline)
                            Text(card.answer ?? "")
                                .font(.subheadline)
                        }

                        Spacer()

                        // LEARNED TOGGLE ALWAYS ACTIVE
                        Button {
                            cardVM.toggleLearned(card: card)
                        } label: {
                            Image(systemName: card.isLearned ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(card.isLearned ? .green : .gray)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .onDelete { indexSet in
                    if !isSelecting {
                        cardVM.deleteCard(at: indexSet)
                    }
                }
            }

            // BOTTOM CONTROLS
            HStack {
                Button {
                    showAddCard = true
                } label: {
                    Text("+")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }

                if isSelecting {
                    Button {
                        deleteSelectedCards()
                    } label: {
                        Text("Delete (\(selectedCards.count))")
                            .foregroundColor(.red)
                            .font(.title2)
                    }
                    .disabled(selectedCards.isEmpty)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Flashcards")
        .toolbar {
            Button(isSelecting ? "Done" : "Select") {
                if isSelecting {
                    selectedCards.removeAll()
                }
                isSelecting.toggle()
            }
        }
        .sheet(isPresented: $showAddCard) {
            AddFlashcardView(viewModel: cardVM)
        }
    }

    // MARK: Selection Helpers
    private func toggleSelection(_ card: Flashcard) {
        if selectedCards.contains(card) {
            selectedCards.remove(card)
        } else {
            selectedCards.insert(card)
        }
    }

    private func deleteSelectedCards() {
        let indices = selectedCards.compactMap { cardVM.cards.firstIndex(of: $0) }
        let indexSet = IndexSet(indices)
        cardVM.deleteCard(at: indexSet)
        selectedCards.removeAll()
        isSelecting = false
    }
}
