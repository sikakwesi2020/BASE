//
//  CustomDisclosureGroup.swift
//  BASE
//
//  Created by MAXWELL TAWIAH on 1/12/25.
//

import SwiftUI

struct CustomDisclosureGroup<Label: View, Content: View>: View {
    @Binding var isExpanded: Bool
    let label: () -> Label
    let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                label()
                Spacer()
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.secondary)
            }
            //.contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }
            //.padding(.vertical, 8)
            //.padding(.horizontal)

            if isExpanded {
                VStack(alignment: .leading) {
                    content()
                      //  .padding(.horizontal)
                        .padding(.bottom)
                }
               // .transition(.move(edge: .top))
            }
        }
        .background(Color.white)
       // .cornerRadius(8)
        //.shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
      
    }
}
