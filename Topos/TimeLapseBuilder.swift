//
//  TimeLapseBuilder.swift
//
//  Created by Adam Jensen on 5/10/15.
//  Copyright (c) 2015 Adam Jensen. All rights reserved.
//

import AVFoundation
import UIKit

let kErrorDomain = "TimeLapseBuilder"
let kFailedToStartAssetWriterError = 0
let kFailedToAppendPixelBufferError = 1



open class TimeLapseBuilder: NSObject {
  let photoURLs: [String]
  var videoWriter: AVAssetWriter?
  var outputSize = CGSize(width: 1920, height: 1080)
  
  public init(photoURLs: [String]) {
    self.photoURLs = photoURLs
    
    super.init()
  }
  
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
  open func build(outputSize: CGSize, progress: @escaping ((Progress) -> Void), success: @escaping ((URL) -> Void), failure: ((NSError) -> Void)) {

    self.outputSize = outputSize
    var error: NSError?
    
    //let startTime = Date.timeIntervalSinceReferenceDate
    
    let fileManager = FileManager.default
    let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    guard let documentDirectory: URL = urls.first else {
      fatalError("documentDir Error")
    }
    
    let random = randomString(length: 8)
    
    let nombreArchivo = random + ".mov"
    
    let videoOutputURL = documentDirectory.appendingPathComponent(nombreArchivo)
    
    if FileManager.default.fileExists(atPath: videoOutputURL.path) {
      do {
        try FileManager.default.removeItem(atPath: videoOutputURL.path)
      }catch{
        fatalError("Unable to delete file: \(error) : \(#function).")
      }
    }
    
    guard let videoWriter = try? AVAssetWriter(outputURL: videoOutputURL, fileType: AVFileTypeQuickTimeMovie) else{
      fatalError("AVAssetWriter error")
    }
    
    let outputSettings = [
      AVVideoCodecKey  : AVVideoCodecH264,
      AVVideoWidthKey  : NSNumber(value: Float(outputSize.width) as Float),
      AVVideoHeightKey : NSNumber(value: Float(outputSize.height) as Float),
    ] as [String : Any]
    
    guard videoWriter.canApply(outputSettings: outputSettings, forMediaType: AVMediaTypeVideo) else {
      fatalError("Negative : Can't apply the Output settings...")
    }
    
    let videoWriterInput = AVAssetWriterInput(mediaType: AVMediaTypeVideo, outputSettings: outputSettings)
    
    let sourcePixelBufferAttributesDictionary = [
      kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32ARGB as UInt32),
      kCVPixelBufferWidthKey as String: NSNumber(value: Float(outputSize.width) as Float),
      kCVPixelBufferHeightKey as String: NSNumber(value: Float(outputSize.height) as Float),
    ]
    
    let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(
      assetWriterInput: videoWriterInput,
      sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary
    )
    
    assert(videoWriter.canAdd(videoWriterInput))
    videoWriter.add(videoWriterInput)
    
    if videoWriter.startWriting() {
      videoWriter.startSession(atSourceTime: kCMTimeZero)
      assert(pixelBufferAdaptor.pixelBufferPool != nil)
      
      let media_queue = DispatchQueue(label: "mediaInputQueue", attributes: [])
      
      videoWriterInput.requestMediaDataWhenReady(on: media_queue, using: { () -> Void in
        let fps: Int32 = 1
        let frameDuration = CMTimeMake(1, fps)
        let currentProgress = Progress(totalUnitCount: Int64(self.photoURLs.count))
        
        var frameCount: Int64 = 0
        var remainingPhotoURLs = [String](self.photoURLs)
        
        
        while (!remainingPhotoURLs.isEmpty) {
          //print("\(videoWriterInput.isReadyForMoreMediaData) : \(remainingPhotoURLs.count)")
          
          if (videoWriterInput.isReadyForMoreMediaData) {
            let nextPhotoURL = remainingPhotoURLs.remove(at: 0)
            let lastFrameTime = CMTimeMake(frameCount, fps)
            let presentationTime = frameCount == 0 ? lastFrameTime : CMTimeAdd(lastFrameTime, frameDuration)
            
            
            if !self.appendPixelBufferForImageAtURL(nextPhotoURL, pixelBufferAdaptor: pixelBufferAdaptor, presentationTime: presentationTime) {
              error = NSError(domain: kErrorDomain, code: kFailedToAppendPixelBufferError,
                userInfo: [
                  "description": "AVAssetWriterInputPixelBufferAdapter failed to append pixel buffer",
                  "rawError": videoWriter.error ?? "(none)"
                ])
              
              break
            }
            
            frameCount += 1
            
           // print("\(CMTimeGetSeconds(presentationTime)) : \(currentProgress.completedUnitCount)|\(currentProgress.totalUnitCount)")
            
            currentProgress.completedUnitCount = frameCount
            progress(currentProgress)
          }
        }
        
        //let endTime = Date.timeIntervalSinceReferenceDate
        //let elapsedTime: TimeInterval = endTime - startTime
        
        //print("rendering time \(self.stringFromTimeInterval(elapsedTime))")

        
        videoWriterInput.markAsFinished()
        videoWriter.finishWriting { () -> Void in
          if error == nil {
            success(videoOutputURL)
          }
        }
      })
      

    } else {
      error = NSError(domain: kErrorDomain, code: kFailedToStartAssetWriterError,
        userInfo: ["description": "AVAssetWriter failed to start writing"]
      )
    }
    
    if let error = error {
      failure(error)
    }
  }
  
  open func appendPixelBufferForImageAtURL(_ urlString: String, pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor, presentationTime: CMTime) -> Bool {
    var appendSucceeded = true
    
    autoreleasepool {
      
      if let image = UIImage(contentsOfFile: urlString) {
        var pixelBuffer: CVPixelBuffer? = nil
        let status: CVReturn = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pixelBufferAdaptor.pixelBufferPool!, &pixelBuffer)

        if let pixelBuffer = pixelBuffer, status == 0 {
          let managedPixelBuffer = pixelBuffer

          fillPixelBufferFromImage(image, pixelBuffer: managedPixelBuffer, contentMode: UIViewContentMode.scaleAspectFit)

          appendSucceeded = pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime)

        } else {
          NSLog("error: Failed to allocate pixel buffer from pool")
        }
      }
    }
    
    return appendSucceeded
  }
  
  // http://stackoverflow.com/questions/7645454

  func fillPixelBufferFromImage(_ image: UIImage, pixelBuffer: CVPixelBuffer, contentMode:UIViewContentMode){

    CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
    
    let data = CVPixelBufferGetBaseAddress(pixelBuffer)
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let context = CGContext(data: data, width: Int(self.outputSize.width), height: Int(self.outputSize.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
    
    context?.clear(CGRect(x: 0, y: 0, width: CGFloat(self.outputSize.width), height: CGFloat(self.outputSize.height)))
    
    let horizontalRatio = CGFloat(self.outputSize.width) / image.size.width
    let verticalRatio = CGFloat(self.outputSize.height) / image.size.height
    var ratio: CGFloat = 1
    
    switch(contentMode) {
    case .scaleAspectFill:
      ratio = max(horizontalRatio, verticalRatio)
    case .scaleAspectFit:
      ratio = min(horizontalRatio, verticalRatio)
    default:
      ratio = min(horizontalRatio, verticalRatio)
    }
    
    let newSize:CGSize = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)
    
    let x = newSize.width < self.outputSize.width ? (self.outputSize.width - newSize.width) / 2 : 0
    let y = newSize.height < self.outputSize.height ? (self.outputSize.height - newSize.height) / 2 : 0
    
    context?.draw(image.cgImage!, in: CGRect(x: x, y: y, width: newSize.width, height: newSize.height))
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
  }
  
  
  func stringFromTimeInterval(_ interval: TimeInterval) -> String {
    let ti = NSInteger(interval)
    let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 1000)
    let seconds = ti % 60
    let minutes = (ti / 60) % 60
    let hours = (ti / 3600)
    
    if hours > 0 {
      return NSString(format: "%0.2d:%0.2d:%0.2d.%0.2d", hours, minutes, seconds, ms) as String
    }else if minutes > 0 {
      return NSString(format: "%0.2d:%0.2d.%0.2d", minutes, seconds, ms) as String
    }else {
      return NSString(format: "%0.2d.%0.2d", seconds, ms) as String
    }
  }

}
