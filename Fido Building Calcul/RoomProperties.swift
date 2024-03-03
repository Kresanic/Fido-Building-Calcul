////
////  RoomProperties.swift
////  Fido Building Calcul
////
////  Created by Peter Kresanič on 26/07/2023.
////
//
//import CoreData
//import Foundation
//
//public class RoomProperties: NSObject, NSSecureCoding {
//    
//    public static var supportsSecureCoding: Bool = true
//    
//    var buraciePrace: Int?
//    var elektroinstalaterskePrace: Int?
//    var vodoinstalaterskePrace: Int?
//    var murovaniePriecok: MurovaniePriecok?
//    
//    enum Keys: String {
//        case buraciePrace = "buraciePrace"
//        case elektroinstalaterskePrace = "elektroinstalaterskePrace"
//        case vodoinstalaterskePrace = "vodoinstalaterskePrace"
//        case murovaniePriecok = "murovaniePriecok"
//    }
//    
//    init(buraciePrace: Int?, elektroinstalaterskePrace: Int?, vodoinstalaterskePrace: Int?, murovaniePriecok: MurovaniePriecok?) {
//        self.buraciePrace = buraciePrace
//        self.elektroinstalaterskePrace = elektroinstalaterskePrace
//        self.vodoinstalaterskePrace = vodoinstalaterskePrace
//        self.murovaniePriecok = murovaniePriecok
//    }
//    
//    public func encode(with coder: NSCoder) {
//        coder.encode(buraciePrace, forKey: Keys.buraciePrace.rawValue)
//        coder.encode(elektroinstalaterskePrace, forKey: Keys.elektroinstalaterskePrace.rawValue)
//        coder.encode(vodoinstalaterskePrace, forKey: Keys.elektroinstalaterskePrace.rawValue)
//        if let murovaniePriecok = murovaniePriecok {
//                let data = try? NSKeyedArchiver.archivedData(withRootObject: murovaniePriecok, requiringSecureCoding: false)
//                coder.encode(data, forKey: Keys.murovaniePriecok.rawValue)
//            }
//    }
//    
//    public required convenience init?(coder: NSCoder) {
//        
//        let codedBuraciePrace = coder.decodeObject(of: NSNumber.self, forKey: Keys.buraciePrace.rawValue)
//        let codedElektroinstalaterskePrace = coder.decodeObject(of: NSNumber.self, forKey: Keys.elektroinstalaterskePrace.rawValue)
//        let codedVodoinstalaterskePrace = coder.decodeObject(of: NSNumber.self, forKey: Keys.vodoinstalaterskePrace.rawValue)
//        let murovaniePriecokData = coder.decodeObject(forKey: Keys.murovaniePriecok.rawValue) as? Data
//            var murovaniePriecok: MurovaniePriecok?
//            if let data = murovaniePriecokData {
//                murovaniePriecok = try? NSKeyedUnarchiver.unarchivedObject(ofClass: MurovaniePriecok.self, from: data)
//            }
//
//            self.init(buraciePrace: codedBuraciePrace as? Int,
//                      elektroinstalaterskePrace: codedElektroinstalaterskePrace as? Int,
//                      vodoinstalaterskePrace: codedVodoinstalaterskePrace as? Int,
//                      murovaniePriecok: murovaniePriecok)
//    }
//    
//}
//
//class MurovaniePriecok: NSObject, NSCoding {
//    var priecky: [Dictionary<String, String>]
//
//    init(priecky: [Dictionary<String, String>]) {
//        self.priecky = priecky
//    }
//
//    required convenience init?(coder aDecoder: NSCoder) {
//        let priecky = aDecoder.decodeObject(forKey: "priecky") as? [Dictionary<String, String>] ?? []
//        self.init(priecky: priecky)
//    }
//
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(priecky, forKey: "data")
//    }
//}
//
//@objc(RoomPropertiesAttributeTransformer)
//class RoomPropertiesAttributeTransformer: NSSecureUnarchiveFromDataTransformer {
//    
//    override static var allowedTopLevelClasses: [AnyClass] {
//            return super.allowedTopLevelClasses + [RoomProperties.self, MurovaniePriecok.self]
//        }
//    
//    static func register() {
//        let className = String(describing: RoomPropertiesAttributeTransformer.self)
//        let name = NSValueTransformerName(className)
//        let transformer = RoomPropertiesAttributeTransformer()
//        
//        ValueTransformer.setValueTransformer(transformer, forName: name)
//    }
//    
//}
//
//struct RoomPropertiesHelper {
//    
//    func addWindowToObject(length: Int, height: Int) -> Dictionary<String, Int> {
//        return ["length": length, "height": height]
//    }
//    
//    func murovaniePriecok(length: Int, height: Int, windows: [Dictionary<String, Int>]?, doors: [Dictionary<String, Int>]?) -> Dictionary<String, Any?> {
//        
//        return [
//            "length": length,
//            "height": height,
//            "windows": windows,
//            "doors": doors
//        ]
//        
//    }
//    
//    
//}
