//
//  ContactsFeatureTests.swift
//  ContactsFeatureTests
//
//  Created by Kang Minsang on 2023/08/28.
//

import XCTest
import ComposableArchitecture

@MainActor
final class ContactsFeatureTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddFlow() async {
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing // 0부터 순차적으로 증가하는 UUID 생성기
        }
        
        /// + 버튼 눌렀을 때 UUID(0)의 Contact값을 지닌 State 임을 확인
        await store.send(.addButtonTapped) {
            $0.destination = .addContact(
                AddContactFeature.State(
                    contact: Contact(id: UUID(0), name: "")
                )
            )
        }
        
        /// 사용자가 텍스트필드에 입력하는 것을 에뮬레이션
        await store.send(.destination(.presented(.addContact(.setName("Blob Jr."))))) {
            $0.$destination[case: /ContactsFeature.Destination.State.addContact]?.contact.name = "Blob Jr."
        }
        
        /// 사용자가 Save 버튼을 탭하는 것을 에뮬레이션
        await store.send(.destination(.presented(.addContact(.saveButtonTapped))))
        await store.receive(.destination(.presented(.addContact(.delegate(.saveContact(Contact(id: UUID(0), name: "Blob Jr."))))))
        ) {
            $0.contacts = [
                Contact(id: UUID(0), name: "Blob Jr.")
            ]
        }
        await store.receive(.destination(.dismiss)) {
            $0.destination = nil
        }
    }
    
    func testAddFlow_NonExhaustive() async {
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing // 0부터 순차적으로 증가하는 UUID 생성기
        }
        
        store.exhaustivity = .off // 비완전환 TestStore 에서는 원하지 않는 경우 상태 변경을 주장할 필요가 없습니다.
        
        await store.send(.addButtonTapped)
        await store.send(.destination(.presented(.addContact(.setName("Blob Jr.")))))
        await store.send(.destination(.presented(.addContact(.saveButtonTapped))))
        await store.skipReceivedActions() // 남은 모든 작업을 수행
        
        /// 최종 상태 확인
        store.assert {
            $0.contacts = [
                Contact(id: UUID(0), name: "Blob Jr.")
            ]
            $0.destination = nil
        }
    }
}
