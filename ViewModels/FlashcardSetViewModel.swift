//
//  FlashcardSetViewModel.swift
//  Flashy Cards
//
//  Created by Joshua Chapman on 12/6/25.
//

import Foundation
import CoreData
import Combine

class FlashcardSetViewModel: ObservableObject {
    @Published var sets: [FlashcardSet] = []
    private let context = PersistenceController.shared.container.viewContext

    func fetchSets() {
        let request: NSFetchRequest<FlashcardSet> = FlashcardSet.fetchRequest()
        sets = (try? context.fetch(request)) ?? []
    }

    func addSet(title: String) {
        print("Context has changes BEFORE save:", context.hasChanges)
        let newSet = FlashcardSet(context: context)
        newSet.id = UUID()
        newSet.title = title
        PersistenceController.shared.save()
        fetchSets()
    }
    
    func deleteSet(at offsets: IndexSet) {
        offsets.map { sets[$0] }.forEach(context.delete)
        PersistenceController.shared.save()
        fetchSets()
    }
}
