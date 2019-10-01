//
//  UIImage+LoadImage.swift
//  EasyMention
//
//  Created by Morteza on 9/30/19.
//
let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func imageFromServerURL(_ URLString: String) {
        
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if let err = error {
                    print("ERROR LOADING IMAGES FROM URL: \(err.localizedDescription)")
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
    
}

