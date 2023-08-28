//
//  ContactsFeature.swift
//  StudyTCA
//
//  Created by Kang Minsang on 2023/08/28.
//

import Foundation
import ComposableArchitecture

/// 연락처 정보 Model
struct Contact: Equatable, Identifiable {
    let id: UUID
    var name: String
}

/// 연락처 정보들을 포함한 리듀서
struct ContactsFeature: Reducer {
    struct State: Equatable {
        /// @PresentationState 프로퍼티래퍼를 사용하여 다른 Feature의 기능의 상태를 함께 통합합니다.
        @PresentationState var addContact: AddContactFeature.State?
        /// 연락처 정보들
        var contacts: IdentifiedArrayOf<Contact> = []
    }
    
    enum Action: Equatable {
        /// "+" 버튼 액션
        case addButtonTapped
        /// 연락처 추가화면 표시 이벤트, PresentationAction을 유지하는 케이스를 통해 다른 Feature의 작업을 함께 통합합니다.
        /// 이를 통해 부모는 자식 기능에서 전송된 모든 작업을 관찰할 수 있습니다.
        case addContact(PresentationAction<AddContactFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.addContact = AddContactFeature.State(
                    contact: Contact(id: UUID(), name: "")
                )
                return .none
                
            /// AddContactFeature 내에서 .cancelButtonTapped Effect가 발생하면 해당 기능을 닫고 다른 작업을 수행하지 않으려면 간단히 상태를 없애면 된다.
            case .addContact(.presented(.cancelButtonTapped)):
                state.addContact = nil
                return .none
            
            /// AddContactFeature 내에서 .saveButtonTapped Effect가 발생하면 contact 값을 접근하여 현재 state 값에 반영한다.
            case .addContact(.presented(.saveButtonTapped)):
                guard let contact = state.addContact?.contact else {
                    return .none
                }
                state.contacts.append(contact)
                state.addContact = nil
                return .none
                
            case .addContact:
                return .none
            }
        }
        /// ifLet reducer operator를 통해 Reducer를 함께 통합합니다.
        .ifLet(\.$addContact, action: /Action.addContact) {
            AddContactFeature()
        }
    }
}
