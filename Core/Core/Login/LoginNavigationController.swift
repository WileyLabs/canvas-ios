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

import UIKit

public class LoginNavigationController: UINavigationController {
    weak var loginDelegate: LoginDelegate?

    public static func create(loginDelegate: LoginDelegate, fromLaunch: Bool = false) -> LoginNavigationController {
        var startView: UIViewController
        
        if let config = SchoolConfig.getConfig(), let host = config["host"] {
            startView = LoginWebViewController.create(host: host as! String, loginDelegate: loginDelegate, method: .normalLogin)
        } else {
            startView = LoginStartViewController.create(loginDelegate: loginDelegate, fromLaunch: fromLaunch)
        }
        let controller = LoginNavigationController(rootViewController: startView)
        controller.loginDelegate = loginDelegate
        return controller
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = nil // use platform default
        navigationBar.barTintColor = .named(.backgroundLightest)
        navigationBar.barStyle = .default
        navigationBar.isTranslucent = true
        isNavigationBarHidden = true
    }

    public func login(host: String) {
        if let config = SchoolConfig.getConfig(), let specificHost = config["host"] {
            viewControllers = [
                LoginWebViewController.create(host: specificHost as! String, loginDelegate: loginDelegate, method: .normalLogin)
            ]
        } else {
            viewControllers = [
                LoginStartViewController.create(loginDelegate: loginDelegate, fromLaunch: false),
                LoginFindSchoolViewController.create(loginDelegate: loginDelegate, method: .normalLogin),
                LoginWebViewController.create(host: host, loginDelegate: loginDelegate, method: .normalLogin),
            ]
            return
        }
    }
}
