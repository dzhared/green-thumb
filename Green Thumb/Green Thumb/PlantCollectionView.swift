//
//  PlantCollectionView.swift
//  Green Thumb
//
//  Created by Jared on 3/9/23.
//

import SwiftUI

struct CollectionView: View {
    
    @StateObject var plants = UserPlants()
    @State var showingAddView = false
    
    func removeItems(at offsets: IndexSet) {
        plants.plants.remove(atOffsets: offsets)
    }
    
    var body: some View {
        NavigationView {
            List {
                // id: \.name is used when every item is sure to have a unique name
                // Do not need "id: \.id" if struct is designated Identifiable
                Section(header: Text("My Plants")) {
                    ForEach(plants.plants) { plant in
                        HStack {
                            // TODO: Source clearer, cited plant photos
                            Image(plant.name)
                                .resizable()
                                .scaledToFill()
                                .frame(width:50, height:50)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(.white, lineWidth: 2)
                                )
                                .padding()
                            VStack(alignment: .leading) {
                                Text(plant.nickName)
                                    .font(.title3)
                                Text(plant.description)
                            }
                        }
                    }
                    .onDelete(perform: removeItems)
                }
            }
            .background(Color.darkGreen)
            .navigationTitle("My Plants")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar() {
                EditButton()
            }
        }
        
        
        
        
        
        //        NavigationView {
        //            ScrollView {
        //                LazyVStack(spacing: 4) {
        //                    ForEach(plants.plants) { plant in
        //                        HStack {
        //                            Text(plant.nickName)
        //                            Text(plant.name)
        //                                .font(.headline)
        //                                .foregroundColor(.white)
        //                        }
        //                        .padding(.vertical)
        //                        .frame(maxWidth: .infinity, maxHeight: 70)
        //                        .background(.ultraThinMaterial)
        //                        .clipShape(RoundedRectangle(cornerRadius: 10))
        //                        .overlay(
        //                            RoundedRectangle(cornerRadius: 10)
        //                                .strokeBorder(.white, lineWidth: 2)
        //                        )
        //                    }
        //                }
        //            }
        //            .background(Color.darkGreen)
        //            .preferredColorScheme(.dark)
        //            .navigationTitle("My Plants")
        //            .navigationBarTitleDisplayMode(.inline)
        //            .toolbar() {
        //                Button("Add Plant") { }
        //                    .foregroundColor(.white)
        //            }
        //        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView()
    }
}
