//
//  Message.swift
//  WebRTC-Demo
//
//  Created by Stasel on 20/02/2019.
//  Copyright © 2019 Stasel. All rights reserved.
//

import Foundation

enum Message {
    case sdp(SessionDescription)
    case candidate(IceCandidate)
    case rawPoints(RawPoints)  // Add new case for RawPoints
}

struct Point: Codable {
    let x: Double
    let y: Double
}

struct RawPoints: Codable {
    let points: [Point]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.points = try container.decode([Point].self)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(points)
    }
}

extension Message: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        switch type {
        case String(describing: SessionDescription.self):
            self = .sdp(try container.decode(SessionDescription.self, forKey: .payload))
        case String(describing: IceCandidate.self):
            self = .candidate(try container.decode(IceCandidate.self, forKey: .payload))
        case "RawPoints":
            self = .rawPoints(try container.decode(RawPoints.self, forKey: .payload)) // Decoding RawPoints
        default:
            throw DecodeError.unknownType
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .sdp(let sessionDescription):
            try container.encode(sessionDescription, forKey: .payload)
            try container.encode(String(describing: SessionDescription.self), forKey: .type)
        case .candidate(let iceCandidate):
            try container.encode(iceCandidate, forKey: .payload)
            try container.encode(String(describing: IceCandidate.self), forKey: .type)
        case .rawPoints(let rawPoints):
            try container.encode(rawPoints, forKey: .payload)
            try container.encode("RawPoints", forKey: .type)
        }
        
    }
    
    enum DecodeError: Error {
        case unknownType
    }
    
    enum CodingKeys: String, CodingKey {
        case type, payload
    }
}
