//
//  HTMLStringView.swift
//  TheArcXP
//
//  Created by Cassandra Balbuena on 4/14/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import WebKit
import SwiftUI

struct HTMLStringView: UIViewRepresentable {
    var width: CGFloat
    let html: String
    typealias UIViewType = LinkTextView
    let textView = LinkTextView(frame: .zero)
    @Environment(\.colorScheme) var colorScheme
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> LinkTextView {
        textView.textContainerInset = .zero
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.widthAnchor.constraint(equalToConstant: width).isActive = true
        return textView
    }
    
    func updateUIView(_ uiView: LinkTextView, context: Context) {
        let newFont = UIFont.preferredFont(forTextStyle: .body)
        if !html.isEmpty {
            DispatchQueue.main.async {
                let data = Data(html.utf8)
                if let attributedString = try? NSAttributedString(data: data,
                                                                  options: [.documentType: NSAttributedString.DocumentType.html,
                                                                            .characterEncoding: String.Encoding.utf8.rawValue],
                                                                  documentAttributes: nil) {
                    let mattrStr = NSMutableAttributedString(attributedString: attributedString)
                    mattrStr.beginEditing()
                    mattrStr.enumerateAttribute(.font,
                                                in: NSRange(location: 0, length: mattrStr.length),
                                                options: .longestEffectiveRangeNotRequired) { (value, range, _) in
                        if let oFont = value as? UIFont,
                            let newFontDescriptor = oFont.fontDescriptor
                            .withFamily(newFont.familyName)
                            .withSymbolicTraits(oFont.fontDescriptor.symbolicTraits) {
                            let nFont = UIFont(descriptor: newFontDescriptor, size: newFont.pointSize)
                            mattrStr.removeAttribute(.font, range: range)
                            mattrStr.addAttribute(.font, value: nFont, range: range)
                            mattrStr.addAttributes([NSAttributedString.Key.foregroundColor: colorScheme == .dark ?
                                                    ThemeManager.darkModeArticleTextColor : ThemeManager.lightModeArticleTextColor],
                                                   range: range)
                        }
                    }
                    mattrStr.endEditing()
                    textView.attributedText = mattrStr
                    textView.translatesAutoresizingMaskIntoConstraints = false
                    textView.widthAnchor.constraint(equalToConstant: width).isActive = true
                }
            }
        } else {
            textView.text = ""
        }
    }
}
