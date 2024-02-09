//
//  Home.swift
//  Notes
//
//  Created by Камиль Зиялтдинов on 27.01.2024.
//

import SwiftUI
import SwiftData

struct Home: View {
    
    @State private var selectedTag: String? = "Все заметки"
    
    @Query(animation: .snappy)
    private var categories: [NoteCategory]
    
    @Environment(\.modelContext)
    private var context
    
    @State private var addCategory: Bool = false
    @State private var categoryTitle: String = ""
    
    @State private var requestCategory: NoteCategory?
    @State private var deleteRequest: Bool = false
    @State private var renameRequest: Bool = false
    
    @State private var isDark: Bool = true
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedTag) {
                Text("Все заметки")
                    .tag("Все заметки")
                    .foregroundStyle(selectedTag == "Все заметки" ? Color.primary : .gray)
                Text("Избранные")
                    .tag("Избранные")
                    .foregroundStyle(selectedTag == "Избранные" ? Color.primary : .gray)
                
                Section {
                    ForEach(categories) { category in
                        Text(category.categoryTitle)
                            .tag(category.categoryTitle)
                            .foregroundStyle(selectedTag == category.categoryTitle ? Color.primary : .gray)
                        
                            .contextMenu {
                                Button("Переименовать") {
                                    categoryTitle = category.categoryTitle
                                    requestCategory = category
                                    renameRequest = true
                                }
                                
                                Button("Удалить") {
                                    categoryTitle = category.categoryTitle
                                    requestCategory = category
                                    deleteRequest = true
                                }
                            }
                    }
                } header: {
                    HStack(spacing: 10) {
                        Text("Категории")
                            .font(.system(size: 16))
                         
                        Button("", systemImage: "plus") {
                            addCategory.toggle()
                        }
                        .tint(.red)
                        .buttonStyle(.plain)
                        
                        
                    }
                }

                
            }
        } detail: {
            
            NotesView(category: selectedTag, allCategories: categories)
            
        }
        .navigationTitle(selectedTag ?? "Заметки")
        
        .alert("Добавить категорию", isPresented: $addCategory) {
            TextField("Введите название категории", text: $categoryTitle)
            
            Button("Отмена", role: .cancel) {
                categoryTitle = ""
            }
            
            Button("Добавить") {
                let catgory = NoteCategory(categoryTitle: categoryTitle)
                context.insert(catgory)
                categoryTitle = ""
            }
        }
        
        .alert("Переименовать категорию", isPresented: $renameRequest) {
            
            TextField("Введите название категории", text: $categoryTitle)
            
            Button("Отмена", role: .cancel) {
                categoryTitle = ""
                requestCategory = nil
            }
            
            Button("Переименовать") {
                if let requestCategory {
                    requestCategory.categoryTitle = categoryTitle
                    categoryTitle = ""
                    self.requestCategory = nil
                }
                
            }
        }
        
        .alert("Вы действительно хотите удалить категорию \(categoryTitle)?", isPresented: $deleteRequest) {
    
            Button("Отмена", role: .cancel) {
                categoryTitle = ""
                requestCategory = nil
            }
            
            Button("Удалить", role: .destructive) {
                if let requestCategory {
                    context.delete(requestCategory)
                    categoryTitle = ""
                    self.requestCategory = nil
                }
                
            }
        }
        
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                HStack(spacing: 5) {
                    Button("", systemImage: "plus") {
                        let note = Note(content: "", isFavorite: false)
                        context.insert(note)
                        
                    }
                    
                    Button("", systemImage: isDark ? "sun.min" : "moon") {
                        isDark.toggle()
                        
                    }
                    
                    .contentTransition(.symbolEffect(.replace))
                }
            }
        }
        .preferredColorScheme(isDark ? .dark : .light)
    }
}

#Preview {
    ContentView()
}
