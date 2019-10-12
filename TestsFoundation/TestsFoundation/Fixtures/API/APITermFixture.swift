//
// This file is part of Canvas.
// Copyright (C) 2019-present  Instructure, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

import Foundation
@testable import Core

extension APITerm {
    public static func make(
        id: ID = "1",
        name: String = "Term 1",
        start_at: Date? = nil,
        end_at: Date? = nil,
        workflow_state: WorkflowState? = nil
    ) -> APITerm {
        return APITerm(
            id: id,
            name: name,
            start_at: start_at,
            end_at: end_at,
            workflow_state: workflow_state
        )
    }
}
