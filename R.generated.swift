//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.color` struct is generated, and contains static references to 0 colors.
  struct color {
    fileprivate init() {}
  }
  
  /// This `R.file` struct is generated, and contains static references to 1 files.
  struct file {
    /// Resource file `ImageSearchExampleResponse.json`.
    static let imageSearchExampleResponseJson = Rswift.FileResource(bundle: R.hostingBundle, name: "ImageSearchExampleResponse", pathExtension: "json")
    
    /// `bundle.url(forResource: "ImageSearchExampleResponse", withExtension: "json")`
    static func imageSearchExampleResponseJson(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.imageSearchExampleResponseJson
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.font` struct is generated, and contains static references to 0 fonts.
  struct font {
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 10 images.
  struct image {
    /// Image `check`.
    static let check = Rswift.ImageResource(bundle: R.hostingBundle, name: "check")
    /// Image `closeButton`.
    static let closeButton = Rswift.ImageResource(bundle: R.hostingBundle, name: "closeButton")
    /// Image `consumeSmall`.
    static let consumeSmall = Rswift.ImageResource(bundle: R.hostingBundle, name: "consumeSmall")
    /// Image `consume`.
    static let consume = Rswift.ImageResource(bundle: R.hostingBundle, name: "consume")
    /// Image `flashButton`.
    static let flashButton = Rswift.ImageResource(bundle: R.hostingBundle, name: "flashButton")
    /// Image `listButton`.
    static let listButton = Rswift.ImageResource(bundle: R.hostingBundle, name: "listButton")
    /// Image `placeholer`.
    static let placeholer = Rswift.ImageResource(bundle: R.hostingBundle, name: "placeholer")
    /// Image `plus`.
    static let plus = Rswift.ImageResource(bundle: R.hostingBundle, name: "plus")
    /// Image `trashSmall`.
    static let trashSmall = Rswift.ImageResource(bundle: R.hostingBundle, name: "trashSmall")
    /// Image `trash`.
    static let trash = Rswift.ImageResource(bundle: R.hostingBundle, name: "trash")
    
    /// `UIImage(named: "check", bundle: ..., traitCollection: ...)`
    static func check(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.check, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "closeButton", bundle: ..., traitCollection: ...)`
    static func closeButton(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.closeButton, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "consume", bundle: ..., traitCollection: ...)`
    static func consume(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.consume, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "consumeSmall", bundle: ..., traitCollection: ...)`
    static func consumeSmall(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.consumeSmall, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "flashButton", bundle: ..., traitCollection: ...)`
    static func flashButton(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.flashButton, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "listButton", bundle: ..., traitCollection: ...)`
    static func listButton(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.listButton, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "placeholer", bundle: ..., traitCollection: ...)`
    static func placeholer(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.placeholer, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "plus", bundle: ..., traitCollection: ...)`
    static func plus(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.plus, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "trash", bundle: ..., traitCollection: ...)`
    static func trash(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.trash, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "trashSmall", bundle: ..., traitCollection: ...)`
    static func trashSmall(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.trashSmall, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 1 nibs.
  struct nib {
    /// Nib `FoodItem_CollCell`.
    static let foodItem_CollCell = _R.nib._FoodItem_CollCell()
    
    /// `UINib(name: "FoodItem_CollCell", in: bundle)`
    static func foodItem_CollCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.foodItem_CollCell)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 3 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `FoodItemCell`.
    static let foodItemCell: Rswift.ReuseIdentifier<FoodItemCell> = Rswift.ReuseIdentifier(identifier: "FoodItemCell")
    /// Reuse identifier `FoodItemCollectionCell`.
    static let foodItemCollectionCell: Rswift.ReuseIdentifier<FoodItemCollectionCell> = Rswift.ReuseIdentifier(identifier: "FoodItemCollectionCell")
    /// Reuse identifier `FoodListHeader`.
    static let foodListHeader: Rswift.ReuseIdentifier<CollectionHeader> = Rswift.ReuseIdentifier(identifier: "FoodListHeader")
    
    fileprivate init() {}
  }
  
  /// This `R.segue` struct is generated, and contains static references to 4 view controllers.
  struct segue {
    /// This struct is generated for `ItemDetail_Controller`, and contains static references to 1 segues.
    struct itemDetail_Controller {
      /// Segue identifier `showTableView`.
      static let showTableView: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, ItemDetail_Controller, ItemDetail_TableController> = Rswift.StoryboardSegueIdentifier(identifier: "showTableView")
      
      /// Optionally returns a typed version of segue `showTableView`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func showTableView(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, ItemDetail_Controller, ItemDetail_TableController>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.itemDetail_Controller.showTableView, segue: segue)
      }
      
      fileprivate init() {}
    }
    
    /// This struct is generated for `ScanResults_Controller`, and contains static references to 1 segues.
    struct scanResults_Controller {
      /// Segue identifier `showTableView`.
      static let showTableView: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, ScanResults_Controller, ScanResults_TableController> = Rswift.StoryboardSegueIdentifier(identifier: "showTableView")
      
      /// Optionally returns a typed version of segue `showTableView`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func showTableView(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, ScanResults_Controller, ScanResults_TableController>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.scanResults_Controller.showTableView, segue: segue)
      }
      
      fileprivate init() {}
    }
    
    /// This struct is generated for `Scan_Controller`, and contains static references to 1 segues.
    struct scan_Controller {
      /// Segue identifier `showCameraView`.
      static let showCameraView: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, Scan_Controller, Scan_CameraController> = Rswift.StoryboardSegueIdentifier(identifier: "showCameraView")
      
      /// Optionally returns a typed version of segue `showCameraView`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func showCameraView(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, Scan_Controller, Scan_CameraController>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.scan_Controller.showCameraView, segue: segue)
      }
      
      fileprivate init() {}
    }
    
    /// This struct is generated for `StorageContent_Controller`, and contains static references to 1 segues.
    struct storageContent_Controller {
      /// Segue identifier `showCollectionView`.
      static let showCollectionView: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, StorageContent_Controller, StorageContent_CollectionController> = Rswift.StoryboardSegueIdentifier(identifier: "showCollectionView")
      
      /// Optionally returns a typed version of segue `showCollectionView`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func showCollectionView(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, StorageContent_Controller, StorageContent_CollectionController>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.storageContent_Controller.showCollectionView, segue: segue)
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 5 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    /// Storyboard `Scan`.
    static let scan = _R.storyboard.scan()
    /// Storyboard `Shared`.
    static let shared = _R.storyboard.shared()
    /// Storyboard `Storage`.
    static let storage = _R.storyboard.storage()
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    
    /// `UIStoryboard(name: "Scan", bundle: ...)`
    static func scan(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.scan)
    }
    
    /// `UIStoryboard(name: "Shared", bundle: ...)`
    static func shared(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.shared)
    }
    
    /// `UIStoryboard(name: "Storage", bundle: ...)`
    static func storage(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.storage)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 0 localization tables.
  struct string {
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
    try nib.validate()
  }
  
  struct nib: Rswift.Validatable {
    static func validate() throws {
      try _FoodItem_CollCell.validate()
    }
    
    struct _FoodItem_CollCell: Rswift.NibResourceType, Rswift.ReuseIdentifierType, Rswift.Validatable {
      typealias ReusableType = FoodItemCollectionCell
      
      let bundle = R.hostingBundle
      let identifier = "FoodItemCollectionCell"
      let name = "FoodItem_CollCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> FoodItemCollectionCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? FoodItemCollectionCell
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "placeholer", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'placeholer' is used in nib 'FoodItem_CollCell', but couldn't be loaded.") }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try storage.validate()
      try scan.validate()
      try shared.validate()
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      fileprivate init() {}
    }
    
    struct main: Rswift.StoryboardResourceWithInitialControllerType {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "Main"
      
      fileprivate init() {}
    }
    
    struct scan: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let cameraView = StoryboardViewControllerResource<Scan_CameraController>(identifier: "CameraView")
      let name = "Scan"
      let scanNavigation = StoryboardViewControllerResource<UIKit.UINavigationController>(identifier: "ScanNavigation")
      let scanResultsTableView = StoryboardViewControllerResource<ScanResults_TableController>(identifier: "ScanResultsTableView")
      let scanResultsView = StoryboardViewControllerResource<ScanResults_Controller>(identifier: "ScanResultsView")
      let scanView = StoryboardViewControllerResource<Scan_Controller>(identifier: "ScanView")
      
      func cameraView(_: Void = ()) -> Scan_CameraController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: cameraView)
      }
      
      func scanNavigation(_: Void = ()) -> UIKit.UINavigationController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: scanNavigation)
      }
      
      func scanResultsTableView(_: Void = ()) -> ScanResults_TableController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: scanResultsTableView)
      }
      
      func scanResultsView(_: Void = ()) -> ScanResults_Controller? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: scanResultsView)
      }
      
      func scanView(_: Void = ()) -> Scan_Controller? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: scanView)
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "check") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'check' is used in storyboard 'Scan', but couldn't be loaded.") }
        if UIKit.UIImage(named: "flashButton") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'flashButton' is used in storyboard 'Scan', but couldn't be loaded.") }
        if UIKit.UIImage(named: "closeButton") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'closeButton' is used in storyboard 'Scan', but couldn't be loaded.") }
        if UIKit.UIImage(named: "listButton") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'listButton' is used in storyboard 'Scan', but couldn't be loaded.") }
        if _R.storyboard.scan().scanNavigation() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'scanNavigation' could not be loaded from storyboard 'Scan' as 'UIKit.UINavigationController'.") }
        if _R.storyboard.scan().scanResultsView() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'scanResultsView' could not be loaded from storyboard 'Scan' as 'ScanResults_Controller'.") }
        if _R.storyboard.scan().scanView() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'scanView' could not be loaded from storyboard 'Scan' as 'Scan_Controller'.") }
        if _R.storyboard.scan().cameraView() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'cameraView' could not be loaded from storyboard 'Scan' as 'Scan_CameraController'.") }
        if _R.storyboard.scan().scanResultsTableView() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'scanResultsTableView' could not be loaded from storyboard 'Scan' as 'ScanResults_TableController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct shared: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let itemDetailTableView = StoryboardViewControllerResource<ItemDetail_TableController>(identifier: "ItemDetailTableView")
      let itemDetailView = StoryboardViewControllerResource<ItemDetail_Controller>(identifier: "ItemDetailView")
      let name = "Shared"
      
      func itemDetailTableView(_: Void = ()) -> ItemDetail_TableController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: itemDetailTableView)
      }
      
      func itemDetailView(_: Void = ()) -> ItemDetail_Controller? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: itemDetailView)
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "placeholer") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'placeholer' is used in storyboard 'Shared', but couldn't be loaded.") }
        if _R.storyboard.shared().itemDetailView() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'itemDetailView' could not be loaded from storyboard 'Shared' as 'ItemDetail_Controller'.") }
        if _R.storyboard.shared().itemDetailTableView() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'itemDetailTableView' could not be loaded from storyboard 'Shared' as 'ItemDetail_TableController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct storage: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "Storage"
      let storageContentView = StoryboardViewControllerResource<StorageContent_Controller>(identifier: "StorageContentView")
      let storageContent_CollectionView = StoryboardViewControllerResource<StorageContent_CollectionController>(identifier: "StorageContent_CollectionView")
      
      func storageContentView(_: Void = ()) -> StorageContent_Controller? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: storageContentView)
      }
      
      func storageContent_CollectionView(_: Void = ()) -> StorageContent_CollectionController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: storageContent_CollectionView)
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "trash") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'trash' is used in storyboard 'Storage', but couldn't be loaded.") }
        if UIKit.UIImage(named: "check") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'check' is used in storyboard 'Storage', but couldn't be loaded.") }
        if UIKit.UIImage(named: "closeButton") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'closeButton' is used in storyboard 'Storage', but couldn't be loaded.") }
        if UIKit.UIImage(named: "consume") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'consume' is used in storyboard 'Storage', but couldn't be loaded.") }
        if UIKit.UIImage(named: "plus") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'plus' is used in storyboard 'Storage', but couldn't be loaded.") }
        if _R.storyboard.storage().storageContentView() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'storageContentView' could not be loaded from storyboard 'Storage' as 'StorageContent_Controller'.") }
        if _R.storyboard.storage().storageContent_CollectionView() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'storageContent_CollectionView' could not be loaded from storyboard 'Storage' as 'StorageContent_CollectionController'.") }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
