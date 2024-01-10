//
//  StarRatingView.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 10/01/2024.
//

import SwiftUI

struct StarRatingView: View {
    @State var rating: Double
    
    var body: some View {
        HStack(spacing: 15) {
            if rating >= 0 && rating <= 5 {
                let tabStars = starImageName()
                HStack(spacing: 5) {
                    ForEach(tabStars, id: \.self) { star in
                        Image(systemName: star)
                            .foregroundColor(.yellow)
                    }
                }
                
                Text(String(format: "(%.1f)", rating))
                    .font(.system(size: 20))
            }
        }
    }
    
    private func starImageName() -> [String] {
        var tabStars: [String] = []
        var filledStars = min(max(0, rating), 5)
        
        while filledStars >= 1 {
            tabStars.append("star.fill")
            filledStars -= 1
        }
        
        if filledStars > 0 {
            tabStars.append(filledStars >= 0.5 ? "star.leadinghalf.fill" : "star")
        }
        
        while tabStars.count < 5 {
            tabStars.append("star")
        }
        
        return tabStars
    }
}

#Preview {
    StarRatingView(rating: 2.4)
}
