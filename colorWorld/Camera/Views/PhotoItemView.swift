//
//  PhotoItemView.swift
//  colorWorld
//
//  Created by Daniela Ramos Garcia on 21/01/25.
//

/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI
import Photos

struct PhotoItemView: View {
    var asset: PhotoAsset
    var cache: CachedImageManager?
    var imageSize: CGSize

    @State private var image: Image?
    @State private var imageRequestID: PHImageRequestID?

    var body: some View {

        Group {
            if let image = image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                ProgressView()
                    .scaleEffect(0.5)
            }
        }
        .task {
            guard image == nil, let cache = cache else { return }
            imageRequestID = await cache.requestImage(for: asset, targetSize: imageSize) { result in
                Task {
                    if let result = result {
                        self.image = result.image
                    }
                }
            }
        }
    }
}

// #Preview {
//    PhotoItemView(asset: <#T##PhotoAsset#>, cache: <#T##CachedImageManager?#>, imageSize: <#T##CGSize#>, image: <#T##Image?#>, imageRequestID: <#T##PHImageRequestID?#>)
// }
