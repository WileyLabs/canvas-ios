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
import Core

class CourseCardCell: UICollectionViewCell {
    @IBOutlet var topView: UIView?
    @IBOutlet var optionsButton: UIButton?
    @IBOutlet var imageView: UIImageView?
    @IBOutlet var bottomView: UIView?
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var abbrevationLabel: UILabel?

    var optionsCallback: (() -> Void)?
    var optionsButtonCircle: CALayer?

    var course: Course? = nil {
        didSet {
            _accessibilityElements = nil
        }
    }

    private var _accessibilityElements: [Any]?
    override var accessibilityElements: [Any]? {
        set {
            _accessibilityElements = newValue
        }

        get {
            guard let course = course else {
                return nil
            }

            // Return the accessibility elements if we've already created them.
            if let elements = _accessibilityElements {
                return elements
            }

            var elements = [UIAccessibilityElement]()
            let cardElement = UIAccessibilityElement(accessibilityContainer: self)
            cardElement.accessibilityLabel = course.name
            cardElement.accessibilityFrameInContainerSpace = bounds
            elements.append(cardElement)

            _accessibilityElements = elements

            return _accessibilityElements
        }

    }

    private var _accessibilityCustomActions: [UIAccessibilityCustomAction]?
    override var accessibilityCustomActions: [UIAccessibilityCustomAction]? {
        set { _accessibilityCustomActions = newValue }

        get {
            return [
                UIAccessibilityCustomAction(
                    name: NSLocalizedString("Edit Course", bundle: .student, comment: ""),
                    target: self,
                    selector: #selector(activateEditCourse)
                ),
            ]
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        course = nil
        optionsCallback = nil
    }

    func configure(with model: Course, hideDashcardColorOverlays: Bool) {
        let color = model.color.ensureContrast(against: .named(.white))
        course = model
        titleLabel?.text = model.name
        titleLabel?.textColor = color
        abbrevationLabel?.text = model.courseCode

        if (model.showColorOverlay(hideOverlaySetting: hideDashcardColorOverlays)) {
            configureWithOverlay(color: color)
        } else {
            configureWithoutOverlay(color: color)
        }

        imageView?.load(url: model.imageDownloadURL)
    }

    func configureWithOverlay(color: UIColor) {
        topView?.backgroundColor = color
        imageView?.alpha = 0.4
        optionsButton?.backgroundColor = .clear
        optionsButton?.layer.cornerRadius = 0
        optionsButtonCircle?.removeFromSuperlayer()
    }

    func configureWithoutOverlay(color: UIColor) {
        topView?.backgroundColor = .white
        imageView?.alpha = 1

        guard let optionsButton = optionsButton else {
            return
        }
        let circleLayer = CALayer()
        circleLayer.frame = CGRect(x: 4, y: 4, width: optionsButton.bounds.width - 8, height: optionsButton.bounds.height - 8)
        circleLayer.backgroundColor = color.cgColor
        circleLayer.cornerRadius = circleLayer.frame.width / 2
        optionsButton.layer.insertSublayer(circleLayer, below: optionsButton.imageView?.layer)
        optionsButtonCircle = circleLayer
    }

    @IBAction func optionsButtonTapped(_ sender: Any) {
        optionsCallback?()
    }

    @objc
    func activateEditCourse() {
        optionsCallback?()
    }
}
