//
//  ReviewFlashcardsView.swift
//  Flashy Cards
//
//  Created by Joshua Chapman on 12/6/25.
//

import SwiftUI

struct ReviewFlashcardsView: View {
    let cards: [Flashcard]
    @State private var index = 0
    @State private var showAnswer = false

    var body: some View {
        VStack {
            if cards.isEmpty {
                Text("No cards to review")
            } else {
                Text(cards[index].question ?? "")
                    .font(.largeTitle)
                    .padding()

                if showAnswer {
                    Text(cards[index].answer ?? "")
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .padding()
                }

                Button(showAnswer ? "Hide Answer" : "Show Answer") {
                    showAnswer.toggle()
                }
                .padding()

                HStack {
                    Button("Previous") {
                        if index > 0 { index -= 1 }
                        showAnswer = false
                    }
                    .disabled(index == 0)

                    Spacer()

                    Button("Next") {
                        if index < cards.count - 1 { index += 1 }
                        showAnswer = false
                    }
                    .disabled(index == cards.count - 1)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Review")
        .padding()
    }
}
