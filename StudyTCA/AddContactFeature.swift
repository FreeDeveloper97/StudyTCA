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
        /// "SAVE" 버튼 액션
        case saveButtonTapped
        /// 연락처 정보 생성 이벤트
        case setName(String)
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .cancelButtonTapped:
            return .none
            
        case .saveButtonTapped:
            return .none
            
        case let .setName(name):
            state.contact.name = name
            return .none
        }
    }
}
