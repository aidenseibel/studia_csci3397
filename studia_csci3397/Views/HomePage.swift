//
//  ContentView.swift
//  studia_csci3397
//
//  Created by Aiden Seibel on 3/25/25.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("My study sets")
                        .font(.title)
                        .bold()
                    
                    NavigationLink(destination: CreateStudySetView()) {
                        VStack() {
                            Text("Create a new study set")
                        }
                        .padding()
                    }
                    
                    Divider()
                    
                    
                    ForEach(sample_study_sets, id: \.self) { study_set in
                        NavigationLink(destination: StudySetView(study_set: study_set)) {
                            StudySetSubView(study_set: study_set)
                        }
                        .buttonStyle(.plain)
                        
                        Divider()
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    HomePage()
}
