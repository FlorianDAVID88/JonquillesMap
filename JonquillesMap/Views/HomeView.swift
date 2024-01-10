//
//  HomeView.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 04/12/2023.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image("logo-soc")
            
            Text("La Fête des jonquilles")
                .modifier(JonquilleFont(size: 50))
                .foregroundColor(.accentColor)
            
            VStack(spacing: 5) {
                Text("Chaque printemps, la jonquille pare d’or les coteaux de Gérardmer. Devenue emblème et même authentique patrimoine pour toute une ville, la jonquille engendre une véritable passion depuis 1935.")
                
                Text("Cueillies avec courage et respect par les centaines de petites mains des volontaires, elles habillent les chars créés par les constructeurs, véritables artistes et orfèvres.")
                
                Text("Ces chars défilent pour vous, au rythme de formations musicales venues de toute l’Europe. Alors qu’attendez-vous pour venir découvrir le spectacle de la Fête des jonquilles ?")
            }
            .modifier(JonquilleFont(size: 30))
            .foregroundColor(.yellow)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        }
    }
}

#Preview {
    HomeView()
}
