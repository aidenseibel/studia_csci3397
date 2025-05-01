//
//  StudySet.swift
//  studia_csci3397
//
//  Created by Aiden Seibel on 3/25/25.
//

import Foundation


struct Flashcard: Codable, Hashable {
    var id: UUID = UUID()

    var question: String
    var answer: String
    
    static func == (lhs: Flashcard, rhs: Flashcard) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Study_Set: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    
    var name: String
    var description: String
    
    var Flashcards: [Flashcard]
    
    
    static func == (lhs: Study_Set, rhs: Study_Set) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher  : inout Hasher) {
        hasher.combine(id)
    }


}



