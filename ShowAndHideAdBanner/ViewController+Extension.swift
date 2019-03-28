//
//  ViewController+Extension.swift
//  ShowAndHideAdBanner

//  @brief  Extension class to determine interact connectivity and load, show AdMob banner accordingly.
//
//  Created by Sönke Gissel on 3/28/19.
//  Copyright © 2019 Sönke Gissel. All rights reserved.
//

import Foundation
import Reachability
import GoogleMobileAds

extension ViewController: GADBannerViewDelegate {
    
    /*! @brief Gets called when connectivity changes.
     An observer is created in ViewController.viewWillAppear.
     @see viewWillAppear in Viewcontroller.
     @remark Knows three states for WiFi, Cell an no connection. */
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("abc123: Reachable via WiFi")
            setupBanner()
        case .cellular:
            print("abc123: Reachable via Cellular")
            setupBanner()
        case .none:
            print("abc123: Network not reachable")
            removeBannerViewFromViewIfExistant(bannerView)
        }
    }
    
    /*! @brief Setup the Banner.
     @description Sets required attributes as in the quick-start from Google AdMob.
     Uses inbuilt solution to autoLoad banner instead of calling loadRequest. Found it most simple.
     See that the adSize is filled dyamically according to the devices orientation.
     This way every device type and size will get SmartBanners for current orientation.
     @see https://developers.google.com/admob/ios/banner#configure_properties
     @remark New solution for orientation. Auto load instead of loadRequest */
    func setupBanner() {
        // In this case, we instantiate the banner with desired ad size.
        bannerView.adSize = adSizeForOrientation()
        #if DEBUG
        bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
        #else
        bannerView.adUnitID = "YOUR PROD AD UNIT"
        #endif
        // isAutoloadEnabled is poorly documented IMHO.
        // Found this: The autoloadEnabled will automatically call the loadRequest on Banners.
        // https://groups.google.com/forum/#!topic/google-admob-ads-sdk/lp1L1nZZUUA
        bannerView.isAutoloadEnabled = true
        bannerView.rootViewController = self
        bannerView.delegate = self
    }
    
    /*! @brief Returns current device orientation.  */
    func adSizeForOrientation() -> GADAdSize {
        if UIDevice.current.orientation.isLandscape {
            return kGADAdSizeSmartBannerLandscape
        } else {
            return kGADAdSizeSmartBannerPortrait
        }
    }
    
    /*! @brief Adds a banner to the view hierarchy once an ad is received.
     @see https://developers.google.com/admob/ios/banner#use_cases */
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("abc123: adViewDidReceiveAd")
        addBannerViewToView(bannerView)
    }
    
    /*! @brief Remove the banner from view on error. */
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("abc123: didFailToReceiveAdWithError: \(error.localizedDescription)")
        removeBannerViewFromViewIfExistant(bannerView)
    }
    
    /*! @see https://developers.google.com/admob/ios/banner#programmatically */
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bannerView)
        //view.bringSubviewToFront(bannerView)
        positionBannerViewFullWidthAtBottomOfSafeAreaOrLayoutMargins(bannerView)
    }
    
    /*! @brief Remove an existing banner from the view hierarchy.
     @description If there is a banner existing, it will be remove from the view.
     The check is needed or a crash will happen if the app is started with no connection.
     See reachabilityChanged() for case .none.
     Sets the bottom constraint for the image view to active again to anchor to
     safe area / layout margins bottom again. */
    func removeBannerViewFromViewIfExistant(_ bannerView: GADBannerView) {
        if self.view.subviews.contains(bannerView) {
            bannerView.removeFromSuperview()
        }
        imageViewBottomConstraint.isActive = true
    }
    
    /*! @brief Positions the banner to bottom of the screen.
     @description Don't know why in the quick-start Google is setting constraints so complicated.
     correctLayoutGuide will give me either layoutMarginsGuide for < iOS 11 or safeAreaLayoutGuide.
     This function will then use the guide and anchor the banner to the bottom of the guide.
     The topAnchor of the banner needs to be set to the bottom of the imageView (in this case).
     @remark See the imageViewBottomConstraint referenced with an outlet getting inactive. */
    func positionBannerViewFullWidthAtBottomOfSafeAreaOrLayoutMargins(_ bannerView: UIView) {
        
        imageViewBottomConstraint.isActive = false
        
        let guide = correctLayoutGuide
        NSLayoutConstraint.activate([
            guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
            guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
            guide.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor),
            bannerView.topAnchor.constraint(equalTo: imageView.bottomAnchor)
            ])
    }
    /*! @brief Returns the views guide.
     @return The views guide depending on iOS version. */
    var correctLayoutGuide: UILayoutGuide {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaLayoutGuide
        } else {
            return self.view.layoutMarginsGuide
        }
    }
}
