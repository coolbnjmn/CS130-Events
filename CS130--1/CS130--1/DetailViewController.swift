//
//  DetailViewController.swift
//  CS130--1
//
//  Created by Benjamin Hendricks on 3/31/15.
//  Copyright (c) 2015 BenjaminHendricks. All rights reserved.
//

import UIKit
import ImageLoader

class ImageViewCell: UITableViewCell {
    
    @IBOutlet weak var newImageView: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension UIImage {
    public func resize(size:CGSize, completionHandler:(resizedImage:UIImage, data:NSData)->()) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
            var newSize:CGSize = size
            let rect = CGRectMake(0, 0, newSize.width, newSize.height)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            self.drawInRect(rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let imageData = UIImageJPEGRepresentation(newImage, 0.5)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(resizedImage: newImage, data:imageData)
            })
        })
    }
}

class DetailViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var detailImage: UIImageView!

    var photos: [Flickr.Photo] = []

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
        
//        let URL : NSURL = NSURL(string: "http://www.h3dwallpapers.com/wp-content/uploads/2014/11/Landscape_sunset.jpg")!
//        println(detailImage)
//        detailImage.load(URL)
//        var imageView = PASImageView(frame: CGRectMake(0, 0, 200, 200))
//        imageView.center = CGPointMake(view.bounds.width / 2, view.bounds.height / 2)
//        
//        imageView.backgroundProgressColor(UIColor.whiteColor())
//        imageView.progressColor(UIColor.redColor())
//        view.addSubview(imageView)
//  
        println(photos);
//        var imageView = UIImageView()
//        imageView.center = CGPointMake(view.bounds.width/2, view.bounds.height / 2)
//      
        
        
        let randO = Int(arc4random_uniform(UInt32(photos.count)))
        println(photos[randO])
        photos[randO].loadImage(true) {
            switch $0 {
            case .Error:
                break
            case .Image(let image):
                println(self.detailImage)
//                image.resize(cell.frame.size) {
//                    self.detailImage.image = image
//                }
//                self.detailImage.image = image
            }
        }

        
        /*
        if let anURL = NSURL(string: "http://feelgrafix.com/data_images/out/10/839204-landscape-sunset.jpg") {
            imageView.imageURL(anURL)
        }
*/
        

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int
    {
        println(self.photos.count)
        return self.photos.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell
    {
        // 1
        var cell:ImageViewCell =
        tableView.dequeueReusableCellWithIdentifier("Cell",
            forIndexPath: indexPath) as ImageViewCell
        
        
        let photo = self.photos[indexPath.row]
//        cell.imageView?.frame = cell.frame
        self.photos[indexPath.row].loadImage(true) {
            switch $0 {
            case .Error:
                break
            case .Image(let image):
                // resize image here
//                let resizedMaskedImage = Toucan(image: image).resize(cell.frame.size).maskWithRoundedRect(cornerRadius: 30, borderWidth: 10, borderColor:UIColor.blueColor())
                println(self.detailImage)
                image.resize(cell.frame.size) {
                    [weak self](resizedImage, data) -> () in
                    
                    let image = resizedImage
//                    cell.imageView?.layer.cornerRadius = 100
                    cell.newImageView.layer.cornerRadius = 25
                    cell.newImageView.frame = cell.frame

                    cell.newImageView.image = image
                }
            }
        }
        println(cell)
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
}


