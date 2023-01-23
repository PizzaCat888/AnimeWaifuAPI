//
//  LikesView.swift
//  WaifuOrNot
//
//  Created by Wei Chang Lin on 2023-01-01.
//

import SwiftUI
import CachedAsyncImage
struct LikesView: View {
    
    let animePic: String
    
    init(animePic: String) {
        self.animePic = animePic
        
    }
    var body: some View {
       
        CachedAsyncImage(url: URL(string: animePic)){ image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            ProgressView()
        }
        .frame(width: 350, height: 500)
        
        VStack {
            ShareLink(item: animePic) {
                Label("", systemImage:  "square.and.arrow.up").font(.system(size: 30))
            }
            
        }
        
       
    }
    }


//struct LikesView_Previews: PreviewProvider {
//    static var previews: some View {
//        LikesView()
//    }
//}
