[![header](https://raw.githubusercontent.com/Ramotion/animated-tab-bar/master/header.png)](https://business.ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=animated-tab-bar-logo)
# RAMAnimatedTabBarController
[![CocoaPods](https://img.shields.io/cocoapods/p/RAMAnimatedTabBarController.svg)](http://cocoapods.org/pods/RAMAnimatedTabBarController)
[![CocoaPods](https://img.shields.io/cocoapods/v/RAMAnimatedTabBarController.svg)](http://cocoapods.org/pods/RAMAnimatedTabBarController)
[![CocoaPods](https://img.shields.io/cocoapods/metrics/doc-percent/RAMAnimatedTabBarController.svg)](https://cdn.rawgit.com/Ramotion/animated-tab-bar/master/docs/index.html)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Ramotion/animated-tab-bar)
[![Twitter](https://img.shields.io/badge/Twitter-@Ramotion-blue.svg?style=flat)](http://twitter.com/Ramotion)
[![Travis](https://img.shields.io/travis/Ramotion/animated-tab-bar.svg)](https://travis-ci.org/Ramotion/animated-tab-bar)
[![Analytics](https://ga-beacon.appspot.com/UA-84973210-1/ramotion/animated-tab-bar)](https://github.com/igrigorik/ga-beacon)

## About
This project is maintained by Ramotion, Inc.<br>
We specialize in the designing and coding of custom UI for Mobile Apps and Websites.<br><br>**Looking for developers for your project?** [[▶︎CONTACT OUR TEAM◀︎](http://business.ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=animated-tab-bar-contact-us/#Get_in_Touch)]



[![Animation](https://raw.githubusercontent.com/Ramotion/animated-tab-bar/master/Screenshots/tab-bar-icons-iphone-ramotion-animation-interface-design.gif)](https://dribbble.com/shots/1766396-Animated-Tab-Bar-Icons)

The [iPhone mockup](https://store.ramotion.com/product/iphone-6-mockups?utm_source=gthb&utm_medium=special&utm_campaign=animated-tab-bar) available [here](https://store.ramotion.com/product/iphone-6-mockups?utm_source=gthb&utm_medium=special&utm_campaign=animated-tab-bar).


Screencast from our Demo

![Animation](https://raw.githubusercontent.com/Ramotion/animated-tab-bar/master/Screenshots/RAMAnimatedTabBarDemo.gif)

## Requirements

- iOS 9.0+
- xCode 8

## Installation

Just add the RAMAnimatedTabBarController folder to your project.

or use [CocoaPods](https://cocoapods.org) with Podfile:
``` ruby
pod 'RAMAnimatedTabBarController', "~> 1.5.3"  swift 2.2
pod 'RAMAnimatedTabBarController', "~> 2.0.2"  swift 3
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
class RAMBounceAnimation : RAMItemAnimation {

    override func playAnimation(icon: UIImageView, textLabel: UILabel) {
        playBounceAnimation(icon)
        textLabel.textColor = textSelectedColor
    }

    override func deselectAnimation(icon: UIImageView, textLabel: UILabel, defaultTextColor: UIColor, defaultIconColor: UIColor) {
        textLabel.textColor = defaultTextColor
    }

    override func selectedState(icon: UIImageView, textLabel: UILabel) {
        textLabel.textColor = textSelectedColor
    }

    func playBounceAnimation(icon : UIImageView) {

        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = NSTimeInterval(duration)
        bounceAnimation.calculationMode = kCAAnimationCubic

        icon.layer.addAnimation(bounceAnimation, forKey: "bounceAnimation")
    }
}
```

## Follow us

[![Twitter URL](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=https://github.com/ramotion/animated-tab-bar)
[![Twitter Follow](https://img.shields.io/twitter/follow/ramotion.svg?style=social)](https://twitter.com/ramotion)
