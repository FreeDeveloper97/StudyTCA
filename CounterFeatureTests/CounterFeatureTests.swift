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
}
