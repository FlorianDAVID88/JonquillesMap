//
//  ViewModifiers.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 13/12/2023.
//

import SwiftUI

struct FlowerFont: ViewModifier {
    @State var size: Int
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Fleurs de Liane", size: CGFloat(size)))
    }
}

struct JonquilleFont: ViewModifier {
    @State var size: Int
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Jonquilles_PersonalUseOnly", size: CGFloat(size)))
    }
}

#Preview {
    VStack(spacing: 15) {
        Text("Flower")
            .modifier(FlowerFont(size: 75))
            .foregroundColor(.purple)
        
        Text("Flower")
            .modifier(JonquilleFont(size: 60))
            .foregroundColor(.orange)
    }
}
