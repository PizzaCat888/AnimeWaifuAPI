//
//  MainView.swift
//  WaifuOrNot
//
//  Created by Wei Chang Lin on 2023-01-01.
//

import SwiftUI
import CachedAsyncImage
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
    
    @State private var scrollToTop = false

    func firstIndex(of item: Int) -> Int {
            return 0
        }

        // Dummy function to satisfy the `onChange` requirement
        func scrollTo(_ index: Int) { }
    

    var body: some View {
        
        NavigationStack {
            List(images, id: \.url) { item in
                VStack(alignment: .leading) {
                    CachedAsyncImage(url: URL(string: item.url)){ image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 350, height: 480)
                    .onLongPressGesture {
                                   print("long press gesture")
                               }
                    
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
            .navigationTitle("Anime Scroller")
            .navigationBarItems(trailing:
                                Button("Scroll to Top") {
                                    self.scrollToTop = true
                                    print("scroll to top button was pressed")
                                }) .onAppear {
                                    self.scrollToTop = false
                                                                    }
                                .onChange(of: scrollToTop, perform: { value in
                                    if value {
                                        // Find the index of the first item in the list
                                        let index = self.firstIndex(of: 0)

                                        // Scroll to the top of the list
                                        self.scrollTo(index)
                                    }
                                })
        }
           
    }
}
//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
