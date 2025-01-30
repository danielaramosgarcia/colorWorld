//
//  selectImageViewModel.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 28/01/25.
//

import Foundation
import UIKit

@Observable
class UpdateEditFormViewModel {
    var id: Int = 0
    var name: String = ""
    var data: Data?
    var sample: SampleModel?
    var image: UIImage {
        if let data, let uiImage = UIImage(data: data) {
            return uiImage
        } else {
            return Constants.placeholder!
        }
    }

    init() {}
    init(sample: SampleModel) {
        self.sample = sample
        self.name = sample.name
        self.data = sample.data
        self.id = sample.id

    }

    @MainActor
    func clearImage() {
        data=nil
    }

    var isUpdating: Bool { sample != nil }
    var isDisabled: Bool { name.isEmpty }

}
