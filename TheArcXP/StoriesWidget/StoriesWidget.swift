//
//  StoriesWidget.swift
//  StoriesWidget
//
//  Created by Amani Hunter on 7/12/22.
//  Copyright © 2022 Arc XP. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: IntentTimelineProvider {
    // Data for widget while in a transient state.
    let placeholderData = [HeadlineData(identifier: NSUUID().uuidString,
                                        headline: MockDataConstants.Headlines.storyOneHeadline,
                                        placeHolderImageFilename: MockDataConstants.Images.storyOneImage),
                           HeadlineData(identifier: NSUUID().uuidString,
                                        headline: MockDataConstants.Headlines.storyTwoHeadline,
                                        placeHolderImageFilename: MockDataConstants.Images.storyTwoImage),
                           HeadlineData(identifier: NSUUID().uuidString,
                                        headline: MockDataConstants.Headlines.storyThreeHeadline,
                                        placeHolderImageFilename: MockDataConstants.Images.storyThreeImage),
                           HeadlineData(identifier: NSUUID().uuidString,
                                        headline: MockDataConstants.Headlines.storyFourHeadline,
                                        placeHolderImageFilename: MockDataConstants.Images.storyFourImage),
                           HeadlineData(identifier: NSUUID().uuidString,
                                        headline: MockDataConstants.Headlines.storyFiveHeadline,
                                        placeHolderImageFilename: MockDataConstants.Images.storyFiveImage)]
    // MARK: - placeholder(in:)
    func placeholder(in context: Context) -> StoriesEntry {
        // Is called when the widget is displayed for the first time. This instance method is synchronous.
        return StoriesEntry(date: Date(), stories: placeholderData, section: "Top Stories")
    }
    // MARK: - getSnapshot(in:completion:)
    func getSnapshot(for configuration: SelectSectionIntent, in context: Context, completion: @escaping (StoriesEntry) -> Void) {
        // Is is called when the widget appears in transient situations such as when the user is adding a widget to their home screen.
        let entry = StoriesEntry(date: Date(),
                                 stories: placeholderData, section: "Top Stories")
        completion(entry)
    }
    
    // MARK: - getTimeline(in:completion:)
    func getTimeline(for configuration: SelectSectionIntent, in context: Context, completion: @escaping (Timeline<StoriesEntry>) -> Void) {
        // Supplies an array of entries based on time stamps for the widget to display. Asychronous or synchronous methods here.
        // SDK must be initialized before fetching content
        SDKInitializer.initializeArcXPSDKs()
        let alias = configuration.Section?.alias ?? Constants.WidgetConstants.alias
        let sectionDisplayName = configuration.Section?.displayString ?? "Top Stories"
        var entries: [StoriesEntry] = []
        var entry = StoriesEntry(date: Date(),
                                 stories: [HeadlineData](), section: sectionDisplayName)
        let viewModel = ContentViewModel()
        viewModel.fetchStoriesCollectionForWidget(alias: alias, index: 0, size: 5) { result in
            switch result {
            case .success(let stories):
                var imageURL: String?
                for story in stories {
                    if let imageURLString = SDKUtils.getResizeImageUrl(imageContentElement: story.promoItems?.content,
                                                                    isFullSize: false) {
                        imageURL = imageURLString
                    }
                    entry.stories.append(HeadlineData(identifier: story.identifier ?? "",
                                                      headline: story.headlines?.basic ?? "",
                                                      headlineImageURL: imageURL))
                }
                entries.append(entry)
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            case .failure:
                break
            }
        }
    }
}

struct StoriesEntry: TimelineEntry {
    let date: Date
    var stories: [HeadlineData]
    var section: String
}

struct HeadlineData: Identifiable {
    let identifier: String
    let headline: String
    var headlineImageURL: String?
    var placeHolderImageFilename: String?
    var id: String { identifier }
}

struct StoriesWidgetEntryView: View {
    var entry: Provider.Entry
    var body: some View {
        WidgetView(updatedTime: entry.date, section: entry.section, stories: entry.stories)
    }
}

@main
struct StoriesWidget: Widget {
    private let supportedFamilies: [WidgetFamily] = {
        if #available(iOSApplicationExtension 15.0, *) {
            return [.systemLarge, .systemExtraLarge]
        } else {
            return [.systemLarge]
        }
    }()
    let kind: String = Constants.WidgetConstants.kind
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: Constants.WidgetConstants.kind, intent: SelectSectionIntent.self, provider: Provider()) { entry in
            StoriesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(Constants.WidgetConstants.configurationDisplayName)
        .description(Constants.WidgetConstants.description)
        .supportedFamilies(supportedFamilies)
    }
}
