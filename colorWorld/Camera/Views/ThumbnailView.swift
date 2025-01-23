//
//  ThumbnailView.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 21/01/25.
//

/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct ThumbnailView: View {
    var image: Image?
    var size: CGFloat

    init(image: Image? = nil, size: CGFloat = 41) {
        self.size = size
        self.image = image
    }

    var body: some View {
        ZStack {
            Color.white
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: size, height: size)
        .cornerRadius(11)
    }
}

struct ThumbnailView_Previews: PreviewProvider {
    static let previewImage = Image(systemName: "photo.fill")
    static var previews: some View {
        ThumbnailView(image: previewImage)
    }
}
