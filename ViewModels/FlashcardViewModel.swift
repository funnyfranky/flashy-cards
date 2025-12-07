//
//  FlashcardViewModel.swift
//  Flashy Cards
//
//  Created by Joshua Chapman on 12/6/25.
//

import Foundation
import SwiftUI
import CoreData
import Combine

class FlashcardViewModel: ObservableObject {
    @Published var cards: [Flashcard] = []

    private let context = PersistenceController.shared.container.viewContext
    private var parentSet: FlashcardSet?

    init(set: FlashcardSet? = nil) {
        self.parentSet = set
        fetchCards()
    }

    func fetchCards() {
        guard let set = parentSet else {
            cards = []
            return
        }

        let request: NSFetchRequest<Flashcard> = Flashcard.fetchRequest()
        request.predicate = NSPredicate(format: "set == %@", set)
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Flashcard.question, ascending: true)
        ]

        do {
            cards = try context.fetch(request)
        } catch {
            print("Failed to fetch cards:", error)
            cards = []
        }
    }

    func addCard(question: String, answer: String) {
        guard let set = parentSet else {
            print("❌ parentSet is nil in addCard")
            return
        }

        let newCard = Flashcard(context: context)
        newCard.id = UUID()
        newCard.question = question
        newCard.answer = answer
        newCard.isLearned = false
        newCard.set = set

        do {
            try context.save()
            print("✅ Saved new card:", question)
        } catch {
            print("❌ Failed to save new card:", error)
        }

        fetchCards()
    }

    func deleteCard(at offsets: IndexSet) {
        offsets.map { cards[$0] }.forEach(context.delete)
        do {
            try context.save()
        } catch {
            print("❌ Failed to delete card(s):", error)
        }
        fetchCards()
    }

    func toggleLearned(card: Flashcard) {
        card.isLearned.toggle()
        do {
            try context.save()
        } catch {
            print("❌ Failed to toggle learned:", error)
        }
        fetchCards()
    }
}
