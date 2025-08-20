import SwiftUI

struct ContentView: View {
    @State private var tasks: [Task] = []
    @State private var newTaskTitle = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    HStack {
                        TextField("Новая задача", text: $newTaskTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.system(size: 16))
                            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                        
                        Button(action: addTask) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                                .shadow(color: .blue.opacity(0.3), radius: 3, x: 0, y: 2)
                        }
                        .disabled(newTaskTitle.isEmpty)
                        .scaleEffect(newTaskTitle.isEmpty ? 0.9 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: newTaskTitle.isEmpty)
                    }
                    .padding(.horizontal)
                    
                    if !tasks.isEmpty {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Всего задач")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(tasks.count)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Выполнено")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(tasks.filter { $0.isCompleted }.count)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemBackground))
                                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(.systemGroupedBackground), Color(.systemBackground)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                if tasks.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 70))
                            .foregroundColor(.blue.opacity(0.3))
                            .shadow(color: .blue.opacity(0.1), radius: 10, x: 0, y: 5)
                        
                        VStack(spacing: 8) {
                            Text("Нет задач")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            Text("Добавьте первую задачу выше")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground))
                } else {
                    List {
                        ForEach(tasks) { task in
                            TaskRow(task: task) { updatedTask in
                                if let index = tasks.firstIndex(where: { $0.id == updatedTask.id }) {
                                    tasks[index] = updatedTask
                                }
                            }
                        }
                        .onDelete(perform: deleteTasks)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Список задач")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func addTask() {
        let task = Task(title: newTaskTitle, isCompleted: false)
        tasks.append(task)
        newTaskTitle = ""
    }
    
    private func deleteTasks(offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}

struct TaskRow: View {
    let task: Task
    let onUpdate: (Task) -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    var updatedTask = task
                    updatedTask.isCompleted.toggle()
                    onUpdate(updatedTask)
                }
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(task.isCompleted ? .green : .blue)
                    .scaleEffect(task.isCompleted ? 1.1 : 1.0)
                    .shadow(color: task.isCompleted ? Color.green.opacity(0.3) : Color.blue.opacity(0.3), radius: 2, x: 0, y: 1)
            }
            
            Text(task.title)
                .font(.system(size: 16, weight: .medium))
                .strikethrough(task.isCompleted)
                .foregroundColor(task.isCompleted ? .secondary : .primary)
                .lineLimit(2)
            
            Spacer()
            
            if task.isCompleted {
                Text("Готово")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.green)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.green.opacity(0.15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.green.opacity(0.3), lineWidth: 1)
                            )
                    )
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 4)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.03), radius: 1, x: 0, y: 1)
        )
        .contentShape(Rectangle())
    }
}

struct Task: Identifiable {
    let id = UUID()
    let title: String
    var isCompleted: Bool
}

#Preview {
    ContentView()
}
