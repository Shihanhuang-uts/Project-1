//
//  StudyActivity.swift
//  Project1
//
//  Created by Manyue on 9/9/2024.
//

import SwiftUI

struct StudyActivity: Identifiable, Codable {
    let id: UUID
    var date: Date
    var title: String
    var subtitle: String
    var color: Color
    var isCompleted: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, date, title, subtitle, isCompleted, colorData
    }

    // Encode the color to a codable Data object
    var colorData: Data {
        get {
            try! NSKeyedArchiver.archivedData(withRootObject: UIColor(color), requiringSecureCoding: false)
        }
        set {
            color = Color(UIColor(cgColor: try! NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: newValue)!.cgColor))
        }
    }

    // Custom init to handle decoding
    init(id: UUID = UUID(), date: Date, title: String, subtitle: String, color: Color, isCompleted: Bool = false) {
        self.id = id
        self.date = date
        self.title = title
        self.subtitle = subtitle
        self.color = color
        self.isCompleted = isCompleted
    }

    // Custom encoding to include the color conversion
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(title, forKey: .title)
        try container.encode(subtitle, forKey: .subtitle)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encode(colorData, forKey: .colorData)
    }

    // Custom decoding to handle the color conversion
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        title = try container.decode(String.self, forKey: .title)
        subtitle = try container.decode(String.self, forKey: .subtitle)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        let colorData = try container.decode(Data.self, forKey: .colorData)
        color = Color(UIColor(cgColor: try! NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)!.cgColor))
    }
}





