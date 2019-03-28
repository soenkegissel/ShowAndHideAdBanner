# Show and hide AdMob Banner
This is an example of how to dyamically load and place an Google AdMob banner to the bottom of the screen.
* Programmatic implementation.
* No overlay of the view on top of bannerView.
* Detects the connection status and shows and hides the banner accordingly. 
* Uses AdMob SmartBanners. Loads SmartBanners for landscape and portrait depending on the current orientation.

**How to get started?**
* Get a copy of this repo.
* Run `pod install` to get the deps.
  * Dependencies: `Firebase/Core, Firebase/AdMob, ReachabilitySwift`
* Open the ShowAndHideAdBanner.**xcworkspace**

**Things to note**
* Deployment target is iOS 9.3

**Demo**
* Hides the banner dynamically on rotaton, loads a new banner for the current orientation.
![Device rotation](/images/2019-03-28-ShowHideBanner.gif)

* If the connection (WiFi and cell) gets lost, the banner will hide. After connect will load a new banner.
![Device rotation](/images/2019-03-28-ShowHideBanner-connectivity.gif)


---
https://rucksack.dev - Rucksack App Development
