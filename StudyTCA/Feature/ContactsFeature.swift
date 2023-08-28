//
//  ContactsFeature.swift
//  StudyTCA
//
//  Created by Kang Minsang on 2023/08/28.
//

import Foundation
import ComposableArchitecture

/// 연락처 정보들을 포함한 리듀서
struct ContactsFeature: Reducer {
    struct State: Equatable {
        /// @PresentationState 프로퍼티래퍼를 사용하여 다른 Feature의 기능의 상태를 함께 통합합니다.
        @PresentationState var addContact: AddContactFeature.State?
        /// @PresentationState 프로퍼티래퍼를 사용하여 alert 경고창을 표시합니다.
        @PresentationState var alert: AlertState<Action.Alert>?
        /// 연락처 정보들
        var contacts: IdentifiedArrayOf<Contact> = []
    }
    
    enum Action: Equatable {
        /// "+" 버튼 액션
        case addButtonTapped
        /// 연락처 추가화면 표시 이벤트, PresentationAction을 유지하는 케이스를 통해 다른 Feature의 작업을 함께 통합합니다.
        /// 이를 통해 부모는 자식 기능에서 전송된 모든 작업을 관찰할 수 있습니다.
        case addContact(PresentationAction<AddContactFeature.Action>)
        /// 연락처 삭제 경고창 표시 액션
        case alert(PresentationAction<Alert>)
        /// 연락처 삭제 액션
        case deleteButtonTapped(id: Contact.ID)
        
        /// alert를 표시하기 위한 모든 작업들
        enum Alert: Equatable {
            case confirmDeletion(id: Contact.ID)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.addContact = AddContactFeature.State(
                    contact: Contact(id: UUID(), name: "")
                )
                return .none
                
            /// AddContactFeature 내에서 delegate로 .saveContact를 알리면 받은 contact를 토대로 현재 state 값에 반영한다.
            /// AddContactFeature 내에서 dismiss Effect를 수행하기에 nil값으로 설정할 필요가 없어진다.
            case let .addContact(.presented(.delegate(.saveContact(contact)))):
                state.contacts.append(contact)
                return .none
                
            case .addContact:
                return .none
                
            case let .alert(.presented(.confirmDeletion(id: id))):
                state.contacts.remove(id: id)
                return .none
                
            case .alert:
                return .none
                
            case let .deleteButtonTapped(id: id):
                state.alert = AlertState {
                    TextState("Are you sure?")
                } actions: {
                    ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                        TextState("Delete")
                    }
                }
                return .none
            }
        }
        /// ifLet reducer operator를 통해 AddContactFeature를 ContactsFeature에 통합합니다.
        .ifLet(\.$addContact, action: /Action.addContact) {
            AddContactFeature()
        }
        /// ifLet reducer operator를 통해 alert 로직을 ContactsFeature에 통합합니다.
        .ifLet(\.$alert, action: /Action.alert)
    }
}
