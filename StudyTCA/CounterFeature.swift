//
//  CounterFeature.swift
//  StudyTCA
//
//  Created by Kang Minsang on 2023/08/28.
//

import Foundation
import ComposableArchitecture

/// Reducer: 기능이 구축되는 기본 단위, 앱 기능의 논리와 동작을 나타냅니다.
struct CounterFeature: Reducer {
    /// 기능이 작업을 수행하는 데 필요한 상태를 보유하는 struct
    struct State: Equatable {
        var count = 0
    }
    
    /// 사용자가 기능에서 수행할 수 있는 모든 작업을 보유하는 enum
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
    }
    
    /// 사용자 작업에 따라 상태를 현재 값에서 다음 값으로 발전시키고, 기능이 외부 세계에서 실행하려는 모든 효과를 반환
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .decrementButtonTapped:
            state.count -= 1
            return .none
        case .incrementButtonTapped:
            state.count += 1
            return .none
        }
    }
}
