//
//  NumberFactClient.swift
//  StudyTCA
//
//  Created by Kang Minsang on 2023/08/28.
//

import Foundation
import ComposableArchitecture

/// 종속성을 추상화하는 인터페이스를 모델링
struct NumberFactClient {
    var fetch: (Int) async throws -> String
}

extension NumberFactClient: DependencyKey {
    static let liveValue = Self(
        fetch: { number in
            let (data, _) = try await URLSession.shared
                .data(from: URL(string: "http://numbersapi.com/\(number)")!)
            return String(decoding: data, as: UTF8.self)
        }
    )
}

/// Reducer에서 @Dependency(\.numberFact) 로 사용가능한 computed property 설정
extension DependencyValues {
    /// fetch를 할 수 있는 struct의 추상화형태
    var numberFact: NumberFactClient {
        get { self[NumberFactClient.self] }
        set { self[NumberFactClient.self] = newValue }
    }
}
