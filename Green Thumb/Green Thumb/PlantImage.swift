//
//  PlantImage.swift
//  Green Thumb
//
//  Created by Jared on 3/18/23.
//

import SwiftUI

struct PlantImage: View {
    
    let species: String
    let sign: (String, String)
    
    var body: some View {
        HStack {
            Spacer()
            ZStack(alignment: .bottomTrailing) {
                Image(species)
                VStack {
                    Text(species)
                    Text("\(sign.0) \(sign.1)")
                }
                .font(.caption)
                .fontWeight(.black)
                .padding(8)
                .foregroundColor(.white)
                .background(.black.opacity(0.75))
                .clipShape(Capsule())
                .offset(x: -5, y: -5)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            Spacer()
        }
    }
}

struct PlantImage_Previews: PreviewProvider {
    static var previews: some View {
        PlantImage(species: "Calathea", sign: ("Sagittarius", "♐️"))
    }
}
