//
//  ContentView.swift
//  studia_csci3397
//
//  Created by Aiden Seibel on 3/25/25.
//

import SwiftUI

struct HomePage: View {
    @State private var studySets: [Study_Set] = []
    @State private var isRefreshing = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("My study sets")
                        .font(.title)
                        .bold()
                    
                    NavigationLink(destination: FromAICreateStudySetView()) {
                        VStack {
                            Text("Create a New Study Set using AI")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                    }
                    
                    Divider()
                    
                    if studySets.isEmpty {
                        VStack(spacing: 10) {
                            Text("No study sets yet")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Text("Create your first study set using AI")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 30)
                    } else {
                        ForEach(studySets) { studySet in
                            
                            NavigationLink(destination: StudySetView(study_set: studySet)) {
                                StudySetSubView(
                                    study_set: studySet,
                                    onDelete: {
                                        StudySetStorage.shared.deleteStudySet(withId: studySet.id)
                                        loadStudySets()
                                    }
                                )
                            }
                            .buttonStyle(.plain)
                            Divider()
                        }
                    }
                }
                .padding()
            }
            .refreshable {
                await refreshStudySets()
            }
            .onAppear {
                loadStudySets()
            }
        }
    }
    
    private func loadStudySets() {
        studySets = StudySetStorage.shared.getAllStudySets()
    }
    
    private func refreshStudySets() async {
        isRefreshing = true
        loadStudySets()
        try? await Task.sleep(nanoseconds: 500_000_000) // Half-second delay for better UX
        isRefreshing = false
    }
}
let testCard1 = Flashcard(question: "@State", answer: "Use case: For simple value types (Int, String, etc.) owned by a single view")
let testCard2 = Flashcard(question: "@StateObject", answer: "Use case: Stores reference to an ObservableObject. When to use: When view owns the lifecycle of a view model")
let testCard3 = Flashcard(question: "@Binding", answer: "Use case: Stores reference to an ObservableObject. When to use: Child views that need to modify parent's state")
let testCard4 = Flashcard(question: "@ObservedObject", answer: "Use case: References an ObservableObject created elsewhere. When to use: When object is created and owned externally")
let testCard5 = Flashcard(question: "@EnvironmentObject", answer: "Use case: Accesses shared data available to many views. Lifecycle: Injected from a parent view into environment. When to use: App-wide data like themes, user sessions")

let dummyData: [Study_Set] = [
    Study_Set(
        name: "CSCI 3397 Mobile Apps",
        description: "Exam 3",
        Flashcards: [
            testCard1,testCard2,testCard3, testCard4, testCard5
        ]
    ),
    Study_Set(
        name: "CSCI 3396",
        description: "Network Security",
        Flashcards: []
    ),
    Study_Set(
        name: "BAT 3305",
        description: "Data Science",
        Flashcards: []
    )
]

#Preview {
    HomePage()
}
