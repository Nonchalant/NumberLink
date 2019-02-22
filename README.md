# NumberLink

[![Build Status](https://travis-ci.com/Nonchalant/NumberLink.svg?branch=master)](https://travis-ci.com/Nonchalant/NumberLink)
[![Language](https://img.shields.io/badge/language-Swift%204.2-orange.svg)](https://swift.org)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform iOS|macOS](https://img.shields.io/badge/platform-iOS|macOS-lightgray.svg)](https://github.com/Nonchalant/NumberLink)
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/Nonchalant/NumberLink/master/LICENSE)


## Usage

```swift
import NumberLink

var options = NumberLinkGenerator.Options.default
options.limit = 100 // Attempts limit
options.isVerbose = true

let board = try? NumberLinkGenerator(options: options).generate(width: 7, height: 7, amountOfPins: 5)
```

![Playground](Documentation/playground.png)


## Required

- Swift 4.2
- Xcode 10.1


## Playground

You can try NumberLink on Xcode Playground.

1. Clone this
2. Open `NumberLink.xcworkspace`
3. Open `NumberLink.xcplayground`


## Installation

```
github "Nonchalant/NumberLink"
```


## Acknowledgement

**NumberLink** is a registered trademark of Nikoli Inc.
