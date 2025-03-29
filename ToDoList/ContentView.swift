//
//  ContentView.swift
//  ToDoList
//
//  Created by Roman on 16.03.2025.
//

import SwiftUI
import Observation

struct Task: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool
}

@Observable
class TaskViewModel {
    var tasks: [Task] = []
    
    func addTask(title: String) {
        tasks.append(Task(title: title, isCompleted: false))
    }
    
    func toggleCompletion(for task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id}) {
            tasks[index].isCompleted.toggle()
        }
    }

    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }

    
}

struct ContentView: View {
    @State private var viewModel = TaskViewModel()
    @State private var newTaskTitle: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Enter new task", text: $newTaskTitle)
                        .textFieldStyle(.roundedBorder)
                    
                    Button {
                        guard !newTaskTitle.isEmpty else { return }
                        viewModel.addTask(title: newTaskTitle)
                        newTaskTitle = ""
                    
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
                .buttonStyle(.borderless)
                .tint(.blue)
                }
                .padding()
                
                List {
                    ForEach(viewModel.tasks) { task in
                        HStack {
                            Text(task.title)
                                .strikethrough(task.isCompleted)
                                .foregroundStyle(task.isCompleted ? .gray : .primary)
                            Spacer()
                            Button {
                                viewModel.toggleCompletion(for: task)
                            } label: {
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            }
                            .buttonStyle(.borderless)
                            .tint(task.isCompleted ? .green : .gray)
                            }
                        }
                    .onDelete(perform: viewModel.deleteTask)
                    }
                }
            .navigationTitle("ToDo List")
            .toolbar {
                EditButton()
                
            }
        
        }

    }
}

#Preview {
    ContentView()
}
