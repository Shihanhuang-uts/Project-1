//
//  StudyActivity.swift
//  Project1
//
//  Created by Manyue on 9/9/2024.
//

import Foundation
import SwiftUI

struct StudyActivity: Identifiable {
    let id = UUID()
    var date: Date
    var title: String
    var subtitle: String
    var color: Color
    var isCompleted: Bool = false
}




