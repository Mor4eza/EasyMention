# EasyMention
[![CI Status](https://img.shields.io/travis/Mor4eza/EasyMention.svg?style=flat)](https://travis-ci.org/Mor4eza/EasyMention)
[![Version](https://img.shields.io/cocoapods/v/EasyMention.svg?style=flat)](https://cocoapods.org/pods/EasyMention)
[![License](https://img.shields.io/cocoapods/l/EasyMention.svg?style=flat)](https://cocoapods.org/pods/EasyMention)
[![Platform](https://img.shields.io/cocoapods/p/EasyMention.svg?style=flat)](https://cocoapods.org/pods/EasyMention)


A Swift Library that made easy to implement mentions in a TextView

Preview:

![alt text](https://raw.githubusercontent.com/Mor4eza/EasyMention/master/preview.gif)



## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
- Swift => 5
- iOS => 10

## Installation
**Cocoapods**

EasyMention is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'EasyMention'
```
**Manual**

simply copy classes folder to your project directory

# How to Use
- add a textView and change it super class to **EasyMention**

```swift
    @IBOutlet weak var mentionsTextView: EasyMention!
```
- implement mentions delegate in your class

```swift
  extension ViewController: EasyMentionDelegate {...
```

- set mentionDelegate to self

```swift
        mentionsTextView.mentionDelegate = self
```

- set mentions to your textView with:

```swift
     self.mentionsTextView.setMentions(mentions: mentionItems)
```

**async mention load from api**

```swift
  func startMentioning(in textView: EasyMention, mentionQuery: String) {...
```
will called when user wants to start mentioning,
you can sipmly call your api here and add resut to EasyMention mention items


**See Eaxmple Project for more info**



# Made with Love in 🇮🇷
Morteza Gharedaghi: Morteza.ghrdi@gmail.com

Feel Free to create issue or open a pull request ☺️


# Used in
send your application name to me,if you used this library 

- Wink App

## License

EasyMention is available under the MIT license. See the LICENSE file for more info.
