//
//  KPMediaLinks.swift
//  
//
//  Created by Alexey Siginur on 30/01/2022.
//

import Foundation

public class KPMediaLinks: DecodableFromRawData {
    public let id: Int
    public let files: [File]
    public let subtitles: [Subtitle]
    
    required init(raw: RawData) throws {
        self.id = try raw.parse(key: "id")
        self.files = try raw.parse(key: "files", type: [RawData].self).map(File.init(raw:))
        self.subtitles = try raw.parse(key: "subtitles", type: [RawData].self).map(Subtitle.init(raw:))
    }
}

public extension KPMediaLinks {
    class File: DecodableFromRawData {
        public let codec: String
        public let width: Int
        public let height: Int
        public let quality: String
        public let file: String
        public let url: [String: URL]
        
        required init(raw: RawData) throws {
            self.codec = try raw.parse(key: "codec")
            self.width = try raw.parse(key: "w")
            self.height = try raw.parse(key: "h")
            self.quality = try raw.parse(key: "quality")
            self.file = try raw.parse(key: "file")
            
            let urls = try raw.parse(key: "url", type: RawData.self)
            var url = [String: URL]()
            for (key, value) in urls {
                guard let value = value as? String, let link = URL(string: value) else {
                    throw ParsingError.wrongType(key: NSNull(), expectedType: String(describing: URL.self), actualType: String(describing: Swift.type(of: value)))
                }
                url[key] = link
            }
            self.url = url
        }
    }
    
    class Subtitle: DecodableFromRawData {
        public let lang: String
        public let shift: Int
        public let embed: Bool
        public let forced: Bool
        public let file: String
        public let url: URL
        
        required init(raw: RawData) throws {
            self.lang = try raw.parse(key: "lang")
            self.shift = try raw.parse(key: "shift")
            self.embed = try raw.parse(key: "embed")
            self.forced = try raw.parse(key: "forced")
            self.file = try raw.parse(key: "file")
            self.url = try raw.parse(key: "url")
        }
    }
}
