//
//  KPMediaLinks.swift
//  
//
//  Created by Alexey Siginur on 30/01/2022.
//

import Foundation

public class KPMediaLinks: Codable, Hashable, Identifiable, KPJsonRepresentable {
    public let id: Int
    public let files: [File]
    public let subtitles: [Subtitle]
    
    public required init(json: KPJson) throws {
        self.id = try json.parse(key: "id")
        self.files = try json.parse(key: "files", type: [KPJson].self).map(File.init(json:))
        self.subtitles = try json.parse(key: "subtitles", type: [KPJson].self).map(Subtitle.init(json:))
    }
    
    public init(id: Int, files: [KPMediaLinks.File], subtitles: [KPMediaLinks.Subtitle]) {
        self.id = id
        self.files = files
        self.subtitles = subtitles
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(files)
        hasher.combine(subtitles)
    }
    
    public static func == (lhs: KPMediaLinks, rhs: KPMediaLinks) -> Bool {
        return lhs.id == rhs.id &&
        lhs.files == rhs.files &&
        lhs.subtitles == rhs.subtitles
    }
}

public extension KPMediaLinks {
    class File: Codable, Hashable, KPJsonRepresentable {
        public let codec: String
        public let width: Int
        public let height: Int
        public let quality: String
        public let file: String
        public let url: [String: URL]?
        
        public required init(json: KPJson) throws {
            self.codec = try json.parse(key: "codec")
            self.width = try json.parse(key: "w")
            self.height = try json.parse(key: "h")
            self.quality = try json.parse(key: "quality")
            self.file = try json.parse(key: "file")
            
            if let urls = try? json.parse(key: "url", type: KPJson.self) {
                var url = [String: URL]()
                for (key, value) in urls {
                    guard let value = value as? String, let link = URL(string: value) else {
                        throw ParsingError.wrongType(key: NSNull(), expectedType: String(describing: URL.self), actualType: String(describing: Swift.type(of: value)))
                    }
                    url[key] = link
                }
                self.url = url
            }
            else {
                self.url = [:]
            }
        }
        
        public init(codec: String, width: Int, height: Int, quality: String, file: String, url: [String : URL]?) {
            self.codec = codec
            self.width = width
            self.height = height
            self.quality = quality
            self.file = file
            self.url = url
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(codec)
            hasher.combine(width)
            hasher.combine(height)
            hasher.combine(quality)
            hasher.combine(file)
            hasher.combine(url)
        }
        
        public static func == (lhs: KPMediaLinks.File, rhs: KPMediaLinks.File) -> Bool {
            return lhs.codec == rhs.codec &&
            lhs.width == rhs.width &&
            lhs.height == rhs.height &&
            lhs.quality == rhs.quality &&
            lhs.file == rhs.file &&
            lhs.url == rhs.url
        }
    }
    
    class Subtitle: Codable, Hashable, KPJsonRepresentable {
        public let lang: String
        public let shift: Int
        public let embed: Bool
        public let forced: Bool
        public let file: String
        public let url: URL
        
        public required init(json: KPJson) throws {
            self.lang = try json.parse(key: "lang")
            self.shift = try json.parse(key: "shift")
            self.embed = try json.parse(key: "embed")
            self.forced = try json.parse(key: "forced")
            self.file = try json.parse(key: "file")
            self.url = try json.parse(key: "url")
        }
        
        public init(lang: String, shift: Int, embed: Bool, forced: Bool, file: String, url: URL) {
            self.lang = lang
            self.shift = shift
            self.embed = embed
            self.forced = forced
            self.file = file
            self.url = url
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(lang)
            hasher.combine(shift)
            hasher.combine(embed)
            hasher.combine(forced)
            hasher.combine(file)
            hasher.combine(url)
        }
        
        public static func == (lhs: KPMediaLinks.Subtitle, rhs: KPMediaLinks.Subtitle) -> Bool {
            return lhs.lang == rhs.lang &&
            lhs.shift == rhs.shift &&
            lhs.embed == rhs.embed &&
            lhs.forced == rhs.forced &&
            lhs.file == rhs.file &&
            lhs.url == rhs.url
        }
    }
}
