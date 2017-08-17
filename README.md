# EzPhotoBrowser

![image](https://github.com/570262616/EzPhotoBrowser/blob/master/Untitled.gif)

## Features
* Lightweight image browser

## Communication
* If you **found a bug**, open an issue, typically with related pattern.
* If you **have a feature request**, open an issue.

## Requirements

- iOS 8.0+
- Xcode 8.3.2+
- Swift 3.0+

## Installation
### CocoaPods
```ruby
pod 'EzPhotoBrowser'
```

## Usage

```swift
lazy var photoBrowserAnimator = PhotoBrowserAnimator()
```

```swift
let vc = PhotoBrowserViewController(urls: urls, index: index)
vc.delegate = self

vc.modalPresentationStyle = .custom
vc.transitioningDelegate = self.photoBrowserAnimator

self.present(vc, animated: true, completion: nil)
```

##### Implement proxy method: `PhotoBrowserViewControllerDelegate`

```swift
func photoBrowserSourceRect(index: Int) -> CGRect {
        
	let indexPath = IndexPath(row: index, section: 0)
        
	let cell = collectionView?.cellForItem(at: indexPath)
        
	return self.collectionView!.convert(cell!.frame, to: UIApplication.shared.keyWindow!)
}
```

