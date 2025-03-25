//
//  StudySet.swift
//  studia_csci3397
//
//  Created by Aiden Seibel on 3/25/25.
//

import Foundation


struct flashcard: Codable, Hashable {
    var id: UUID = UUID()

    var question: String
    var answer: String
    
    static func == (lhs: flashcard, rhs: flashcard) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct study_set: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    
    var name: String
    var description: String
    
    var flashcards: [flashcard]
    
    
    static func == (lhs: study_set, rhs: study_set) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


var sample_study_sets: [study_set] = [
    study_set(name: "CSCI 3397", description: "Mobile Apps", flashcards: []),
    study_set(name: "CSCI 3396", description: "Network Security", flashcards: []),
    study_set(name: "BAT 3305", description: "Data Science", flashcards: [])
]
