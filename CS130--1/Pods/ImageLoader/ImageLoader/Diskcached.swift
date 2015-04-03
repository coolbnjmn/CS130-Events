//
//  Diskcached.swift
//  ImageLoader
//
//  Created by Hirohisa Kawasaki on 12/21/14.
//  Copyright (c) 2014 Hirohisa Kawasaki. All rights reserved.
//

import Foundation
import UIKit

extension String {

    func escape() -> String {

        var str = CFURLCreateStringByAddingPercentEscapes(
            kCFAllocatorDefault,
            self,
            nil,
            "!*'\"();:@&=+$,/?%#[]% ",
            CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding))
        return str

    }
}

class Diskcached: NSObject {

    private var images: [NSURL: UIImage]  = [NSURL: UIImage]()

    class Directory: NSObject {
        override init() {
            super.init()
            createDirectory()
        }

        private func createDirectory() {
            let fileManager = NSFileManager.defaultManager()
            if fileManager.fileExistsAtPath(path) {
                return
            }

            fileManager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: nil)
        }

        var path: String {
            let cachePath = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0] as String
            let imagePath = "swift.imageloader.diskcached"

            return cachePath.stringByAppendingPathComponent(imagePath)
        }
    }
    let directory: Directory = Directory()

    private let _queue = dispatch_queue_create("swift.imageloader.queues.diskcached", DISPATCH_QUEUE_SERIAL)

}

// MARK: accessor

extension Diskcached {

    private func objectForKey(aKey: NSURL) -> UIImage? {

        if let image = images[aKey] {
            return image
        }

        if let data = NSData(contentsOfFile: savePath(aKey.absoluteString!)) {
            return UIImage(data: data)
        }

        return nil
    }
    private func savePath(name: String ) -> String {
        return directory.path.stringByAppendingPathComponent(name.escape())
    }

    private func setObject(anObject: UIImage, forKey aKey: NSURL) {

        images[aKey] = anObject

        let block: () -> () = {

            if let data = UIImageJPEGRepresentation(anObject, 1) {
                data.writeToFile(self.savePath(aKey.absoluteString!), atomically: false)
            }

            self.images[aKey] = nil
        }

        dispatch_async(_queue, block)
    }

}

// MARK: ImageLoaderCacheProtocol

extension Diskcached: ImageCache {

    private var _concurrent_queue: dispatch_queue_t {
        return dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT)
    }

    subscript (aKey: NSURL) -> UIImage? {

        get {
            var value : UIImage?
            dispatch_sync(_concurrent_queue) {
                value = self.objectForKey(aKey)
            }

            return value
        }

        set {
            dispatch_barrier_async(_concurrent_queue) {
                self.setObject(newValue!, forKey: aKey)
            }
        }
    }

}
