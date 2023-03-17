//
//  AstrologicalSignView.swift
//  Green Thumb
//
//  Created by Jared on 3/17/23.
//

import SwiftUI

struct AstrologicalSignView: View {
    
    @State private var inputDate = Date()
    
    var body: some View {
        Form {
            DatePicker(
                "Birthday",
                selection: $inputDate,
                displayedComponents: [.date]
            )
        }
    }
}

struct AstrologicalSignView_Previews: PreviewProvider {
    static var previews: some View {
        AstrologicalSignView()
    }
}
