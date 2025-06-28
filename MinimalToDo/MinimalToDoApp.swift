//
//  MinimalToDoApp.swift
//  MinimalToDo
//
//  Created by Gustavo Souto Pereira on 27/06/25.
//

import SwiftUI

@main
struct MinimalToDoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Todo.self)
    }
}
