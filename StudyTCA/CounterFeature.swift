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
        var fact: String?
        var isLoading = false
        var isTimerRunning = false
    }
    
    /// 사용자가 기능에서 수행할 수 있는 모든 작업을 보유하는 enum
    enum Action: Equatable {
        case decrementButtonTapped
        case factButtonTapped
        case factResponse(String)
        case incrementButtonTapped
        case timerTick
        case toggleTimerButtonTapped
    }
    
    /// effect cancellation 기능으로 특정 Effect를 취소할 수 있습니다.
    enum CancelID {
        case timer
    }
    
    /// dependency management system을 통해 제어 가능한 시계를 제공
    @Dependency(\.continuousClock) var clock
    
    /// 사용자 작업에 따라 상태를 현재 값에서 다음 값으로 발전시키고, 기능이 외부 세계에서 실행하려는 모든 효과를 반환
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .decrementButtonTapped:
            state.count -= 1
            state.fact = nil
            return .none
            
        case .factButtonTapped:
            state.fact = nil
            state.isLoading = true
            return .run { [count = state.count] send in
                // 여기서 비동기 작업을 수행한 후, Effect를 시스템으로 다시 보냅니다.
                let (data, _) = try await URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(count)")!)
                let fact = String(decoding: data, as: UTF8.self)
                // inout 값을 비동기작업에서 접근할 수 없기에 새로운 Action이 발생되는 구조
                await send(.factResponse(fact))
            }
            
        case let .factResponse(fact):
            state.fact = fact
            state.isLoading = false
            return .none
            
        case .incrementButtonTapped:
            state.count += 1
            state.fact = nil
            return .none
            
        case .timerTick:
            state.count += 1
            state.fact = nil
            return .none
            
        case .toggleTimerButtonTapped:
            state.isTimerRunning.toggle()
            
            if state.isTimerRunning {
                return .run { send in
                    for await _ in self.clock.timer(interval: .seconds(1)) {
                        await send(.timerTick)
                    }
                }
                .cancellable(id: CancelID.timer) // 해당 Effect를 취소 가능하도록 설정
            } else {
                return .cancel(id: CancelID.timer) // 특정 Effect를 취소
            }
        }
    }
}
