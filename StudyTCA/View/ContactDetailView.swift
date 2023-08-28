//
//  ContactDetailView.swift
//  StudyTCA
//
//  Created by Kang Minsang on 2023/08/28.
//

import SwiftUI
import ComposableArchitecture

struct ContactDetailView: View {
    let store: StoreOf<ContactDetailFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Form {
                
            }
            .navigationTitle(Text(viewStore.contact.name))
        }
    }
}

struct ContactDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContactDetailView(
                store: Store(initialState: ContactDetailFeature.State(
                    contact: Contact(id: UUID(), name: "Blob")), reducer: {
                    ContactDetailFeature()
                })
            )
        }
    }
}
