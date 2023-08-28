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
        /// 연락처 정보들
        var contacts: IdentifiedArrayOf<Contact> = []
    }
    
    enum Action: Equatable {
        /// "+" 버튼 액션
        case addButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                // TODO: Handle action
                return .none
            }
        }
    }
}
