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
        /// @PresentationState 프로퍼티래퍼를 사용하여 Destination.State 값을 통해 navigate 합니다.
        @PresentationState var destination: Destination.State?
        /// 연락처 정보들
        var contacts: IdentifiedArrayOf<Contact> = []
    }
    
    enum Action: Equatable {
        /// "+" 버튼 액션
        case addButtonTapped
        /// 연락처 삭제 액션
        case deleteButtonTapped(id: Contact.ID)
        /// destination 이벤트 (AddContact 또는 Alert)
        case destination(PresentationAction<Destination.Action>)
        
        /// alert를 표시하기 위한 모든 작업들
        enum Alert: Equatable {
            case confirmDeletion(id: Contact.ID)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.destination = .addContact(
                    AddContactFeature.State(
                        contact: Contact(id: UUID(), name: "")
                    )
                )
                return .none
                
            /// AddContactFeature 내에서 delegate로 .saveContact를 알리면 받은 contact를 토대로 현재 state 값에 반영한다.
            /// AddContactFeature 내에서 dismiss Effect를 수행하기에 nil값으로 설정할 필요가 없어진다.
            case let .destination(.presented(.addContact(.delegate(.saveContact(contact))))):
                state.contacts.append(contact)
                return .none
                
            case let .destination(.presented(.alert(.confirmDeletion(id: id)))):
                state.contacts.remove(id: id)
                return .none
                
            case .destination:
                return .none
                
            case let .deleteButtonTapped(id: id):
                state.destination = .alert(
                    AlertState {
                        TextState("Are you sure?")
                    } actions: {
                        ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
                            TextState("Delete")
                        }
                    }
                )
                return .none
            }
        }
        /// ifLet reducer operator를 통해 Destination Reducer를 ContactsFeature에 통합합니다.
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
    }
}

extension ContactsFeature {
    /// ContactsFeature 에서 navigate 될 수 있는 모든 기능에 대한 도메인과 로직을 담당합니다.
    struct Destination: Reducer {
        enum State: Equatable {
            case addContact(AddContactFeature.State)
            case alert(AlertState<ContactsFeature.Action.Alert>)
        }
        
        enum Action: Equatable {
            case addContact(AddContactFeature.Action)
            case alert(ContactsFeature.Action.Alert)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.addContact, action: /Action.addContact) {
                AddContactFeature()
            }
        }
    }
}
