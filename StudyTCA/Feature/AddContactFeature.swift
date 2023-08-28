//
//  AddContactFeature.swift
//  StudyTCA
//
//  Created by Kang Minsang on 2023/08/28.
//

import ComposableArchitecture

struct AddContactFeature: Reducer {
    struct State: Equatable {
        var contact: Contact
    }
    
    enum Action: Equatable {
        /// "CANCEL" 버튼 액션
        case cancelButtonTapped
        /// 하위 Feature -> 상위 Feature로 원하는 작업을 알리는 이벤트
        case delegate(Delegate)
        /// "SAVE" 버튼 액션
        case saveButtonTapped
        /// 연락처 정보 생성 이벤트
        case setName(String)
        
        /// 하위 Feature -> 상위 Feature로 원하는 작업을 직접 알리기 위한 모든 작업들을 나열
        enum Delegate: Equatable {
            case saveContact(Contact)
        }
    }
    
    /// 상위 Feature와 직접적인 접근 없이 하위 Feature에서 스스로 dismiss할 수 있도록 하는 dependency 값
    @Dependency(\.dismiss) var dismiss
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .cancelButtonTapped:
            return .run { _ in
                await self.dismiss()
            }
            
        /// 상위 Feature 만이 Action에 따른 Effect를 응답해야 합니다.
        case .delegate:
            return .none
            
        case .saveButtonTapped:
            return .run { [contact = state.contact] send in
                await send(.delegate(.saveContact(contact)))
                await self.dismiss()
            }
            
        case let .setName(name):
            state.contact.name = name
            return .none
        }
    }
}
