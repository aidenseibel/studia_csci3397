//
//  StudySetView.swift
//  studia_csci3397
//
//  Created by Aiden Seibel on 3/25/25.
//

import SwiftUI

struct StudySetView: View {
    var study_set: study_set
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("\(study_set.name)")
                    .font(.title)
                    .bold()
                
                Text("\(study_set.description)")
                
                if study_set.flashcards.isEmpty {
                    Text("You don't have any flashcards added. ")
                }
                else {
                    ForEach(study_set.flashcards, id: \.self) { flashcard in
                        HStack() {
                            Text("\(flashcard.question)")
                            Spacer()
                        }
                        
                        Divider()
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    StudySetView(study_set: sample_study_sets[0])
}
