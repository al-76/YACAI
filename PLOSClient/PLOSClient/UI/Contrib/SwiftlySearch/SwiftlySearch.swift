// https://github.com/thislooksfun/SwiftlySearch/blob/master/Sources/SwiftlySearch/SwiftlySearch.swift
//
// Copyright © 2020 thislooksfun
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the “Software”), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
// Modifications (Vyacheslav Konopkin):
// - Add searchDidBegin, textDidChange callbacks
//

import Combine
import SwiftUI

public extension View {
    @available(iOS, introduced: 13.0, deprecated: 15.0, message: "Use .searchable() and .onSubmit(of:) instead.")
    @available(macCatalyst, introduced: 13.0, deprecated: 15.0, message: "Use .searchable() and .onSubmit(of:) instead.")
    func navigationBarSearch(_ searchText: Binding<String>, placeholder: String? = nil, hidesNavigationBarDuringPresentation: Bool = true, hidesSearchBarWhenScrolling: Bool = true, cancelClicked: @escaping () -> Void = {}, searchClicked: @escaping () -> Void = {},
                             searchDidBegin: @escaping () -> Void = {},
                             textDidChange: @escaping () -> Void = {}) -> some View
    {
        return overlay(SearchBar<AnyView>(text: searchText, placeholder: placeholder, hidesNavigationBarDuringPresentation: hidesNavigationBarDuringPresentation, hidesSearchBarWhenScrolling: hidesSearchBarWhenScrolling, cancelClicked: cancelClicked, searchClicked: searchClicked, searchDidBegin: searchDidBegin, textDidChange: textDidChange).frame(width: 0, height: 0))
    }

    @available(iOS, introduced: 13.0, deprecated: 15.0, message: "Use .searchable() and .onSubmit(of:) instead.")
    @available(macCatalyst, introduced: 13.0, deprecated: 15.0, message: "Use .searchable() and .onSubmit(of:) instead.")
    func navigationBarSearch<ResultContent: View>(_ searchText: Binding<String>, placeholder: String? = nil, hidesNavigationBarDuringPresentation: Bool = true, hidesSearchBarWhenScrolling: Bool = true, cancelClicked: @escaping () -> Void = {}, searchClicked: @escaping () -> Void = {},
                                                  searchDidBegin: @escaping () -> Void = {},
                                                  textDidChange: @escaping () -> Void = {},
                                                  @ViewBuilder resultContent: @escaping (String) -> ResultContent) -> some View
    {
        return overlay(SearchBar(text: searchText, placeholder: placeholder, hidesNavigationBarDuringPresentation: hidesNavigationBarDuringPresentation, hidesSearchBarWhenScrolling: hidesSearchBarWhenScrolling, cancelClicked: cancelClicked, searchClicked: searchClicked, searchDidBegin: searchDidBegin, textDidChange: textDidChange, resultContent: resultContent).frame(width: 0, height: 0))
    }
}

struct SearchBar<ResultContent: View>: UIViewControllerRepresentable {
    @Binding
    var text: String
    let placeholder: String?
    let hidesNavigationBarDuringPresentation: Bool
    let hidesSearchBarWhenScrolling: Bool
    let cancelClicked: () -> Void
    let searchClicked: () -> Void
    let searchDidBegin: () -> Void
    let textDidChange: () -> Void
    let resultContent: (String) -> ResultContent?

    init(text: Binding<String>, placeholder: String?, hidesNavigationBarDuringPresentation: Bool, hidesSearchBarWhenScrolling: Bool, cancelClicked: @escaping () -> Void, searchClicked: @escaping () -> Void, searchDidBegin: @escaping () -> Void, textDidChange: @escaping () -> Void,
         @ViewBuilder resultContent: @escaping (String) -> ResultContent? = { _ in nil })
    {
        self._text = text
        self.placeholder = placeholder
        self.hidesNavigationBarDuringPresentation = hidesNavigationBarDuringPresentation
        self.hidesSearchBarWhenScrolling = hidesSearchBarWhenScrolling
        self.cancelClicked = cancelClicked
        self.searchClicked = searchClicked
        self.searchDidBegin = searchDidBegin
        self.textDidChange = textDidChange
        self.resultContent = resultContent
    }

    func makeUIViewController(context: Context) -> SearchBarWrapperController {
        return SearchBarWrapperController()
    }

    func updateUIViewController(_ controller: SearchBarWrapperController, context: Context) {
        controller.searchController = context.coordinator.searchController
        controller.hidesSearchBarWhenScrolling = hidesSearchBarWhenScrolling
        controller.text = text

        context.coordinator.update(placeholder: placeholder, cancelClicked: cancelClicked, searchClicked: searchClicked,
                                   searchDidBegin: searchDidBegin, textDidChange: textDidChange)

        if let resultView = resultContent(text) {
            (controller.searchController?.searchResultsController as? UIHostingController<ResultContent>)?.rootView = resultView
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, placeholder: placeholder, hidesNavigationBarDuringPresentation: hidesNavigationBarDuringPresentation, resultContent: resultContent, cancelClicked: cancelClicked, searchClicked: searchClicked,
                           searchDidBegin: searchDidBegin, textDidChange: textDidChange)
    }

    class Coordinator: NSObject, UISearchResultsUpdating, UISearchBarDelegate {
        @Binding
        var text: String
        var cancelClicked: () -> Void
        var searchClicked: () -> Void
        var searchDidBegin: () -> Void
        var textDidChange: () -> Void
        let searchController: UISearchController

        private var updatedText: String

        init(text: Binding<String>, placeholder: String?, hidesNavigationBarDuringPresentation: Bool, resultContent: (String) -> ResultContent?, cancelClicked: @escaping () -> Void, searchClicked: @escaping () -> Void, searchDidBegin: @escaping () -> Void,
             textDidChange: @escaping () -> Void) {
            self._text = text
            self.updatedText = text.wrappedValue
            self.cancelClicked = cancelClicked
            self.searchClicked = searchClicked
            self.searchDidBegin = searchDidBegin
            self.textDidChange = textDidChange

            let resultView = resultContent(text.wrappedValue)
            let searchResultController = resultView.map { UIHostingController(rootView: $0) }
            self.searchController = UISearchController(searchResultsController: searchResultController)

            super.init()

            searchController.searchResultsUpdater = self
            searchController.hidesNavigationBarDuringPresentation = hidesNavigationBarDuringPresentation
            searchController.obscuresBackgroundDuringPresentation = false

            searchController.searchBar.delegate = self
            searchController.searchBar.text = self.text
            searchController.searchBar.placeholder = placeholder
        }

        func update(placeholder: String?, cancelClicked: @escaping () -> Void, searchClicked: @escaping () -> Void,
                    searchDidBegin: @escaping () -> Void, textDidChange: @escaping () -> Void) {
            searchController.searchBar.placeholder = placeholder

            self.cancelClicked = cancelClicked
            self.searchClicked = searchClicked
            self.searchDidBegin = searchDidBegin
            self.textDidChange = textDidChange
        }

        // MARK: - UISearchResultsUpdating

        func updateSearchResults(for searchController: UISearchController) {
            guard let text = searchController.searchBar.text else { return }
            // Make sure the text has actually changed (workaround for #10).
            guard updatedText != text else { return }

            DispatchQueue.main.async {
                self.updatedText = text
                self.text = text
            }
        }

        // MARK: - UISearchBarDelegate

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            cancelClicked()
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchClicked()
        }

        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchDidBegin()
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            textDidChange()
        }
    }

    class SearchBarWrapperController: UIViewController {
        var text: String? {
            didSet {
                parent?.navigationItem.searchController?.searchBar.text = text
            }
        }

        var searchController: UISearchController? {
            didSet {
                parent?.navigationItem.searchController = searchController
            }
        }

        var hidesSearchBarWhenScrolling: Bool = true {
            didSet {
                self.parent?.navigationItem.hidesSearchBarWhenScrolling = hidesSearchBarWhenScrolling
            }
        }

        override func viewWillAppear(_ animated: Bool) {
            setup()
        }

        override func viewDidAppear(_ animated: Bool) {
            setup()
        }

        private func setup() {
            parent?.navigationItem.searchController = searchController
            parent?.navigationItem.hidesSearchBarWhenScrolling = hidesSearchBarWhenScrolling

            // make search bar appear at start (default behaviour since iOS 13)
            parent?.navigationController?.navigationBar.sizeToFit()
        }
    }
}
