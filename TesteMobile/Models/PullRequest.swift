//
//  PullRequest.swift
//  TesteMobile
//
//  Created by Bruno F. de Almeida on 28/06/20.
//  Copyright © 2020 Bruno F. de Almeida. All rights reserved.
//

import Foundation

struct PullRequest : Decodable {
    let title: String?
    let body: String?
    let data: String?
    let userName: String?
    let avatar: String?

    enum PullRequestKeys: String, CodingKey {
        case title
        case body
        case data = "created_at"
        case user

        enum UserKeys: String, CodingKey {
            case userName = "login"
            case avatar = "avatar_url"
        }
    }

    init(from decoder: Decoder) throws {
        let pullRequestContainer = try decoder.container(keyedBy: PullRequestKeys.self)
        title = try pullRequestContainer.decode(String.self, forKey: .title)
        body = try pullRequestContainer.decode(String.self, forKey: .body)
        data = try pullRequestContainer.decode(String.self, forKey: .data)

        let userContainer = try pullRequestContainer.nestedContainer(keyedBy: PullRequestKeys.UserKeys.self, forKey: .user)
        userName = try userContainer.decode(String.self, forKey: .userName)
        avatar = try userContainer.decode(String.self, forKey: .avatar)
    }
}
