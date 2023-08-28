//
//  CounterFeatureTests.swift
//  CounterFeatureTests
//
//  Created by Kang Minsang on 2023/08/28.
//

import XCTest
import ComposableArchitecture

@MainActor
final class CounterFeatureTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// Reducer의 상태변경 테스트
    func testCounter() async {
        /// 기능의 동작이 어떻게 변경되는지 쉽게 확인할 수 있는 도구
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        /// 사용자가 수행하는 작업을 명시
        await store.send(.incrementButtonTapped) {
            /// 수행결과 예상값을 명시하여 테스트가 통과되는 조건을 명시
            $0.count = 1
        }
        await store.send(.decrementButtonTapped) {
            $0.count = 0
        }
    }
    
    /// Reducer의 Effect 수신 및 시간변화에 따른 상태변경 테스트
    func testTimer() async {
        /// Reducer로 전달 가능한, 시간을 제어할 수 있는 시계
        let clock = TestClock()
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            /// 제어가능한 시계를 dependency로 설정
            $0.continuousClock = clock
        }
        /// TestStore는 시간이 지남에 따라 전체 기능이 어떻게 발전하는지를 강요하므로, 모든 효과는 테스트가 끝나기 전에 완료되어야 하며 TestStore는 완료되도록 강제합니다.
        /// 이를 통해 실행중인지 몰랐고 예상하지 못한 작업을 시스템으로 다시 보내는 경우와 같은 버그를 잡는데 도움이 될 수 있습니다.
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = true
        }
        /// Reducer의 Effect를 수신받아 상태가 어떻게 변경되는지를 확인할 수 있습니다.
        /// 이때 제어 가능한 clock을 통해 시간변화도 조절할 수 있습니다.
        await clock.advance(by: .seconds(1))
        await store.receive(.timerTick) {
            $0.count = 1
        }
        /// 타이머를 정지시키는 작업을 통해 에뮬레이션 합니다.
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = false
        }
        /// 시간변화를 조정할 수 있기에 즉시 원하는 시나리오를 테스트할 수 있습니다.
    }
}
