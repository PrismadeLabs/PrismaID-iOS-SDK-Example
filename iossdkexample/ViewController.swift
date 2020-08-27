//
//  ViewController.swift
//  websdkintegration
//
//  Created by Zdenek Skalnik on 14/04/2019.
//  Copyright © 2019 Prismade Labs GmbH. All rights reserved.
//

import UIKit
import AVFoundation
import PrismaID

class ViewController: UIViewController {

    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var handImageView: UIImageView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var handTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var handTrailingConstraint: NSLayoutConstraint!
    
    var successSound: AVAudioPlayer?
    var scale: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        successSound = SoundPlayerHelper.createPlayerForSound("success")

        if let view: PLRecordingView = self.view as? PLRecordingView {
            // OBe34Nnhp16K2C5qlQlIO6sqM6l4gIXP2Wwhe8wQ - with offlineConfig
            // LBEJRIa8bv82FO5tTAHHV3jHnAtoJn4V8jNCSvIe
            // 36gap5I6Cb8FZ49q12brK8FNGSnHfgcY9XnBeWRg
            view.initialiseSDK(APIKey: "36gap5I6Cb8FZ49q12brK8FNGSnHfgcY9XnBeWRg", serverURL: "https://api-dev.prismade.net/prismaid", twoFingerHoldingMode: true, jsInterface: self)
        }
        
        prepareHandAnimation()
    }

    fileprivate func prepareHandAnimation() {
        cardImageView.alpha = 0.0
        handImageView.alpha = 0.0
        thumbImageView.alpha = 0.0
    }
    
    fileprivate func initHandAnimation() {
        handTopConstraint.constant = 600.0
        handTrailingConstraint.constant = 600.0
        
        handImageView.transform = CGAffineTransform(scaleX: scale * 1.1, y: scale * 1.1)
        handImageView.alpha = 1.0
        
        cardImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        cardImageView.alpha = 1.0

        thumbImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        thumbImageView.alpha = 1.0

        view.layoutIfNeeded()
    }
    
    fileprivate func handOnPlaceAnimation() {
        handTopConstraint.constant = scale * 380.0
        handTrailingConstraint.constant = scale * 342.0

        UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: { finished in
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseOut], animations: {
                self.handImageView.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
            }, completion: { finished in
                self.handUpAnimation()
            })
        })
    }

    fileprivate func handUpAnimation() {
        handTopConstraint.constant = -130.0
        
        UIView.animate(withDuration: 1.5, delay: 0.0, options: [.curveLinear], animations: {
            self.view.layoutIfNeeded()
        }, completion: { finished in
            self.handRemoveAnimation()
        })
    }

    fileprivate func handRemoveAnimation() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveLinear], animations: {
            self.handImageView.transform = CGAffineTransform(scaleX: self.scale * 1.1, y: self.scale * 1.1)
        }, completion: { finished in
            self.handTopConstraint.constant = 0
            self.handTrailingConstraint.constant = 600
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveLinear], animations: {
                self.view.layoutIfNeeded()
            }, completion: { finished in
                self.initHandAnimation()
            })
        })
    }
}

extension ViewController : PLInterface {
    func onInitialisation(response: InitialisationResponse) {
        print("UIViewController onInitialisation response: \(response.description())")
                
        //        let dpi: CGFloat = 326.0
        //        let dpr: CGFloat = 2.0
        //        let defaultDpi: CGFloat = 326.0
        scale = 1.0 // (dpi / dpr) / (defaultDpi / 2.0)
        
        initHandAnimation()
        handOnPlaceAnimation()
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true, block: { timer in
            self.handOnPlaceAnimation()
        })
    }
    
    func onInteraction(response: InteractionResponse) {
        print("UIViewController onInteraction response: \(response.description())")
    }
    
    func onProgress(response: ProgressResponse) {
        print("UIViewController onProgress response: \(response.description())")
    }
    
    func onDetectionSuccess(response: DecoderSuccessResponse) {
        print("UIViewController onDetectionSuccess response: \(response.description())")
        
        successSound?.play()
        
        let alert = UIAlertController(title: "Result", message: response.description(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func onDetectionError(response: DecoderErrorResponse) {
        print("UIViewController onDetectionError response: \(response.description())")
    }
    
    func onUsability(response: UsabilityResponse) {
        print("UIViewController onUsability response: \(response.description())")
    }
    
    func onConnectivity(response: ConnectivityResponse) {
        print("UIViewController onConnectivity response: \(response.description())")
    }
    
    func onScript(response: ScriptResponse) {
        print("UIViewController onScript response: \(response.description())")
    }
}

