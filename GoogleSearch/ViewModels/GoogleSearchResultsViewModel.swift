//
//  GoogleSearchResultsViewModel.swift
//  GoogleSearch
//
//  Created by Deep on 23/11/19.
//  Copyright © 2019 Deep. All rights reserved.
//

import UIKit


typealias ApiCompletionHandler = (_ errorData: ErrorResponse?) -> ()

class GoogleSearchResultsViewModel: NSObject {
    
    static var cachedImage = NSCache<NSString, NSData>()
    var searchResults = Items()
    let googleSearchUrl = "https://www.googleapis.com/customsearch/v1?q="
    
    func fetchSearchResults(searchString: String, completion: ApiCompletionHandler?) {
        let searchStr = searchString.replacingOccurrences(of: " ", with: "+")
        let url = URL.init(string: googleSearchUrl+"\(searchStr)&cx=011476162607576381860:ra4vmliv9ti&key=\(API_KEY)")
        if (url != nil) {
            let session = URLSession.shared
            let data = session.dataTask(with: url!) { (data, response, error) in
                guard let data = data
                    else {
                        return
                }
                do {
                    let info = try JSONDecoder().decode(
                        Items.self, from: data)
                    self.searchResults = info
                    completion?(nil)
                } catch {
                    completion?(error as? ErrorResponse)
                    
                }
            }
            data.resume()
        }
    }
    
    func downloadImage(stringUrl: String, completion: CompletionHandler) {
        
        let url = URL.init(string: stringUrl)
        if let data = (getCacheImage(url: stringUrl as NSString)) {
            print("Yippie I got cached !!!!")
            completion?(data)
        } else {
            print("Oops I have to call API :(")
            if (url != nil) {
                let session = URLSession.shared
                session.dataTask(with: url!) { (data, response, error) in
                    if let data = data {
                        self.setDownloadedImageToCache(data: data, stringUrl: stringUrl)
                    }
                    guard data != nil
                        else {
                            return
                    }
                    completion?(data)
                    }.resume()
            }
        }
    }
    
    private func getCacheImage(url: NSString) -> Data? {
        if let imageData = GoogleSearchResultsViewModel.cachedImage.object(forKey: url) {
            return imageData as Data
        } else {
            return nil
        }
    }
    
    private func setDownloadedImageToCache(data: Data, stringUrl: String) {
        GoogleSearchResultsViewModel.cachedImage.setObject(data as NSData, forKey: stringUrl as NSString)
    }
}
