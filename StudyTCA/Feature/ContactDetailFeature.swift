//
//  ContactDetailFeature.swift
//  StudyTCA
//
//  Created by Kang Minsang on 2023/08/28.
//

import ComposableArchitecture

struct ContactDetailFeature: Reducer {
    struct State: Equatable {
        let contact: Contact
    }
    
    enum Action: Equatable {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}
