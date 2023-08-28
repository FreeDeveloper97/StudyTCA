//
//  ContactsView.swift
//  StudyTCA
//
//  Created by Kang Minsang on 2023/08/28.
//

import SwiftUI
import ComposableArchitecture

struct ContactsView: View {
    let store: StoreOf<ContactsFeature>
    
    var body: some View {
        NavigationStack {
            /// WithViewStore를 통해 Reducer의 특정 state 값의 변화를 관찰할 수 있다.
            WithViewStore(self.store, observe: \.contacts) { viewStore in
                List {
                    ForEach(viewStore.state) { contact in
                        Text(contact.name)
                    }
                }
                .navigationTitle("Contacts")
                .toolbar {
                    ToolbarItem {
                        Button {
                            viewStore.send(.addButtonTapped)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView(
            store: Store(initialState: ContactsFeature.State(
                /// 초기 State 값들을 설정해줄 수 있다.
                contacts: [
                    Contact(id: UUID(), name: "Blob"),
                    Contact(id: UUID(), name: "Blob Jr"),
                    Contact(id: UUID(), name: "Blob Sr")
                ]
            ), reducer: {
                ContactsFeature()
            })
        )
    }
}
