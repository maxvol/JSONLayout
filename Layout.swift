//
//  Layout.swift
//  JSONLayout
//
//  Created by Maxim Volgin on 10/02/2019.
//  Copyright © 2019 Maxim Volgin. All rights reserved.
//

import UIKit

public enum LayoutError: Error {
    case fileNotFound(String)
    case classNotFound(String)
}

public typealias ViewOfTypeForID = (String, String) -> UIView?
public typealias DidCreateViewForID = (UIView, String) -> Void
public typealias FormatOptionsForConstraintID = (String) -> NSLayoutConstraint.FormatOptions

public class Layout {
    private var views: [String: UIView] = [:]
    private var metrics: [String: Float] = [:]
    private var constraints = [NSLayoutConstraint]()
    private let layout: MarkupLayout
    
    public init(name: String) throws {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else {
            throw LayoutError.fileNotFound("\(name).json")
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        self.layout = try decoder.decode(MarkupLayout.self, from: data)
    }
    
    private func addConstraint(id: String, visualFormat: String) {
        self.constraints += NSLayoutConstraint.constraints(
            withVisualFormat: visualFormat,
            options: self.formatOptions(id),
            metrics: metrics,
            views: views)
    }
    
    private func add(views: [String: MarkupElement], to root: UIView) throws {
        for (id, view) in views {
            guard let v = self.viewOfType(view.type, id) else {
                throw LayoutError.classNotFound(view.type)
            }
            self.didCreateView(v, id)
            v.translatesAutoresizingMaskIntoConstraints = false
            v.tag = id.hash
            self.views[id] = v
            root.addSubview(v)
            if let children = view.children {
                // recursion
                try self.add(views: children, to: v)
            }
        }
    }
    
    public func inflate(in root: UIView) throws {
        root.translatesAutoresizingMaskIntoConstraints = false
        try self.add(views: layout.views, to: root)
        self.metrics = layout.metrics
        for (id, constraint) in layout.constraints {
            self.addConstraint(id: id, visualFormat: constraint)
        }
        NSLayoutConstraint.activate(self.constraints)
        root.layoutSubviews()
    }
    
    public static func view(of type: String) -> UIView? {
        if let cls = NSClassFromString(type) as? UIView.Type {
            let v = cls.init()
            return v
        }
        return nil
    }
    
    // MARK: - configuration
    
    public var formatOptions: FormatOptionsForConstraintID = { (id) -> NSLayoutConstraint.FormatOptions in [] }
    public var viewOfType: ViewOfTypeForID = { (type, id) -> UIView? in return Layout.view(of: type) }
    public var didCreateView: DidCreateViewForID = { (view, id) -> Void in return }
    
}

extension Layout {
    @discardableResult
    public func configure(_ closure: (Layout) -> Void) -> Layout {
        closure(self)
        return self
    }
}
