//
//  UIColorExtension.swift
//  Alamofire
//
//  Created by Bartek Żabicki on 07/10/2018.
//

import UIKit

extension UIColor {
  
  /**
   Function generate red, green, blue and alpha values from UIColor
   - Returns: A tuple with (`red`, `green`, `blue`, `alpha`) values
 */
  public func rgb() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
    var fractionRed: CGFloat = 0
    var fractionGreen: CGFloat = 0
    var fractionBlue: CGFloat = 0
    var fractionAlpha: CGFloat = 0
    
    if getRed(&fractionRed, green: &fractionGreen, blue: &fractionBlue, alpha: &fractionAlpha) {
      let red = fractionRed * 255.0
      let green = fractionGreen * 255.0
      let blue = fractionBlue * 255.0
      let alpha = fractionAlpha * 255.0
      
      return (red: red, green: green, blue: blue, alpha: alpha)
    } else {
      return nil
    }
  }
  
  ///Function generate hex string from UIColor
  public func toHexString() -> String {
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0
    
    getRed(&r, green: &g, blue: &b, alpha: &a)
    
    let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
    
    return NSString(format:"#%06x", rgb) as String
  }
  
  /**
   Convenience constructor which from hex value of color generates UIColor
   - Parameter hexString: The hex value of color
 */
  public convenience init(hexString:String) {
    let hexString: NSString = hexString.trimmingCharacters(in: .whitespacesAndNewlines) as NSString
    let scanner = Scanner(string: hexString as String)
    
    if (hexString.hasPrefix("#")) {
      scanner.scanLocation = 1
    }
    
    var color: UInt32 = 0
    scanner.scanHexInt32(&color)
    
    let mask = 0x000000FF
    let r = Int(color >> 16) & mask
    let g = Int(color >> 8) & mask
    let b = Int(color) & mask
    
    let red   = CGFloat(r) / 255.0
    let green = CGFloat(g) / 255.0
    let blue  = CGFloat(b) / 255.0
    
    self.init(red:red, green:green, blue:blue, alpha:1)
  }
  
  /**
   Generates random color
   - Parameter from: The optional sourceColor which is treated like a 'mask', e.g. if you put here white with alpha 0.8, then every generated color will be pastel
 */
  public static func generateRandomColor(from sourceColor: UIColor?) -> UIColor {
    var red = CGFloat.random(in: 0...256)
    var green = CGFloat.random(in: 0...256)
    var blue = CGFloat.random(in: 0...256)
    
    if let sourceColor = sourceColor, let rgb = sourceColor.rgb() {
      red = (red + rgb.red)/2
      green = (green + rgb.green)/2
      blue = (blue + rgb.blue)/2
    }
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1)
  }
  
}
