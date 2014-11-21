# RAMAnimatedTabBarController

UITabBarController with animated items.

![Animation](Screenshots/RAMAnimatedTabBarDemo.gif)

## Requirements

- iOS 7.0+
- Xcode 6.1

## Installation

Just add RAMAnimatedTabBarController folder to your project.

## Usage

1. Set the class of the UITabBarController to RAMAnimatedTabBarController in your Storyboard or nib.

2. For each UITabBarItems set the class  RAMAnimatedTabBarItem in your Storyboard or nib.

3. Add custom image icon for each TabBarItems

4. Add animation for each TabBarItems : 
   * drag and drop NSObject to item UIViewController 
   * set the class of the NSObject to ANIMATION_CLASS
   * connect outlet animation in RAMAnimatedTabBarItem with ANIMATION_CLASS
   [video for step 4](http://vimeo.com/112390386)
   			
   			
## Animation Classes

* RAMBounceAnimation
* RAMLeftRotationAnimation
* RAMRightRotationAnimation
* RAMFlipLeftTransitionItemAniamtions
* RAMFlipRightTransitionItemAniamtions
* RAMFlipTopTransitionItemAniamtions
* RAMFlipBottomTransitionItemAniamtions
* RAMFrameItemAnimation


##About us

[Ramotion](http://Ramotion.com) is an iPhone app design and development company. We are ready for new interesting iOS App Development projects.

Follow us on [twitter](http://twitter.com/ramotion).
