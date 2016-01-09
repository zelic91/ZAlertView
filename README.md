# ZAlertView

[![Version](https://img.shields.io/cocoapods/v/ZAlertView.svg?style=flat)](http://cocoapods.org/pods/ZAlertView)
[![License](https://img.shields.io/cocoapods/l/ZAlertView.svg?style=flat)](http://cocoapods.org/pods/ZAlertView)
[![Platform](https://img.shields.io/cocoapods/p/ZAlertView.svg?style=flat)](http://cocoapods.org/pods/ZAlertView)

![alt text](https://raw.githubusercontent.com/zelic91/ZAlertView/master/Screenshots/ZA_01.png "")
![alt text](https://raw.githubusercontent.com/zelic91/ZAlertView/master/Screenshots/ZA_02.png "")
![alt text](https://raw.githubusercontent.com/zelic91/ZAlertView/master/Screenshots/ZA_03.png "")
![alt text](https://raw.githubusercontent.com/zelic91/ZAlertView/master/Screenshots/ZA_04.png "")

## Introduction

ZAlertView is a highly customizable dialog (exaggerated, right?) view which can be used as a substitution for UIAlertView. It's written in Swift. This is the gift I give to myself on my 26th birthday.

## Usage

There are 4 types of dialog that ZAlertView currently supports: Alert, Yes-No, Input and Multiple choice:

```swift
  public enum AlertType: Int {
    case Alert
    case Confirmation
    case MultipleChoice
  }
```

To create and show a dialog, first of all, import the module at the beginning of the file:

```swift
  import ZAlertView
```

Then show the dialog as below:

```swift
  let dialog = ZAlertView()
  dialog.show()
```

There are more convenient constructors for you to use:

```swift
  ZAlertView(title: "Title", message: "Message", alertType: AlertType.Alert)

  ZAlertView(title: "Title", message: "Message", closeButtonText: "Close this popup", closeButtonHandler: nil)

  ZAlertView(title: "Title", message: "Message", okButtonText: "Sure, I do", cancelButtonText: "No way")

  ZAlertView(title: "Title", message: "Message", isOkButtonLeft: false, okButtonText: "Cool, do it", cancelButtonText: "Stop it", okButtonHandler: nil, cancelButtonHandler: nil)
```

And button handler (TouchHandler) is just a lambda:

```swift
  (ZAlertView) -> ()
```

There are plenty of attributes that you can use to make your own style for the whole app:

```swift
  public static var padding: CGFloat
  public static var innerPadding: CGFloat
  public static var cornerRadius: CGFloat
  public static var buttonHeight: CGFloat
  public static var buttonSectionExtraGap: CGFloat
  public static var textFieldHeight: CGFloat
  public static var backgroundAlpha: CGFloat
  public static var blurredBackground: Bool
  public static var showAnimation: ShowAnimation
  public static var hideAnimation: HideAnimation

  // Font
  public static var alertTitleFont: UIFont?
  public static var messageFont: UIFont?
  public static var buttonFont: UIFont?

  // Color
  public static var positiveColor: UIColor?
  public static var negativeColor: UIColor?
  public static var neutralColor: UIColor?
  public static var titleColor: UIColor?
  public static var messageColor: UIColor?
  public static var cancelTextColor: UIColor?
  public static var normalTextColor: UIColor?
```

There are also some basic animations:

```swift
  public enum ShowAnimation: Int {
    case FadeIn
    case FlyLeft
    case FlyTop
    case FlyRight
    case FlyBottom
  }

  public enum HideAnimation: Int {
    case FadeOut
    case FlyLeft
    case FlyTop
    case FlyRight
    case FlyBottom
  }
```

For a specific dialog, there are customizable properties as below:

```swift
  public var alertType: AlertType
  public var alertTitle: String?
  public var message: String?
  public var okTitle: String?
  public var cancelTitle: String?
  public var closeTitle: String?
  public var isOkButtonLeft: Bool
  public var allowTouchOutsideToDismiss: Bool
  public var width: CGFloat = ZAlertView.AlertWidth
  public var height: CGFloat = ZAlertView.AlertHeight

  // Master views
  public var backgroundView: UIView!
  public var alertView: UIView!
```

## Installation

ZAlertView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ZAlertView"
```

## Author

Thuong Nguyen, thuongnh.uit@gmail.com

## License

ZAlertView is available under the MIT license. See the LICENSE file for more info.
