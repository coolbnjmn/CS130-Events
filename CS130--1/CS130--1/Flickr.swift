//
//  Flickr.swift
//  CS130--1
//
//  Created by Benjamin Hendricks on 3/31/15.
//  Copyright (c) 2015 BenjaminHendricks. All rights reserved.
//

import UIKit

let FLICKR_API_KEY = "1841d87292afbe9c627a5b82cf1416df"

class Flickr {
    
    enum SearchResult {
        case Results([Photo])
        case Error
    }
    
    typealias SearchCompletion = (result: SearchResult) -> Void
    
    class func search(term: String, completion: SearchCompletion) {
        let encodedTerm = (term as NSString).stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let searchURLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(FLICKR_API_KEY)&text=\(encodedTerm)&per_page=20&format=json&nojsoncallback=1&geocontext=2&content_type=1&sort=interestingness-desc"
        let request = NSURLRequest(URL: NSURL(string: searchURLString)!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) in
            if error != nil {
                println("Flickr error: \(error)")
                completion(result: .Error)
                return
            }
            
            let results: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
            if results == nil {
                completion(result: .Error)
                return
            }
            
            if let json = JSONValue.fromObject(results) {
                let status = json["stat"]?.string
                let photos = json["photos"]?["photo"]?.array
                if status != nil && status! == "ok" && photos != nil {
                    var flickrPhotos: [Photo] = []
                    for photo in photos! {
                        flickrPhotos.append(Photo.createFromJSON(photo))
                    }
                    completion(result: .Results(flickrPhotos))
                    return
                }
            }
            
            // If we get here, then must be error
            completion(result: .Error)
        }
    }
    
    class Photo {
        
        var farm: Int = 0
        var server: String = ""
        var secret: String = ""
        var photoID: String = ""
        
        var image: UIImage?
        var thumbnail: UIImage?
        
        class func createFromJSON(json: JSONValue) -> Photo {
            var photo = Photo()
            
            if let farm = json["farm"]?.integer {
                photo.farm = farm
            }
            if let server = json["server"]?.string {
                photo.server = server
            }
            if let secret = json["secret"]?.string {
                photo.secret = secret
            }
            if let photoID = json["id"]?.string {
                photo.photoID = photoID
            }
            
            return photo
        }
        
        enum PhotoResult {
            case Image(UIImage)
            case Error
        }
        typealias PhotoCompletion = (result: PhotoResult) -> Void
        
        func loadImage(thumbnail: Bool, completion: PhotoCompletion) {
            if self.image != nil && !thumbnail {
                completion(result: .Image(self.image!))
            } else if self.thumbnail != nil && thumbnail {
                completion(result: .Image(self.thumbnail!))
            }
            
            let size = thumbnail ? "m" : "b"
            
            let photoURLString = "http://farm\(self.farm).staticflickr.com/\(self.server)/\(self.photoID)_\(self.secret)_\(size).jpg"
            let request = NSURLRequest(URL: NSURL(string: photoURLString)!)
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) in
                if data != nil {
                    if let image = UIImage(data: data) {
                        if thumbnail {
                            self.thumbnail = image
                        } else {
                            self.image = image
                        }
                        completion(result: .Image(image))
                    } else {
                        completion(result: .Error)
                    }
                } else {
                    completion(result: .Error)
                }
            }
        }
        
    }
    
}
