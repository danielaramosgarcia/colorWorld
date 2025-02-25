//
//  imageModel.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 24/01/25.
//

import Foundation
import UIKit
import SwiftData

@Model
class SampleModel {
    var id: UUID
    var name: String
    @Attribute(.externalStorage)
    var data: Data?
    var date: Date
    var img: UIImage? {
        if let data {
            return UIImage(data: data)
        } else {
            return nil
        }
    }
    init(id: UUID, name: String, data: Data? = nil, date: Date = Date()) {
        self.id = id
        self.name = name
        self.data = data
        self.date = date
    }
}

extension SampleModel {
    @MainActor
    static var preview: ModelContainer {
        do {
            let container = try ModelContainer(for: SampleModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
            let peoniesImage = UIImage(named: "peonies")
            let peoniesData = peoniesImage?.jpegData(compressionQuality: 1.0)
            let noCardsImage = UIImage(named: "boobie")
            let noCardsData = noCardsImage?.jpegData(compressionQuality: 1.0)
            let samples: [SampleModel] = [
                .init(id: UUID(), name: "Boobie goods", data: noCardsData),
                .init(id: UUID(), name: "Flowers", data: peoniesData),
                .init(id: UUID(), name: "Boobie", data: noCardsData)
            ]
            samples.forEach {
                container.mainContext.insert($0)
            }
            return container
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
}
