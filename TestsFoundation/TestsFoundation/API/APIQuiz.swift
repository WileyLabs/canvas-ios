//
// Copyright (C) 2018-present Instructure, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Core

// https://canvas.instructure.com/doc/api/quiz_questions.html#QuizQuestion
public struct APIQuizQuestion: Codable {
    public let id: String
    public let quiz_id: String
    public let position: Int?
    public let question_name: String
    public let question_type: QuizQuestionType
    public let question_text: String
    public let points_possible: Int
    public let correct_comments: String
    public let incorrect_comments: String
    public let neutral_comments: String
    // public let answers: [APIQuizAnswer]?
}

// https://canvas.instructure.com/doc/api/quiz_submission_questions.html#QuizSubmissionQuestion
public struct APIQuizSubmissionQuestion: Codable {
    public let id: String
    public let flagged: Bool
    public let answer: APIQuizAnswerValue?
    // public let answers: [APIQuizAnswer]?
}

// https://canvas.instructure.com/doc/api/quiz_submission_questions.html#Question+Answer+Formats-appendix
public enum APIQuizAnswerValue: Codable {
    case double(Double)
    case string(String)
    case hash([String: String])
    case list([String])
    case matching([[String: String]])

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Double.self) {
            self = .double(value)
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode([String: String].self) {
            self = .hash(value)
        } else if let value = try? container.decode([String].self) {
            self = .list(value)
        } else {
            self = .matching(try container.decode([[String: String]].self))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        case .hash(let value):
            try container.encode(value)
        case .list(let value):
            try container.encode(value)
        case .matching(let value):
            try container.encode(value)
        }
    }
}
