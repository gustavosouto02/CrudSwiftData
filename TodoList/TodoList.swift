//
//  TodoList.swift
//  TodoList
//
//  Created by Gustavo Souto Pereira on 27/06/25.
//

import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let entry = SimpleEntry(date: .now)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct TodoListEntryView : View {
    var entry: Provider.Entry
    
    @Query(todoDescriptor, animation: .snappy) private var activeList: [Todo]
    var body: some View {
        VStack {
            ForEach(activeList){ todo in
                HStack(spacing: 10){
                    Button(intent: ToggleButton(id: todo.taskID)){
                        Image(systemName: "circle")
                    }
                    .font(.callout)
                    .tint(todo.priority.color.gradient)
                    .buttonBorderShape(.circle)
                    
                    Text(todo.task)
                        .font(.callout)
                        .lineLimit(1)
                    
                    Spacer(minLength: 0)
                }
                .transition(.push(from: .bottom))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay{
            if activeList.isEmpty{
                Text("No Tasks🥳")
                    .font(.callout)
                    .transition(.push(from: .bottom))
            }
        }
    }
    
    static var todoDescriptor: FetchDescriptor<Todo> {
        let predicate = #Predicate<Todo> { !$0.isCompleted }
        let sort = [SortDescriptor(\Todo.lastUpdated, order: .reverse)]
        
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        descriptor.fetchLimit = 3
        return descriptor
            
    }
}

struct TodoList: Widget {
    let kind: String = "TodoList"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TodoListEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .modelContainer(for: Todo.self)
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("Tasks")
        .description("This is a Todo List.")
    }
}

struct ToggleButton: AppIntent{
    static var title: LocalizedStringResource = .init(stringLiteral: "Toggle's Todo State")
    
    @Parameter(title: "Todo ID")
    var id: String
    
    init(){
        
    }
    
    init(id: String){
        self.id = id
    }
    
    func perform() async throws -> some IntentResult {
        let context = try ModelContext(.init(for: Todo.self))
        
        let descriptor = FetchDescriptor(predicate: #Predicate<Todo> { $0.taskID == id })
        if let todo = try context.fetch(descriptor).first {
            todo.isCompleted = true
            todo.lastUpdated = .now
            
            try context.save()
        }
        return .result()
    }
}
