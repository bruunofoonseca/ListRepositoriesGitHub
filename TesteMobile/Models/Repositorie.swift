//
//  Repositorie.swift
//  TesteMobile
//
//  Created by Bruno F. de Almeida on 25/06/20.
//  Copyright © 2020 Bruno F. de Almeida. All rights reserved.
//

import Foundation

struct Start : Decodable {
    let total_count: Int?
    let incomplete_results: Bool?
    let items: [Repositorie]?
}

struct Repositorie : Decodable {
    let id: Int
    let name: String
    let description: String
    let authorName: String
    let avatarUrl: String
    let stargazersCount: Int
    let forksCount: Int

    enum RepositorieKeys: String, CodingKey {
        case id
        case name = "name"
        case description = "description"
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case owner

        enum OwnerKeys: String, CodingKey {
            case authorName = "login"
            case avatarUrl = "avatar_url"
        }
    }

    init(from decoder: Decoder) throws {
        let repositorieContainer = try decoder.container(keyedBy: RepositorieKeys.self)
        id = try repositorieContainer.decode(Int.self, forKey: .id)
        name = try repositorieContainer.decode(String.self, forKey: .name)
        description = try repositorieContainer.decode(String.self, forKey: .description)
        stargazersCount = try repositorieContainer.decode(Int.self, forKey: .stargazersCount)
        forksCount = try repositorieContainer.decode(Int.self, forKey: .forksCount)

        let ownerContainer = try repositorieContainer.nestedContainer(keyedBy: RepositorieKeys.OwnerKeys.self, forKey: .owner)
        authorName = try ownerContainer.decode(String.self, forKey: .authorName)
        avatarUrl = try ownerContainer.decode(String.self, forKey: .avatarUrl)
    }
}
