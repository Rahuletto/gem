
import Foundation

enum APIKey {
  static var `default`: String {
    guard let filePath = Bundle.main.path(forResource: "AI", ofType: "plist")
    else {
      fatalError("Couldn't find file 'AI.plist'.")
    }
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let value = plist?.object(forKey: "API_KEY") as? String else {
      fatalError("Couldn't find key 'API_KEY' in 'AI.plist'.")
    }
    return value
  }
}
