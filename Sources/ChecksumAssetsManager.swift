import Foundation
import Vapor
import Cache

class ChecksumAssetsManager {
  let drop: Droplet
  private let cache: CacheProtocol

  init(_ drop: Droplet) {
    self.drop = drop
    cache = MemoryCache()
  }

  public var publicDir: String {
    return drop.workDir + "Public/"
  }

  public func add(_ fileUrl: String) throws -> String {
    if let cachedUrl = try cache.get(fileUrl) {
      return try String(node: cachedUrl)
    }

    let filePath = publicDir.appending(fileUrl)
    let fileData = try String(contentsOfFile: filePath, encoding: .utf8)
    let hash = try drop.hash.make(fileData)
    let urlWithChecksum = fileUrl + "?\(hash)"

    try cache.set(fileUrl, urlWithChecksum)

    return urlWithChecksum
  }
}
