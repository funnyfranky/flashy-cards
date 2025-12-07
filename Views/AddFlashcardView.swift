//
//  AddFlashcardView.swift
//  Flashy Cards
//
//  Created by Joshua Chapman on 12/6/25.
//

import SwiftUI
import CoreData


struct AddFlashcardView: View {
    @ObservedObject var viewModel: FlashcardViewModel
    @Environment(\.dismiss) var dismiss

    @State private var question = ""
    @State private var answer = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Question", text: $question)
                TextField("Answer", text: $answer)

                Button("Add Card") {
                    viewModel.addCard(question: question, answer: answer)
                    dismiss()
                }
            }
            .navigationTitle("New Flashcard")
        }
    }
}
