//
//  Note.swift
//  Notes
//
//  Created by Камиль Зиялтдинов on 27.01.2024.
//

import SwiftUI
import SwiftData

@Model
class Note {
    var content: String
    var isFavorite: Bool = false
    var category: NoteCategory?
    
    init(content: String, isFavorite: Bool, category: NoteCategory? = nil) {
        self.content = content
        self.isFavorite = isFavorite
        self.category = category
    }
}
