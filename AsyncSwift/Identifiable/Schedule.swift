//
//  Schedule.swift
//  AsyncSwift
//
//  Created by Kim Insub on 2022/09/06.
//

import Foundation

struct Schedule: Identifiable, Codable {
    let id: Int
    var time: String
    var title: String
    var desc: String
    var speaker: Speaker

    struct Speaker: Codable {
        var name: String
        var image: String
    }
}

struct ScheduleModel: Identifiable, Codable {
    var id: Int
    var time: String
    var title: String
    var desc: String
    var speaker: SpeakerModel
}

struct SpeakerModel: Codable {
    var name: String
    var image: String
}
