//
//  StudySetView.swift
//  studia_csci3397
//
//  Created by Aiden Seibel on 3/25/25.
//

import SwiftUI

struct StudySetView: View {
    var study_set: Study_Set
    @State private var currentIndex = 0
    @State private var isShowingAnswer = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("\(study_set.name)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                Spacer()
                Text("\(study_set.description)")
                    .font(.title3)
                    .padding(.horizontal)
                Spacer()
                ZStack{
                    if study_set.Flashcards.isEmpty {
                        Text("You don't have any flashcards added. ")
                    }
                    else {
                        FlashcardView(flashcard: study_set.Flashcards[currentIndex], isAnswer: $isShowingAnswer)
                    }
                }
                .padding(.vertical)
                
                HStack{
                    Spacer()
                    
                    Button(action:{
                            if currentIndex > 0{
                                currentIndex -= 1
                                isShowingAnswer = false

                            }
                        
                    }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .resizable()
                            .frame(width: 44, height: 44)
                            .foregroundColor(currentIndex > 0 ? .blue : .gray)
                    }
                    .disabled(currentIndex <= 0)
                    .padding(.horizontal)
                    
                    Text("\(currentIndex + 1) of \(study_set.Flashcards.count)")
                        .font(.headline)
                    
                    Button(action: {
                            if currentIndex < study_set.Flashcards.count - 1 {
                                currentIndex += 1
                                isShowingAnswer = false

                            }
                        
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 44, height: 44)
                            .foregroundColor(currentIndex < study_set.Flashcards.count - 1 ? .blue : .gray)
                    }
                    .disabled(currentIndex >= study_set.Flashcards.count - 1)
                    .padding(.horizontal)
                    Spacer()
                }
            }
            .padding()
        }
    }
}

