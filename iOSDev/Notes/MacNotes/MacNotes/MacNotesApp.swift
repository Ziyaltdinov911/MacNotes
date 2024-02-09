//
//  NotesApp.swift
//  Notes
//
//  Created by Камиль Зиялтдинов on 27.01.2024.
//

import SwiftUI

@main
struct NotesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            
                .frame(minWidth: 320, minHeight: 400)
        }
        .windowResizability(.contentSize)
        
        .modelContainer(for: [Note.self, NoteCategory.self])
    }
}
