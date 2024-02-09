//
//  NotesView.swift
//  Notes
//
//  Created by Камиль Зиялтдинов on 27.01.2024.
//

import SwiftUI
import SwiftData

struct NotesView: View {
    var category: String?
    var allCategories: [NoteCategory]
    
    @Query private var notes: [Note]
    
    init(category: String?, allCategories: [NoteCategory]) {
        self.category = category
        self.allCategories = allCategories
        let predicate = #Predicate<Note> {
            return $0.category?.categoryTitle == category
        }
        
        let favoritePredicate = #Predicate<Note> {
            return $0.isFavorite
        }
        
        let finalPredicate = category == "Все заметки" ? nil : (category == "Избранные" ? favoritePredicate : predicate)
        
        _notes = Query(filter: finalPredicate, sort: [], animation: .snappy)
    
    }
    
    @FocusState private var isKeyBoardEnabled: Bool
    
    @Environment(\.modelContext)
    private var context
    var body: some View {
        GeometryReader {
            let size = $0.size
            let width = size.width
            
            let rowCount = max(Int(width / 250), 1)
            
            ScrollView(.vertical) {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: rowCount), spacing: 10) {
                    ForEach(notes) { note in
                        NoteCardView(note: note, isKeyBoardEnabled: $isKeyBoardEnabled)
                            .contextMenu {
                                Button(note.isFavorite ? "Удалить из избранных" : "Переместить в Избранные") {
                                    note.isFavorite.toggle()
                                }
                                
                                Menu {
                                    ForEach(allCategories) { category in
                                        Button {
                                            note.category = category
                                        } label: {
                                            HStack(spacing: 5) {
                                                Text(category.categoryTitle)
                                                    .font(.headline)
                                                    .foregroundColor(.red)
                                                if category == note.category {
                                                    Image(systemName: "checkmark")
                                                    .font(.headline)

                                                }
                                            }
                                        }
                                    }
                                   
                                    
                                    Button("Удалить из категории") {
                                        note.category = nil
                                    }
                                    
                                    
                                } label: {
                                    Text("Категория")
                                }
                                
                                Button("Удалить", role: .destructive) {
                                    context.delete(note)
                                }
                            }
                    }
                }
                .padding(12)
            }
            .onTapGesture {
                isKeyBoardEnabled = false
            }
        }
    }
}

struct NoteCardView: View {
    @Bindable var note: Note
    var isKeyBoardEnabled: FocusState<Bool>.Binding
    @State private var showNote: Bool = false
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.clear)
            
            if showNote {
                TextEditor(text: $note.content)
                    .focused(isKeyBoardEnabled)
                    .overlay(alignment: .leading, content: {
                        Text("Заметка пуста")
                            .foregroundStyle(.gray)
                            .padding(.leading, 5)
                            .opacity(note.content.isEmpty ? 1 : 0)
                            .allowsHitTesting(false)
                    })
                
                    .scrollContentBackground(.hidden)
                    .multilineTextAlignment(.leading)
                    .padding(15)
                    .kerning(1.2)
                    .frame(maxWidth: .infinity)
                    .background(.gray.opacity(0.15), in: .rect(cornerRadius: 12))
            }
        }
        .onAppear {
            showNote = true
        }
        .onDisappear {
            showNote = false
        }
    }
}

#Preview {
    ContentView()
}
