// https://gist.github.com/arshad/de147c42d7b3063ef7bc

import UIKit

func HexStringToUIColor(hex:String) -> UIColor
{
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#"))
    {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6)
    {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func UIColorFromCat(cat: Category) -> UIColor
{
    switch  cat
    {
    case .BegProg:
        return HexStringToUIColor(hex: "#DC4245")
    case .IntProj:
        return HexStringToUIColor(hex: "#317354")
    case .AdvProj:
        return HexStringToUIColor(hex: "#FFE534")
    case .ResProj:
        return HexStringToUIColor(hex: "#047BFB")
    case .BegWebD:
        return HexStringToUIColor(hex: "#343A40")
    case .IntWebD:
        return HexStringToUIColor(hex: "#6C757D")
    }
}
