//
//  Contact.swift
//  StudyTCA
//
//  Created by Kang Minsang on 2023/08/28.
//

import Foundation

/// 연락처 정보 Model
struct Contact: Equatable, Identifiable {
    let id: UUID
    var name: String
}
