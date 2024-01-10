//
//  SliderSignView.swift
//  JonquillesMap
//
//  Created by Florian DAVID on 13/12/2023.
//

import SwiftUI

struct SliderSignView: View {
    @State private var isShowingSignIn = true
    @Binding var isShowingMenu: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                if isShowingSignIn {
                    SignInView(isShowingSignIn: $isShowingSignIn, isShowingMenu: $isShowingMenu)
                        .transition(.move(edge: .trailing))
                } else {
                    SignUpView(isShowingSignIn: $isShowingSignIn, isShowingMenu: $isShowingMenu)
                        .transition(.move(edge: .trailing))
                }
            }
            .navigationBarTitle(isShowingSignIn ? "Sign in" : "Sign up", displayMode: .inline)
            .navigationBarItems(
                leading:
                    Button {
                        isShowingMenu = false
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.accentColor)
                    }
            )
        }
    }
}

#Preview {
    SliderSignView(isShowingMenu: .constant(true))
}
