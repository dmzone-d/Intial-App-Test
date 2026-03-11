//
//  ContentView.swift
//  InitialApp
//
//  Created by DMZone 10/03/26.
//

import SwiftUI

enum Emoji: String, CaseIterable {
    case Holiday, Sick, Vacation
}

struct ContentView: View {
    @State var selection: Emoji = .Sick
    
    var body: some View {
        NavigationView {
            VStack{
                Text(selection.rawValue)
                    .font(.system(size: 100))
                
                Picker("Select EMoji", selection: $selection){
                    ForEach(Emoji.allCases, id: \.self) { emoji in
                            Text(emoji.rawValue)
                    }
                    
                }
                .pickerStyle(.segmented)
            }
            .navigationTitle("Day-off request")
            .padding()
        }
        }
   
    }


#Preview {
    ContentView()
}
