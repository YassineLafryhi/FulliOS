//
//  WebsiteReaderView.swift
//  FulliOS
//
//  Created by Yassine Lafryhi on 25/7/2024.
//

import SwiftUI

internal struct WebsiteReaderView: View {
    var body: some View {
        VStack {
            WebsiteReader(
                websiteURL: URL(
                    string: "https://ar.wikipedia.org/wiki/%D9%88%D9%8A%D9%83%D9%8A%D8%A8%D9%8A%D8%AF%D9%8A%D8%A7_%D8%A7%D9%84%D8%B9%D8%B1%D8%A8%D9%8A%D8%A9")!,
                websiteType: .news,
                articleURLPlaceholder: "", /* "/page/%d",*/
                contentID: "div.mw-content-rtl p",
                titleID: "header.firstHeading h1",
                articleImageSourceSelector: "images")
        }
    }
}
