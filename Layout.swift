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
}

public protocol LayoutDelegate {
    func didCreate(_ view: UIView, with id: String)
    func formatOptions(for constraint: String) -> NSLayoutConstraint.FormatOptions
}

public class Layout {
    private var views: [String: UIView] = [:]
    private var metrics: [String: Float] = [:]
    private var constraints = [NSLayoutConstraint]()
    private let delegate: LayoutDelegate?
    private let layout: MarkupLayout
    
    public init(name: String, delegate: LayoutDelegate? = nil) throws {
        self.delegate = delegate
        guard let url = Bundle.main.url(forResource: name, withExtension: "json") else { throw LayoutError.fileNotFound("\(name).json") }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        self.layout = try decoder.decode(MarkupLayout.self, from: data)
    }
    
    private func addConstraint(id: String, visualFormat: String) {
        self.constraints += NSLayoutConstraint.constraints(
            withVisualFormat: visualFormat,
            options: self.delegate?.formatOptions(for: id) ?? [],
            metrics: metrics,
            views: views)
    }
    
    private func add(views: [String: MarkupElement], to root: UIView) {
        for (id, view) in views {
            guard let cls = NSClassFromString(view.type) as? UIView.Type else { continue }
            let v = cls.init()
            self.delegate?.didCreate(v, with: id)
            v.translatesAutoresizingMaskIntoConstraints = false
            v.tag = id.hash
            self.views[id] = v
            root.addSubview(v)
            if let children = view.children {
                // recursion
                self.add(views: children, to: v)
            }
        }
    }
    
    public func inflate(in root: UIView) {
        root.translatesAutoresizingMaskIntoConstraints = false
        self.add(views: layout.views, to: root)
        self.metrics = layout.metrics
        for (id, constraint) in layout.constraints {
            self.addConstraint(id: id, visualFormat: constraint)
        }
        NSLayoutConstraint.activate(self.constraints)
        root.layoutSubviews()
    }
    
}

