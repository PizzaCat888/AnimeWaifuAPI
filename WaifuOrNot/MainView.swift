//
//  MainView.swift
//  WaifuOrNot
//
//  Created by Wei Chang Lin on 2023-01-01.
//

import SwiftUI

//class ImagesAPI: ObservableObject {
//    @Published var image = [Image]()
//}

struct MainView: View {
    
    @State private var images = [Image]()
    
    func loadData() async {
        
        guard let url = URL(string: "https://api.waifu.im/search/?included_tags=waifu&many=true") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                
                images = decodedResponse.images
                print(images[0])
                
            }
            
        } catch {
            print("Invalid data")
        }
        
        
    }
    
    @State private var runFunction = true
      
      func disableTask() {
          runFunction = false
      }

      func runLoadData() {
          Task{
              await loadData()
          }
      }
    
//    @State private var isLiked = false
////    @State private var numbers = Array(0...30)
//    Label("", systemImage: isLiked ? "heart.fill" : "heart")
    
    
    var body: some View {
        
        NavigationView {
            List(images, id: \.url) { item in
                VStack(alignment: .leading) {
                    AsyncImage(url: URL(string: item.url)){ image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 350, height: 480)
                    .gesture(
                        TapGesture(count: 2)
                                        .onEnded {
                                            print("double tapped")
                                        }
                                )
                    
                }
                ShareLink(item: item.source) {
                    Label("", systemImage:  "square.and.arrow.up")
                }
                
                                    
                
                
                
            }.task {
                if runFunction {
                 runLoadData()
                 disableTask()
                }
            }
        }
    }
}
//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
