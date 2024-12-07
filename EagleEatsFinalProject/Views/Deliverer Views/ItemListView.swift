//
//  ItemListView.swift
//  EagleEatsFinalProject
//
//  Created by Halen Hickman-Goveia on 12/4/24.
//

import SwiftUI

struct ItemListView: View {
    @State var order: Order
    var body: some View {
        NavigationStack{
            
            List{
                ForEach(order.items, id: \.number) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                    }
                }
            }
            .listStyle(.plain)
            .padding(.top)
            .navigationTitle("Order Items")
        }
    }
}

#Preview {
    ItemListView(order: Order())
}
