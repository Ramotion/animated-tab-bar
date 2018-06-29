[![header](./header.png)](https://ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=animated-tab-bar-logo)
<img src="https://github.com/Ramotion/animated-tab-bar/blob/master/Screenshots/animatedTabBar.gif" width="600" height="450" />
<br><br/>

# Animated-tab-bar
[![CocoaPods](https://img.shields.io/cocoapods/p/RAMAnimatedTabBarController.svg)](http://cocoapods.org/pods/RAMAnimatedTabBarController)
[![CocoaPods](https://img.shields.io/cocoapods/v/RAMAnimatedTabBarController.svg)](http://cocoapods.org/pods/RAMAnimatedTabBarController)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Ramotion/animated-tab-bar)
[![Swift 4.0](https://img.shields.io/badge/Swift-4.0-green.svg?style=flat)](https://developer.apple.com/swift/)
[![Twitter](https://img.shields.io/badge/Twitter-@Ramotion-blue.svg?style=flat)](http://twitter.com/Ramotion)
[![Travis](https://img.shields.io/travis/Ramotion/animated-tab-bar.svg)](https://travis-ci.org/Ramotion/animated-tab-bar)
[![Donate](https://img.shields.io/badge/Donate-PayPal-blue.svg)](https://paypal.me/Ramotion)

## About
This project is maintained by Ramotion, Inc.<br>
We specialize in the designing and coding of custom UI for Mobile Apps and Websites.<br>

**Looking for developers for your project?**<br>
This project is maintained by Ramotion, Inc. We specialize in the designing and coding of custom UI for Mobile Apps and Websites.

<a href="mailto:alex.a@ramotion.com?subject=Project%20inquiry%20from%20Github">
<img src="https://github.com/ramotion/gliding-collection/raw/master/contact_our_team@2x.png" width="187" height="34"></a>
<br>


The [iPhone mockup](https://store.ramotion.com/product/iphone-x-clay-mockups?utm_source=gthb&utm_medium=special&utm_campaign=animated-tab-bar) available [here](https://store.ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=animated-tab-bar).

## Try this UI control in action

<a href="https://itunes.apple.com/app/apple-store/id1182360240?pt=550053&ct=gthb-animated-tab-bar&mt=8" > <img src="https://github.com/Ramotion/navigation-stack/raw/master/Download_on_the_App_Store_Badge_US-UK_135x40.png" width="170" height="58"></a>

Screencast from our Demo

![Animation](https://raw.githubusercontent.com/Ramotion/animated-tab-bar/master/Screenshots/RAMAnimatedTabBarDemo.gif)

## Requirements

- iOS 9.0+
- xCode 9

## Installation

Just add the RAMAnimatedTabBarController folder to your project.

or use [CocoaPods](https://cocoapods.org) with Podfile:
``` ruby
pod 'RAMAnimatedTabBarController'
```

or [Carthage](https://github.com/Carthage/Carthage) users can simply add to their `Cartfile`:
```
github "Ramotion/animated-tab-bar"

```


## Usage

1. Create a new UITabBarController in your storyboard or nib.

2. Set the class of the UITabBarController to RAMAnimatedTabBarController in your Storyboard or nib.

3. For each UITabBarItem, set the class to RAMAnimatedTabBarItem.

4. Add a custom image icon for each RAMAnimatedTabBarItem

5. Add animation for each RAMAnimatedTabBarItem :
   * drag and drop an NSObject item into your ViewController
   * set its class to ANIMATION_CLASS (where ANIMATION_CLASS is the class name of the animation you want to use)
   * connect the outlet animation in RAMAnimatedTabBarItem to your ANIMATION_CLASS
   [Demonstration video for step 5](http://vimeo.com/112390386)


## Included Animations

* RAMBounceAnimation
* RAMLeftRotationAnimation
* RAMRightRotationAnimation
* RAMFlipLeftTransitionItemAnimations
* RAMFlipRightTransitionItemAnimations
* RAMFlipTopTransitionItemAnimations
* RAMFlipBottomTransitionItemAnimations
* RAMFrameItemAnimation
* RAMFumeAnimation

## Creating Custom Animations
1. Create a new class which inherits from RAMItemAnimation:

  ``` swift
     class NewAnimation : RAMItemAnimation
  ```
2. Implement the methods in RAMItemAnimationProtocol:


  ``` swift
    // method call when Tab Bar Item is selected
    override func playAnimation(icon: UIImageView, textLabel: UILabel) {
      // add animation
    }
  ```  
  ``` swift
    // method call when Tab Bar Item is deselected
    override func deselectAnimation(icon: UIImageView, textLabel: UILabel, defaultTextColor: UIColor, defaultIconColor: UIColor) {
      // add animation
    }
  ```    
  ``` swift
    // method call when TabBarController did load
    override func selectedState(icon: UIImageView, textLabel: UILabel) {
      // set selected state  
    }
  ```

3. Example:

``` swift
import RAMAnimatedTabBarController

class RAMBounceAnimation : RAMItemAnimation {

    override func playAnimation(_ icon: UIImageView, textLabel: UILabel) {
        playBounceAnimation(icon)
        textLabel.textColor = textSelectedColor
    }

    override func deselectAnimation(_ icon: UIImageView, textLabel: UILabel, defaultTextColor: UIColor, defaultIconColor: UIColor) {
        textLabel.textColor = defaultTextColor
    }

    override func selectedState(_ icon: UIImageView, textLabel: UILabel) {
        textLabel.textColor = textSelectedColor
    }

    func playBounceAnimation(_ icon : UIImageView) {

        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(duration)
        bounceAnimation.calculationMode = kCAAnimationCubic

        icon.layer.add(bounceAnimation, forKey: "bounceAnimation")
    }
}
```

<br>This library is a part of a <a href="https://github.com/Ramotion/swift-ui-animation-components-and-libraries"><b>selection of our best UI open-source projects.</b></a></br>

# Get the Showroom App for iOS to give it a try
Try this UI library in our iOS app. Contact us if you interested in hiring the team.

<a href="https://itunes.apple.com/app/apple-store/id1182360240?pt=550053&ct=animated-tab-bar&mt=8" >
<img src="https://github.com/ramotion/gliding-collection/raw/master/app_store@2x.png" width="117" height="34"></a>
<a href="mailto:alex.a@ramotion.com?subject=Project%20inquiry%20from%20Github">
<img src="https://github.com/ramotion/gliding-collection/raw/master/contact_our_team@2x.png" width="187" height="34"></a>
<br>
<br>



Follow us for the latest updates<br>
<a href="https://goo.gl/rPFpid" >
<img src="https://i.imgur.com/ziSqeSo.png/" width="156" height="28"></a>
