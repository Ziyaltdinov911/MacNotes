//
//  NoteCategory.swift
//  Notes
//
//  Created by Камиль Зиялтдинов on 27.01.2024.
//

import SwiftUI
import SwiftData

@Model
class NoteCategory {
    var categoryTitle: String
    
    @Relationship(deleteRule: .cascade, inverse: \Note.category)
    var notes: [Note]?
    
    init(categoryTitle: String) {
        self.categoryTitle = categoryTitle
    }
}
