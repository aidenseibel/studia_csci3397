//
//  StudySetSubView.swift
//  studia_csci3397
//
//  Created by Aiden Seibel on 3/25/25.
//

import SwiftUI

struct StudySetSubView: View {
    
    var study_set: Study_Set
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text("\(study_set.name)")
                    .font(.title2)
                Text("\(study_set.description)")
                Text("\(study_set.Flashcards.count) flashcards")
            }
            .padding(10)
            
            Spacer()
        }
    }
}


