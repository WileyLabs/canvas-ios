//
// This file is part of Canvas.
// Copyright (C) 2018-present  Instructure, Inc.
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

import XCTest
import Core
import TestsFoundation
import CoreData
import CanvasCore
@testable import Parent

class ParentTestCase: XCTestCase {
    var database: NSPersistentContainer {
        return TestsFoundation.singleSharedTestDatabase
    }
    var databaseClient: NSManagedObjectContext {
        return database.viewContext
    }

    var api = MockURLSession.self
    var queue = OperationQueue()
    var router: TestRouter { env.router as! TestRouter }
    var env = TestEnvironment()
    var logger: TestLogger { env.logger as! TestLogger }
    var currentSession: LoginSession? { env.currentSession }

    override func setUp() {
        super.setUp()
        queue = OperationQueue()
        TestsFoundation.singleSharedTestDatabase = resetSingleSharedTestDatabase()
        env = TestEnvironment()
        env.mockStore = false
        AppEnvironment.shared = env
        MockURLSession.reset()
        MockUploadManager.reset()
        UploadManager.shared = MockUploadManager()
        ExperimentalFeature.allEnabled = false
        Parent.currentStudentID = "1"
        Parent.legacySession = Session.current
        UIView.setAnimationsEnabled(false)
    }
}
