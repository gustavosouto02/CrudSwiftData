//
//  ContentView.swift
//  MinimalToDo
//
//  Created by Gustavo Souto Pereira on 27/06/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            Home()
                .navigationTitle("Todo List")
        }
    }
}

#Preview {
    ContentView()
}
