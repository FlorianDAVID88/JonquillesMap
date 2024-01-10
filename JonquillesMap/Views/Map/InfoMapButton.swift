//
//  InfoMapButton.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 20/12/2023.
//

import SwiftUI

struct InfoMapButton: View {
    @State private var infoClicked = false
    
    var body: some View {
         let url = URL(string: "https://www.fete-des-jonquilles-gerardmer-officiel.fr/wp-content/uploads/2022/08/220804-Base-vierge-plan-corso-6.png")!
        
         Button {
             infoClicked.toggle()
         } label: {
             Image(systemName: "info.circle.fill")
                 .imageScale(.large)
                 .scaledToFit()
                 .foregroundColor(.accentColor)
         }
         .alert("Cette map donne tous les endroits pour se loger, se restaurer ou se divertir. Si vous cherchez le plan du festival, il est est disponible via le lien", isPresented: $infoClicked) {
             Button("Ouvrir le lien", action: {
                 infoClicked = false
                 UIApplication.shared.open(url)
             })
             Button("Retour", action: { infoClicked = false })
         }
    }
}

#Preview {
    InfoMapButton()
}
