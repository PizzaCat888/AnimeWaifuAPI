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
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var counter = 0
    
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
                    .frame(width: 300, height: 480)
                    
                    
                }
                
                    ShareLink(item: item.source) {
                        Label("Share", systemImage:  "square.and.arrow.up")
                    }
                    
                    NavigationLink {
                         LikesView(animePic: item.url)
                    }
                    label: {
                        Label("More Detail", systemImage: "plus.magnifyingglass")
                    }
                    
                
             
                
            }.task {
                if runFunction{
                 runLoadData()
                 disableTask()
                }
            }.onReceive(timer) { time in
                if images.isEmpty && counter > 3 {
                    print(time)
                    runLoadData()
                }
                if counter == 10 {
                    timer.upstream.connect().cancel()
                    print("timer has stopped")
                }
                counter += 1
            }.refreshable {
                runLoadData()
            }
            
           
        } .navigationBarItems(trailing:
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
//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
