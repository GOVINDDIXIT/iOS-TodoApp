//
//  ContentView.swift
//  todos
//
//  Created by Govind Dixit on 07/11/20.
//

// userdefaults to store todo items

import SwiftUI

struct ContentView: View {
    @State private var newTodo = ""
    @State private var allTodos: [TodoItem] = []
    private let todosKey = "todosKey"
    
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Add todo items...", text: $newTodo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        guard !self.newTodo.isEmpty else {return}
                        self.allTodos.append(TodoItem(todo: self.newTodo))
                        self.newTodo = ""
                        self.saveTodos()
                    }) {
                        Image(systemName: "plus")
                    }.padding(.leading, 5)
                }.padding()
                
                List {
                    ForEach(allTodos) {todoItem in
                        Text(todoItem.todo)
                    }.onDelete(perform: deleteTodos)
                }
            }.navigationTitle("Todos")
        }.onAppear(perform:  loadTodos)
    }
    
    private func deleteTodos(at offsets: IndexSet){
        self.allTodos.remove(atOffsets: offsets)
        saveTodos()
    }
    
    private func loadTodos(){
        if let todosData = UserDefaults.standard.value(forKey: todosKey) as? Data {
            if let todosList = try? PropertyListDecoder().decode(Array<TodoItem>.self, from: todosData){
                self.allTodos = todosList
            }
        }
    }
    
    private func saveTodos(){
        UserDefaults.standard.setValue(try? PropertyListEncoder().encode(self.allTodos), forKey: todosKey)
    }
}

struct TodoItem: Codable, Identifiable {
    var id = UUID()
    let todo: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
