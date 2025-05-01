//
//  StudySetStorage.swift
//  studia_csci3397
//
//  Created by Khoi Tran on 5/1/25.
//
import Foundation

class StudySetStorage {
    static let shared = StudySetStorage()
    
    private let userDefaults = UserDefaults.standard
    private let studySetsKey = "savedStudySets"
    
    private init() {}
    
    func getAllStudySets() -> [Study_Set] {
        guard let data = userDefaults.data(forKey: studySetsKey) else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            let studySets = try decoder.decode([Study_Set].self, from: data)
            return studySets
        } catch {
            print("Error decoding study sets: \(error.localizedDescription)")
            return []
        }
    }
    
    func saveStudySet(_ studySet: Study_Set) {
        var studySets = getAllStudySets()
        
        // Check if study set with the same ID already exists
        if let index = studySets.firstIndex(where: { $0.id == studySet.id }) {
            studySets[index] = studySet // Replace existing
        } else {
            studySets.append(studySet) // Add new
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(studySets)
            userDefaults.set(data, forKey: studySetsKey)
        } catch {
            print("Error encoding study sets: \(error.localizedDescription)")
        }
    }
    
    func deleteStudySet(withId id: String) {
        var studySets = getAllStudySets()
        if let uuid = UUID(uuidString: id){
            studySets.removeAll { $0.id == uuid }
            
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(studySets)
                userDefaults.set(data, forKey: studySetsKey)
            } catch {
                print("Error encoding study sets after deletion: \(error.localizedDescription)")
            }
        }
    }
}
