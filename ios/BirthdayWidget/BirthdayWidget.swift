import WidgetKit
import SwiftUI

// MARK: - Data Model

struct BirthdayEntry: TimelineEntry {
    let date: Date
    let birthdays: [WidgetBirthday]
}

struct WidgetBirthday: Codable, Identifiable {
    let name: String
    let daysUntil: Int
    let month: Int
    let day: Int
    let ageText: String

    var id: String { "\(name)_\(month)_\(day)" }
}

// MARK: - Timeline Provider

struct BirthdayTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> BirthdayEntry {
        BirthdayEntry(date: Date(), birthdays: [
            WidgetBirthday(name: "홍길동", daysUntil: 3, month: 4, day: 15, ageText: "만 25세"),
        ])
    }

    func getSnapshot(in context: Context, completion: @escaping (BirthdayEntry) -> Void) {
        let entry = BirthdayEntry(date: Date(), birthdays: loadBirthdays())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BirthdayEntry>) -> Void) {
        let birthdays = loadBirthdays()
        let entry = BirthdayEntry(date: Date(), birthdays: birthdays)

        let calendar = Calendar.current
        let midnight = calendar.startOfDay(
            for: calendar.date(byAdding: .day, value: 1, to: Date())!
        )

        let timeline = Timeline(entries: [entry], policy: .after(midnight))
        completion(timeline)
    }

    private func loadBirthdays() -> [WidgetBirthday] {
        guard
            let userDefaults = UserDefaults(suiteName: "group.com.rudqlsdla.rememberotter"),
            let jsonString = userDefaults.string(forKey: "upcoming_birthdays"),
            let data = jsonString.data(using: .utf8)
        else {
            return []
        }

        do {
            return try JSONDecoder().decode([WidgetBirthday].self, from: data)
        } catch {
            return []
        }
    }
}

// MARK: - Fonts

extension Font {
    static func mapleBold(_ size: CGFloat) -> Font {
        .custom("MaplestoryBold", size: size)
    }
    static func mapleLight(_ size: CGFloat) -> Font {
        .custom("MaplestoryLight", size: size)
    }
}

// MARK: - Colors

extension Color {
    static let widgetPrimary = Color(red: 0.722, green: 0.639, blue: 0.902)
    static let widgetAccent = Color(red: 0.925, green: 0.282, blue: 0.600)
    static let widgetTextPrimary = Color(red: 0.067, green: 0.094, blue: 0.153)
    static let widgetTextSecondary = Color(red: 0.420, green: 0.447, blue: 0.502)
    static let widgetTextTertiary = Color(red: 0.612, green: 0.639, blue: 0.682)
}

// MARK: - Small Widget View

struct SmallWidgetView: View {
    let entry: BirthdayEntry

    var body: some View {
        if let birthday = entry.birthdays.first {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image("OtterIcon")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("기억해달")
                        .font(.mapleBold(13))
                        .foregroundColor(.widgetPrimary)
                    Spacer()
                }

                Spacer()

                Text(birthday.name)
                    .font(.mapleBold(18))
                    .foregroundColor(.widgetTextPrimary)
                    .lineLimit(1)

                Text("\(birthday.month)월 \(birthday.day)일")
                    .font(.mapleLight(12))
                    .foregroundColor(.widgetTextSecondary)

                if !birthday.ageText.isEmpty {
                    Text(birthday.ageText)
                        .font(.mapleLight(11))
                        .foregroundColor(.widgetTextTertiary)
                }

                Spacer()

                HStack {
                    Spacer()
                    DdayBadge(daysUntil: birthday.daysUntil)
                }
            }
            .widgetPadding()
        } else {
            EmptyWidgetView()
        }
    }
}

// MARK: - Medium Widget View

struct MediumWidgetView: View {
    let entry: BirthdayEntry

    var body: some View {
        if entry.birthdays.isEmpty {
            EmptyWidgetView()
        } else {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Image("OtterIcon")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("기억해달")
                        .font(.mapleBold(13))
                        .foregroundColor(.widgetPrimary)
                    Spacer()
                }
                .padding(.bottom, 8)

                ForEach(
                    Array(entry.birthdays.prefix(3).enumerated()), id: \.element.id
                ) { index, birthday in
                    if index > 0 {
                        Divider()
                            .padding(.vertical, 2)
                    }
                    BirthdayRow(birthday: birthday)
                }

                Spacer(minLength: 0)
            }
            .widgetPadding()
        }
    }
}

// MARK: - Birthday Row

struct BirthdayRow: View {
    let birthday: WidgetBirthday

    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(birthday.name)
                    .font(.mapleBold(15))
                    .foregroundColor(.widgetTextPrimary)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    Text("\(birthday.month)월 \(birthday.day)일")
                        .font(.mapleLight(12))
                        .foregroundColor(.widgetTextSecondary)

                    if !birthday.ageText.isEmpty {
                        Text(birthday.ageText)
                            .font(.mapleLight(11))
                            .foregroundColor(.widgetTextTertiary)
                    }
                }
            }

            Spacer()

            DdayBadge(daysUntil: birthday.daysUntil)
        }
        .padding(.vertical, 3)
    }
}

// MARK: - D-day Badge

struct DdayBadge: View {
    let daysUntil: Int

    private var badgeColor: Color {
        daysUntil <= 1 ? .widgetAccent : .widgetPrimary
    }

    private var text: String {
        if daysUntil == 0 {
            return "D-Day"
        } else {
            return "D-\(daysUntil)"
        }
    }

    var body: some View {
        Text(text)
            .font(.mapleBold(12))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(badgeColor)
            .cornerRadius(10)
    }
}

// MARK: - Empty Widget View

struct EmptyWidgetView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image("OtterIcon")
                .resizable()
                .frame(width: 40, height: 40)
            Text("등록된 생일이 없어요")
                .font(.mapleLight(13))
                .foregroundColor(.widgetTextSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Padding Helper

extension View {
    func widgetPadding() -> some View {
        if #available(iOS 17.0, *) {
            return AnyView(self)
        } else {
            return AnyView(self.padding(14))
        }
    }
}

// MARK: - Widget Configuration

struct BirthdayWidget: Widget {
    let kind: String = "BirthdayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BirthdayTimelineProvider()) { entry in
            if #available(iOS 17.0, *) {
                BirthdayWidgetEntryView(entry: entry)
                    .containerBackground(Color.white, for: .widget)
            } else {
                BirthdayWidgetEntryView(entry: entry)
                    .background(Color.white)
            }
        }
        .configurationDisplayName("다가오는 생일")
        .description("소중한 사람들의 다가오는 생일을 확인하세요")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct BirthdayWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: BirthdayEntry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

// MARK: - Widget Bundle

@main
struct BirthdayWidgetBundle: WidgetBundle {
    var body: some Widget {
        BirthdayWidget()
    }
}
