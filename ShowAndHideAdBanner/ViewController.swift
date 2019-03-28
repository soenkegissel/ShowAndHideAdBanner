//
//  ViewController.swift
//  ShowAndHideAdBanner
//
//  Created by Sönke Gissel on 3/27/19.
//  Copyright © 2019 Sönke Gissel. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Reachability

class ViewController: UIViewController {

    
    /*! @brief Reference to the bottomConstraint of the image view here.
     @remark Set the constraints priority to 750 in storyboard. */
    @IBOutlet var imageViewBottomConstraint: NSLayoutConstraint!
    
    /*! @brief Reference to the image view. */
    @IBOutlet weak var imageView: UIImageView!
    
    /*! @brief Initialize the BannerView */
    var bannerView: GADBannerView = GADBannerView()
    
    //declare this property where it won't go out of scope relative to your listener
    let reachability = Reachability()!
    
    override func viewWillAppear(_ animated: Bool) {
        // Register the observer to get notified if the connection changes.
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // For the duration of transition the banner will removed. As the orientation changes the adSize will be set
        // to the new orientation. AutoLoad will load a new banner automatically, no need for loadRequest.
        removeBannerViewFromViewIfExistant(bannerView)
        bannerView.adSize = adSizeForOrientation()
    }
}

