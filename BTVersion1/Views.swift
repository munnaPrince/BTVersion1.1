//
//  Views.swift
//  BTVersion1
//
//  Created by Munnaf Koilakuntla on 28/08/26.
//

import SwiftUI

// MARK: - Theme
extension Color {
    static let primaryOrange = Color(red: 1.0, green: 0.58, blue: 0.38)
    static let accentBlue = Color(red: 0.07, green: 0.66, blue: 0.95)
    static let lightCard = Color(white: 0.97)
}

struct ContentView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        Group {
            if !store.loggedIn {
                LoginView()
            } else if store.profile?.age == nil || store.profile?.weightKg == nil || store.profile?.heightCm == nil {
                OnboardingView()
            } else {
                MainTabView()
            }
        }
        .animation(.easeInOut, value: store.loggedIn)
    }
}

struct Card<Content: View>: View {
    let content: Content
    init(@ViewBuilder _ content: () -> Content) { self.content = content() }
    var body: some View {
        content
            .padding()
            .background(Color.lightCard)
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
}

struct LoginView: View {
    @EnvironmentObject var store: AppStore
    @State private var name = ""
    @State private var email = ""
    @State private var gender = ""

    private let genders = ["Female", "Male", "Non-binary", "Prefer not to say"]

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 1.0, green: 0.96, blue: 0.91), Color.white], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primaryOrange)
                        Text("Welcome to Btracker")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                        Text("Create your profile and make every meal count.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Let’s get to know you")
                            .font(.headline)
                        RegistrationInputField(title: "Name", placeholder: "What should we call you?", icon: "person.fill", text: $name)
                        RegistrationInputField(title: "Email", placeholder: "you@example.com", icon: "envelope.fill", text: $email, isEmail: true)
                        HStack(spacing: 12) {
                            Image(systemName: "person.2.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primaryOrange)
                                .frame(width: 24)
                            Picker("Gender", selection: $gender) {
                                Text("How do you identify?").tag("")
                                ForEach(genders, id: \.self) { option in
                                    Text(option).tag(option)
                                }
                            }
                            .pickerStyle(.menu)
                            .tint(gender.isEmpty ? .secondary : .primary)
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal, 14)
                        .frame(minHeight: 58)
                        .background(Color.white.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.primaryOrange.opacity(gender.isEmpty ? 0.12 : 0.55), lineWidth: 1.5))

                        Button(action: {
                            let profile = UserProfile(name: name.trimmingCharacters(in: .whitespacesAndNewlines), email: email.trimmingCharacters(in: .whitespacesAndNewlines), gender: gender)
                            store.saveProfile(profile)
                        }) {
                            Label("Create profile", systemImage: "arrow.right.circle.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 4)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.primaryOrange)
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || gender.isEmpty)
                    }
                    .padding(20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color.primaryOrange.opacity(0.12), radius: 18, y: 8)

                    Text("Your information stays on this device.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(24)
            }
        }
    }
}

struct RegistrationInputField: View {
    let title: String
    let placeholder: String
    let icon: String
    @Binding var text: String
    var isEmail = false
    var isEditable = true

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primaryOrange)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title.uppercased())
                    .font(.caption2.weight(.bold))
                    .foregroundColor(.secondary)
                TextField(placeholder, text: $text)
                    .keyboardType(isEmail ? .emailAddress : .default)
                    .textInputAutocapitalization(isEmail ? .never : .words)
                    .textFieldStyle(.plain)
                    .disabled(!isEditable)
            }
        }
        .padding(.horizontal, 14)
        .frame(minHeight: 58)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.primaryOrange.opacity(text.isEmpty ? 0.12 : 0.55), lineWidth: 1.5))
    }
}

/*
struct OnboardingView: View {
    @EnvironmentObject var store: AppStore
    @State private var age = "30"
    @State private var weight = "70"
            VStack(alignment: .leading, spacing: 20) {

    var body: some View {
                    let consumed = consumedToday(store: store)
                    let firstName = p.name.split(separator: " ").first.map(String.init) ?? "there"

                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(greeting)
                                    .font(.subheadline.weight(.medium))
                                    .foregroundColor(.secondary)
                                Text(firstName)
                                    .font(.system(size: 34, weight: .bold, design: .rounded))
                            }
                            Spacer()
                            Image(systemName: "leaf.fill")
                                .font(.title2)
                                .foregroundColor(.primaryOrange)
                                .padding(12)
                                .background(Color.primaryOrange.opacity(0.12))
                                .clipShape(Circle())
                VStack(alignment: .leading, spacing: 24) {
                        Text(goalLabel(for: p.goal))
                            .font(.caption.weight(.semibold))
                            .foregroundColor(.primaryOrange)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.primaryOrange.opacity(0.12))
                            .clipShape(Capsule())
                    VStack(alignment: .leading, spacing: 10) {

                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("TODAY'S FUEL")
                                    .font(.caption2.weight(.bold))
                                    .foregroundColor(.white.opacity(0.75))
                                Text("Keep your momentum going")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            Image(systemName: "flame.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        HStack(spacing: 20) {
                            RingView(progress: progressFraction(store: store, targetCalories: t.calories), label: "\(consumed)", sublabel: "kcal eaten")
                                .frame(width: 142, height: 142)
                            VStack(alignment: .leading, spacing: 12) {
                                HomeStat(label: "Remaining", value: "\(max(0, t.calories - consumed)) kcal")
                                HomeStat(label: "Daily target", value: "\(t.calories) kcal")
                            }
                        }
                            Spacer()
                    .padding(20)
                    .background(LinearGradient(colors: [Color.primaryOrange, Color(red: 0.96, green: 0.35, blue: 0.25)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: Color.primaryOrange.opacity(0.25), radius: 14, y: 8)

                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("Your daily targets")
                                .font(.headline)
                            Spacer()
                            Image(systemName: "chart.bar.xaxis")
                                .foregroundColor(.accentBlue)
                        }
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            HomeMacroTile(title: "Protein", value: "\(t.proteinGrams) g", icon: "bolt.fill", color: .accentBlue)
                            HomeMacroTile(title: "Carbs", value: "\(t.carbsGrams) g", icon: "leaf.fill", color: .green)
                            HomeMacroTile(title: "Fats", value: "\(t.fatsGrams) g", icon: "drop.fill", color: .purple)
                            HomeMacroTile(title: "Logged", value: "\(store.entries.count) items", icon: "checkmark.circle.fill", color: .primaryOrange)
                        }
                    }

                    if store.entries.isEmpty {
                        HStack(spacing: 14) {
                            Image(systemName: "fork.knife.circle.fill")
                                .font(.title2)
                                .foregroundColor(.accentBlue)
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Ready for your first entry?").font(.subheadline.weight(.semibold))
                                Text("Scan a meal to start tracking today.").font(.caption).foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding(16)
                        .background(Color.accentBlue.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                            Text("Almost there")
                                .foregroundColor(.secondary)
            .padding(20)
                        Text("Build your baseline")
        .background(Color(red: 0.98, green: 0.98, blue: 0.97).ignoresSafeArea())
                            .font(.system(size: 34, weight: .bold, design: .rounded))

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<18: return "Good afternoon"
        default: return "Good evening"
        }
    }

    private func goalLabel(for goal: GoalType?) -> String {
        switch goal {
        case .muscleGain: return "Muscle gain focus"
        case .weightLoss: return "Weight loss focus"
        default: return "Balanced routine"
        }
    }
                        Text("A few details help us shape your daily targets around you.")

struct HomeStat: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(.caption).foregroundColor(.white.opacity(0.75))
            Text(value).font(.subheadline.weight(.bold)).foregroundColor(.white)
        }
    }
}

struct HomeMacroTile: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 30, height: 30)
                .background(color.opacity(0.12))
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.caption).foregroundColor(.secondary)
                Text(value).font(.subheadline.weight(.bold))
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your measurements")
                            .font(.headline)
                        OnboardingMetricField(title: "Age", value: $age, unit: "years", icon: "calendar", isDecimal: false)
                        OnboardingMetricField(title: "Weight", value: $weight, unit: "kg", icon: "scalemass.fill", isDecimal: true)
                        OnboardingMetricField(title: "Height", value: $height, unit: "cm", icon: "ruler.fill", isDecimal: true)
                    }
                    .padding(20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    VStack(alignment: .leading, spacing: 14) {
                        Label("What is your focus?", systemImage: "target")
                            .font(.headline)
                        Picker("Goal", selection: $goal) {
                            Text("Maintain").tag(GoalType.maintain)
                            Text("Muscle gain").tag(GoalType.muscleGain)
                            Text("Weight loss").tag(GoalType.weightLoss)
                        }
                        .pickerStyle(.segmented)
                        Text(goalDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }

                    Button(action: {
                        guard var p = store.profile else { return }
                        p.age = Int(age) ?? 30
                        p.weightKg = Double(weight) ?? 70
                        p.heightCm = Double(height) ?? 170
                        p.goal = goal
                        store.saveProfile(p)
                    }) {
                        Label("Continue to Btracker", systemImage: "arrow.right.circle.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 4)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.accentBlue)
                }
                .padding(24)
            }
        }
    }

    private var goalDescription: String {
        switch goal {
        case .maintain: return "Keep your current routine balanced."
        case .muscleGain: return "Prioritize fuel for strength and growth."
        case .weightLoss: return "Create a steady, mindful calorie target."
        }
    }
}

struct OnboardingMetricField: View {
    let title: String
    @Binding var value: String
    let unit: String
    let icon: String
    let isDecimal: Bool
    var isEditable = true

    init(title: String, value: Binding<String>, unit: String, icon: String, isDecimal: Bool, isEditable: Bool = true) {
        self.title = title
        self._value = value
        self.unit = unit
        self.icon = icon
        self.isDecimal = isDecimal
        self.isEditable = isEditable
    }
    var isEditable = true

    init(title: String, value: Binding<String>, unit: String, icon: String, isDecimal: Bool, isEditable: Bool = true) {
        self.title = title
        self._value = value
        self.unit = unit
        self.icon = icon
        self.isDecimal = isDecimal
        self.isEditable = isEditable
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.accentBlue)
                .frame(width: 24)
            Text(title)
                .font(.subheadline.weight(.medium))
            Spacer()
            TextField("0", text: $value)
                .keyboardType(isDecimal ? .decimalPad : .numberPad)
                .multilineTextAlignment(.trailing)
                .font(.headline)
                .frame(width: 80)
            Text(unit)
                .font(.caption.weight(.semibold))
                .foregroundColor(.secondary)
                .frame(width: 42, alignment: .leading)
        }
        .padding(.horizontal, 14)
        .frame(minHeight: 58)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.accentBlue.opacity(value.isEmpty ? 0.12 : 0.55), lineWidth: 1.5))
        .opacity(isEditable ? 1 : 0.72)
        .disabled(!isEditable)
    }
}

struct ProfilePickerField: View {
    let title: String
    let unit: String
    let icon: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let isEditable: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon).foregroundColor(.accentBlue).frame(width: 24)
            Text(title).font(.subheadline.weight(.medium))
            Spacer()
            Picker(title, selection: $value) {
                ForEach(Array(range), id: \.self) { number in
                    Text("\(number)").tag(number)
                }
            }
            .pickerStyle(.menu)
            .tint(.primary)
            .disabled(!isEditable)
            Text(unit).font(.caption.weight(.semibold)).foregroundColor(.secondary).frame(width: 42, alignment: .leading)
        }
        .padding(.horizontal, 14)
        .frame(minHeight: 58)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.accentBlue.opacity(isEditable ? 0.45 : 0.12), lineWidth: 1.5))
        .opacity(isEditable ? 1 : 0.72)
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView().tabItem { Label("Home", systemImage: "house.fill") }
            ScanView().tabItem { Label("Scan", systemImage: "camera.fill") }
            TrackerView().tabItem { Label("Tracker", systemImage: "chart.bar.fill") }
            WaterView().tabItem { Label("Water", systemImage: "drop.fill") }
            ProfileView().tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
    }
}

struct HomeView: View {
    @EnvironmentObject var store: AppStore
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack { Text("Good evening") .font(.title2).bold(); Spacer() }
                if let p = store.profile {
                    let t = MacroCalculator.targets(for: p)
                    Card {
                        VStack(spacing: 12) {
                            RingView(progress: progressFraction(store: store, targetCalories: t.calories), label: "\(consumedToday(store: store)) kcal", sublabel: "\(max(0, t.calories - consumedToday(store: store))) left")
                                .frame(height:180)
                            HStack { Text("Daily goal").foregroundColor(.secondary); Spacer(); Text("\(t.calories) kcal").bold() }
                        }
                    }
                    .padding(.bottom, 4)
                    HStack(spacing: 12) {
                        VStack(alignment:.leading) { Text("Protein target").font(.caption); Text("\(t.proteinGrams) g").bold() }
                        Spacer()
                    }
                }
                Spacer()
            }
            .padding()
        }
    }

    func consumedToday(store: AppStore) -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        return store.entries.filter { Calendar.current.startOfDay(for: $0.date) == today }.reduce(0) { $0 + $1.calories }
    }

    func progressFraction(store: AppStore, targetCalories: Int) -> Double {
        let consumed = consumedToday(store: store)
        guard targetCalories > 0 else { return 0 }
        return min(1.0, Double(consumed) / Double(targetCalories))
    }
}

*/
struct OnboardingView: View {
    @EnvironmentObject var store: AppStore
    @State private var age = "30"
    @State private var weight = "70"
    @State private var height = "170"
    @State private var goal: GoalType = .maintain

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.93, green: 0.98, blue: 1.0), Color.white], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Label("STEP 1 OF 1", systemImage: "sparkles").font(.caption.weight(.bold)).foregroundColor(.accentBlue)
                            Spacer()
                            Text("Almost there").font(.caption).foregroundColor(.secondary)
                        }
                        Text("Build your baseline").font(.system(size: 34, weight: .bold, design: .rounded))
                        Text("A few details help us shape your daily targets around you.").font(.subheadline).foregroundColor(.secondary)
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your measurements").font(.headline)
                        OnboardingMetricField(title: "Age", value: $age, unit: "years", icon: "calendar", isDecimal: false)
                        OnboardingMetricField(title: "Weight", value: $weight, unit: "kg", icon: "scalemass.fill", isDecimal: true)
                        OnboardingMetricField(title: "Height", value: $height, unit: "cm", icon: "ruler.fill", isDecimal: true)
                    }
                    .padding(20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    VStack(alignment: .leading, spacing: 14) {
                        Label("What is your focus?", systemImage: "target").font(.headline)
                        Picker("Goal", selection: $goal) {
                            Text("Maintain").tag(GoalType.maintain)
                            Text("Muscle gain").tag(GoalType.muscleGain)
                            Text("Weight loss").tag(GoalType.weightLoss)
                        }
                        .pickerStyle(.segmented)
                        Text(goalDescription).font(.caption).foregroundColor(.secondary).frame(maxWidth: .infinity, alignment: .center)
                    }
                    Button(action: {
                        guard var profile = store.profile else { return }
                        profile.age = Int(age) ?? 30
                        profile.weightKg = Double(weight) ?? 70
                        profile.heightCm = Double(height) ?? 170
                        profile.goal = goal
                        store.saveProfile(profile)
                    }) {
                        Label("Continue to Btracker", systemImage: "arrow.right.circle.fill")
                            .font(.headline).frame(maxWidth: .infinity).padding(.vertical, 4)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.accentBlue)
                }
                .padding(24)
            }
        }
    }

    private var goalDescription: String {
        switch goal {
        case .maintain: return "Keep your current routine balanced."
        case .muscleGain: return "Prioritize fuel for strength and growth."
        case .weightLoss: return "Create a steady, mindful calorie target."
        }
    }
}

struct OnboardingMetricField: View {
    let title: String
    @Binding var value: String
    let unit: String
    let icon: String
    let isDecimal: Bool

    var isEditable = true

    init(title: String, value: Binding<String>, unit: String, icon: String, isDecimal: Bool, isEditable: Bool = true) {
        self.title = title
        self._value = value
        self.unit = unit
        self.icon = icon
        self.isDecimal = isDecimal
        self.isEditable = isEditable
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon).font(.system(size: 16, weight: .semibold)).foregroundColor(.accentBlue).frame(width: 24)
            Text(title).font(.subheadline.weight(.medium))
            Spacer()
            TextField("0", text: $value).keyboardType(isDecimal ? .decimalPad : .numberPad).multilineTextAlignment(.trailing).font(.headline).frame(width: 80)
            Text(unit).font(.caption.weight(.semibold)).foregroundColor(.secondary).frame(width: 42, alignment: .leading)
        }
        .padding(.horizontal, 14)
        .frame(minHeight: 58)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.accentBlue.opacity(value.isEmpty ? 0.12 : 0.55), lineWidth: 1.5))
        .opacity(isEditable ? 1 : 0.72)
        .disabled(!isEditable)
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView().tabItem { Label("Home", systemImage: "house.fill") }
            ScanView().tabItem { Label("Scan", systemImage: "camera.fill") }
            TrackerView().tabItem { Label("Tracker", systemImage: "chart.bar.fill") }
            WaterView().tabItem { Label("Water", systemImage: "drop.fill") }
            ProfileView().tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
    }
}

struct HomeView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let profile = store.profile {
                    let targets = MacroCalculator.targets(for: profile)
                    let consumed = consumedToday(store: store)
                    let firstName = profile.name.split(separator: " ").first.map(String.init) ?? "there"
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(greeting).font(.subheadline.weight(.medium)).foregroundColor(.secondary)
                                Text(firstName).font(.system(size: 34, weight: .bold, design: .rounded))
                            }
                            Spacer()
                            Image(systemName: "leaf.fill").font(.title2).foregroundColor(.primaryOrange).padding(12).background(Color.primaryOrange.opacity(0.12)).clipShape(Circle())
                        }
                        Text(goalLabel(for: profile.goal)).font(.caption.weight(.semibold)).foregroundColor(.primaryOrange).padding(.horizontal, 10).padding(.vertical, 6).background(Color.primaryOrange.opacity(0.12)).clipShape(Capsule())
                    }
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("TODAY'S FUEL").font(.caption2.weight(.bold)).foregroundColor(.white.opacity(0.75))
                                Text("Keep your momentum going").font(.headline).foregroundColor(.white)
                            }
                            Spacer()
                            Image(systemName: "flame.fill").font(.title2).foregroundColor(.white)
                        }
                        HStack(spacing: 20) {
                            RingView(progress: progressFraction(store: store, targetCalories: targets.calories), label: "\(consumed)", sublabel: "kcal eaten").frame(width: 142, height: 142)
                            VStack(alignment: .leading, spacing: 12) {
                                HomeStat(label: "Remaining", value: "\(max(0, targets.calories - consumed)) kcal")
                                HomeStat(label: "Daily target", value: "\(targets.calories) kcal")
                            }
                        }
                    }
                    .padding(20)
                    .background(LinearGradient(colors: [Color.primaryOrange, Color(red: 0.96, green: 0.35, blue: 0.25)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: Color.primaryOrange.opacity(0.25), radius: 14, y: 8)
                    VStack(alignment: .leading, spacing: 14) {
                        HStack { Text("Your daily targets").font(.headline); Spacer(); Image(systemName: "chart.bar.xaxis").foregroundColor(.accentBlue) }
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            HomeMacroTile(title: "Protein", value: "\(targets.proteinGrams) g", icon: "bolt.fill", color: .accentBlue)
                            HomeMacroTile(title: "Carbs", value: "\(targets.carbsGrams) g", icon: "leaf.fill", color: .green)
                            HomeMacroTile(title: "Fats", value: "\(targets.fatsGrams) g", icon: "drop.fill", color: .purple)
                            HomeMacroTile(title: "Logged", value: "\(store.entries.count) items", icon: "checkmark.circle.fill", color: .primaryOrange)
                        }
                    }
                    if store.entries.isEmpty {
                        HStack(spacing: 14) {
                            Image(systemName: "fork.knife.circle.fill").font(.title2).foregroundColor(.accentBlue)
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Ready for your first entry?").font(.subheadline.weight(.semibold))
                                Text("Scan a meal to start tracking today.").font(.caption).foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding(16).background(Color.accentBlue.opacity(0.08)).clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
            }
            .padding(20)
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.97).ignoresSafeArea())
    }

    private var greeting: String {
        switch Calendar.current.component(.hour, from: Date()) {
        case 5..<12: return "Good morning"
        case 12..<18: return "Good afternoon"
        default: return "Good evening"
        }
    }

    private func goalLabel(for goal: GoalType?) -> String {
        switch goal {
        case .muscleGain: return "Muscle gain focus"
        case .weightLoss: return "Weight loss focus"
        default: return "Balanced routine"
        }
    }

    private func consumedToday(store: AppStore) -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        return store.entries.filter { Calendar.current.startOfDay(for: $0.date) == today }.reduce(0) { $0 + $1.calories }
    }

    private func progressFraction(store: AppStore, targetCalories: Int) -> Double {
        guard targetCalories > 0 else { return 0 }
        return min(1.0, Double(consumedToday(store: store)) / Double(targetCalories))
    }
}

struct HomeStat: View {
    let label: String
    let value: String
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(.caption).foregroundColor(.white.opacity(0.75))
            Text(value).font(.subheadline.weight(.bold)).foregroundColor(.white)
        }
    }
}

struct HomeMacroTile: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon).foregroundColor(color).frame(width: 30, height: 30).background(color.opacity(0.12)).clipShape(Circle())
            VStack(alignment: .leading, spacing: 2) { Text(title).font(.caption).foregroundColor(.secondary); Text(value).font(.subheadline.weight(.bold)) }
            Spacer(minLength: 0)
        }
        .padding(12).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

struct RingView: View {
    var progress: Double
    var label: String
    var sublabel: String
    var body: some View {
        ZStack {
            Circle().stroke(Color.primary.opacity(0.12), lineWidth: 18)
            Circle().trim(from: 0, to: progress)
                .stroke(Color.primaryOrange, style: StrokeStyle(lineWidth: 18, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
            VStack { Text(label).font(.title).bold(); Text(sublabel).font(.caption).foregroundColor(.secondary) }
        }
    }
}

struct ScanView: View {
    @EnvironmentObject var store: AppStore
    @State private var showingPicker = false
    @State private var pickedImage: UIImage?
    @State private var analysis: (calories:Int, carbs:Int, protein:Int, fats:Int)? = nil
    @State private var name = "Scanned Food"

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 1.0, green: 0.96, blue: 0.91), Color.white], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Scan your meal").font(.system(size: 32, weight: .bold, design: .rounded))
                        Text("Turn a photo into a simple nutrition snapshot.").font(.subheadline).foregroundColor(.secondary)
                    }
                    VStack(spacing: 16) {
                        if let img = pickedImage {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 250)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                        } else {
                            VStack(spacing: 12) {
                                Image(systemName: "viewfinder.circle.fill")
                                    .font(.system(size: 58))
                                    .foregroundColor(.primaryOrange)
                                Text("What’s on your plate?").font(.headline)
                                Text("Choose a clear photo for a quick estimate.").font(.caption).foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 250)
                            .background(Color.primaryOrange.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                        }
                        Button(action: { showingPicker = true }) {
                            Label(pickedImage == nil ? "Choose food photo" : "Replace photo", systemImage: "camera.fill")
                                .font(.headline).frame(maxWidth: .infinity).padding(.vertical, 4)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.primaryOrange)
                    }
                    .padding(16)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    if let a = analysis {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Label("Nutrition estimate", systemImage: "sparkles").font(.headline)
                                Spacer()
                                Text("READY").font(.caption2.weight(.bold)).foregroundColor(.green)
                            }
                            RegistrationInputField(title: "Meal name", placeholder: "Name this meal", icon: "fork.knife", text: $name)
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                ScanNutritionTile(title: "Calories", value: "\(a.calories)", unit: "kcal", color: .primaryOrange)
                                ScanNutritionTile(title: "Protein", value: "\(a.protein)", unit: "g", color: .accentBlue)
                                ScanNutritionTile(title: "Carbs", value: "\(a.carbs)", unit: "g", color: .green)
                                ScanNutritionTile(title: "Fats", value: "\(a.fats)", unit: "g", color: .purple)
                            }
                            Button(action: {
                                let entry = FoodEntry(name: name, calories: a.calories, carbsGrams: a.carbs, proteinGrams: a.protein, fatsGrams: a.fats)
                                store.addEntry(entry)
                                pickedImage = nil
                                analysis = nil
                            }) {
                                Label("Add to today", systemImage: "plus.circle.fill")
                                    .font(.headline).frame(maxWidth: .infinity).padding(.vertical, 4)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.accentBlue)
                        }
                        .padding(20)
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
                .padding(20)
            }
        }
        .sheet(isPresented: $showingPicker) {
            ImagePicker(image: $pickedImage)
                .onChange(of: pickedImage) { new in
                    if let img = new {
                        analysis = MacroCalculator.analyzeImage(img)
                    }
                }
        }
    }
}

struct ScanNutritionTile: View {
    let title: String
    let value: String
    let unit: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.caption).foregroundColor(.secondary)
            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(value).font(.title3.weight(.bold)).foregroundColor(color)
                Text(unit).font(.caption.weight(.semibold)).foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

struct TrackerView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        let totals = dailyTotals(entries: store.entries)
        let todayEntries = entriesForToday(store.entries)
        let targets = store.profile.map { MacroCalculator.targets(for: $0) }

        ZStack {
            LinearGradient(colors: [Color(red: 0.93, green: 0.98, blue: 1.0), Color.white], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Nutrition tracker")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                        Text(Date(), style: .date)
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("TODAY'S PROGRESS")
                                    .font(.caption2.weight(.bold))
                                    .foregroundColor(.white.opacity(0.75))
                                Text("\(totals.calories) kcal")
                                    .font(.system(size: 30, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            Image(systemName: "chart.bar.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        if let targets {
                            TrackerProgressBar(value: totals.calories, target: targets.calories, color: .white)
                            Text("\(max(0, targets.calories - totals.calories)) kcal remaining of \(targets.calories) kcal")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        } else {
                            Text("Start logging meals to see your progress.")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding(20)
                    .background(LinearGradient(colors: [.accentBlue, Color(red: 0.04, green: 0.42, blue: 0.72)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .shadow(color: Color.accentBlue.opacity(0.25), radius: 14, y: 8)

                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("Macro balance").font(.headline)
                            Spacer()
                            Text("TODAY").font(.caption2.weight(.bold)).foregroundColor(.secondary)
                        }
                        if let targets {
                            TrackerMacroRow(title: "Protein", value: totals.protein, target: targets.proteinGrams, color: .accentBlue)
                            TrackerMacroRow(title: "Carbs", value: totals.carbs, target: targets.carbsGrams, color: .green)
                            TrackerMacroRow(title: "Fat", value: totals.fats, target: targets.fatsGrams, color: .purple)
                        }
                    }
                    .padding(20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    HStack {
                        Label("Meal timeline", systemImage: "clock.fill").font(.headline)
                        Spacer()
                        Text("\(todayEntries.count) logged").font(.caption).foregroundColor(.secondary)
                    }

                    if todayEntries.isEmpty {
                        VStack(spacing: 10) {
                            Image(systemName: "fork.knife.circle.fill")
                                .font(.system(size: 42))
                                .foregroundColor(.primaryOrange)
                            Text("Your day starts here").font(.headline)
                            Text("Scan a meal to build your nutrition timeline.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 28)
                        .background(Color.primaryOrange.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    } else {
                        VStack(spacing: 0) {
                            ForEach(todayEntries) { entry in
                                TrackerMealRow(entry: entry)
                                if entry.id != todayEntries.last?.id {
                                    Divider().padding(.leading, 52)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .background(Color.white.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                }
                .padding(20)
            }
        }
    }

    private func entriesForToday(_ entries: [FoodEntry]) -> [FoodEntry] {
        let today = Calendar.current.startOfDay(for: Date())
        return entries.filter { Calendar.current.startOfDay(for: $0.date) == today }.sorted { $0.date > $1.date }
    }

    func dailyTotals(entries: [FoodEntry]) -> (calories:Int, protein:Int, carbs:Int, fats:Int) {
        let today = Calendar.current.startOfDay(for: Date())
        let s = entries.filter { Calendar.current.startOfDay(for: $0.date) == today }
        return (s.reduce(0) { $0 + $1.calories }, s.reduce(0) { $0 + $1.proteinGrams }, s.reduce(0) { $0 + $1.carbsGrams }, s.reduce(0) { $0 + $1.fatsGrams })
    }
}

struct TrackerProgressBar: View {
    let value: Int
    let target: Int
    let color: Color

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule().fill(color.opacity(0.25))
                Capsule().fill(color).frame(width: geometry.size.width * min(1, CGFloat(value) / CGFloat(max(target, 1))))
            }
        }
        .frame(height: 8)
    }
}

struct TrackerMacroRow: View {
    let title: String
    let value: Int
    let target: Int
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Text(title).font(.subheadline.weight(.medium))
                Spacer()
                Text("\(value) / \(target) g").font(.caption.weight(.semibold)).foregroundColor(.secondary)
            }
            TrackerProgressBar(value: value, target: target, color: color)
        }
    }
}

struct TrackerMealRow: View {
    let entry: FoodEntry

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "fork.knife")
                .foregroundColor(.primaryOrange)
                .frame(width: 36, height: 36)
                .background(Color.primaryOrange.opacity(0.12))
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 3) {
                Text(entry.name).font(.subheadline.weight(.semibold))
                Text(entry.date, style: .time).font(.caption).foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 3) {
                Text("\(entry.calories) kcal").font(.subheadline.weight(.bold))
                Text("P \(entry.proteinGrams) • C \(entry.carbsGrams) • F \(entry.fatsGrams)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 14)
    }
}

struct WaterView: View {
    var body: some View {
        VStack { Text("Water Tracking - coming soon").foregroundColor(.secondary); Spacer() }
            .padding()
    }
}

struct ProfileView: View {
    @EnvironmentObject var store: AppStore
    @State private var name = ""
    @State private var email = ""
    @State private var gender = ""
    @State private var age = 30
    @State private var weight = 70
    @State private var height = 170
    @State private var calorieTarget = ""
    @State private var proteinTarget = ""
    @State private var fatTarget = ""
    @State private var customTargets = false
    @State private var savedMessage = false
    @State private var isEditing = false
    @State private var targetWarning = ""

    private let genders = ["Female", "Male", "Non-binary", "Prefer not to say"]

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 1.0, green: 0.96, blue: 0.91), Color.white], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if let p = store.profile {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Your profile")
                                        .font(.subheadline.weight(.medium))
                                        .foregroundColor(.secondary)
                                    Text(name.isEmpty ? "Your details" : name)
                                        .font(.system(size: 32, weight: .bold, design: .rounded))
                                }
                                Spacer()
                                Circle()
                                    .fill(LinearGradient(colors: [.primaryOrange, .accentBlue], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 62, height: 62)
                                    .overlay(Text(String((name.isEmpty ? p.email : name).prefix(1)).uppercased()).font(.title2.weight(.bold)).foregroundColor(.white))
                            }
                            Text("Keep your information and nutrition plan up to date.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .onAppear { loadProfile(p) }

                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Label("Personal details", systemImage: "person.text.rectangle.fill")
                                    .font(.headline)
                                Spacer()
                                Button(action: {
                                    withAnimation(.easeInOut) {
                                        isEditing.toggle()
                                        savedMessage = false
                                        targetWarning = ""
                                    }
                                }) {
                                    Image(systemName: isEditing ? "xmark" : "pencil")
                                        .font(.headline.weight(.semibold))
                                        .foregroundColor(.accentBlue)
                                        .frame(width: 40, height: 40)
                                        .background(Color.accentBlue.opacity(0.12))
                                        .clipShape(Circle())
                                }
                                .accessibilityLabel(isEditing ? "Cancel editing" : "Edit profile")
                            }
                            RegistrationInputField(title: "Name", placeholder: "Your name", icon: "person.fill", text: $name, isEditable: isEditing)
                            RegistrationInputField(title: "Email", placeholder: "Email address", icon: "envelope.fill", text: $email, isEmail: true, isEditable: isEditing)
                            ProfileGenderField(gender: $gender, isEditable: isEditing)
                            ProfilePickerField(title: "Age", unit: "years", icon: "calendar", value: $age, range: 13...100, isEditable: isEditing)
                            ProfilePickerField(title: "Weight", unit: "kg", icon: "scalemass.fill", value: $weight, range: 30...250, isEditable: isEditing)
                            ProfilePickerField(title: "Height", unit: "cm", icon: "ruler.fill", value: $height, range: 100...230, isEditable: isEditing)
                        }
                        .padding(20)
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))

                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Label("Nutrition targets", systemImage: "chart.bar.fill")
                                    .font(.headline)
                                Spacer()
                                Toggle("Custom", isOn: $customTargets)
                                    .labelsHidden()
                                    .tint(.accentBlue)
                                    .disabled(!isEditing)
                            }
                            Text(customTargets ? "Set targets that work best for your plan." : "Targets are calculated from your profile and goal.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            if customTargets {
                                OnboardingMetricField(title: "Calories", value: $calorieTarget, unit: "kcal", icon: "flame.fill", isDecimal: false, isEditable: isEditing)
                                OnboardingMetricField(title: "Protein", value: $proteinTarget, unit: "g", icon: "bolt.fill", isDecimal: false, isEditable: isEditing)
                                OnboardingMetricField(title: "Fat", value: $fatTarget, unit: "g", icon: "drop.fill", isDecimal: false, isEditable: isEditing)
                                if !targetWarning.isEmpty {
                                    Label(targetWarning, systemImage: "exclamationmark.triangle.fill")
                                        .font(.caption.weight(.medium))
                                        .foregroundColor(.orange)
                                        .padding(12)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.orange.opacity(0.12))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            } else {
                                let targets = MacroCalculator.targets(for: p)
                                HStack(spacing: 10) {
                                    ProfileTargetBadge(value: "\(targets.calories)", label: "kcal", color: .primaryOrange)
                                    ProfileTargetBadge(value: "\(targets.proteinGrams)g", label: "protein", color: .accentBlue)
                                    ProfileTargetBadge(value: "\(targets.fatsGrams)g", label: "fat", color: .purple)
                                }
                            }
                        }
                        .padding(20)
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))

                        Button(action: {
                            saveProfile()
                            withAnimation { isEditing = false }
                        }) {
                            Label(savedMessage ? "Changes saved" : "Save changes", systemImage: savedMessage ? "checkmark.circle.fill" : "square.and.arrow.down.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 4)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.accentBlue)
                        .disabled(!isEditing)
                        .opacity(isEditing ? 1 : 0.55)

                        Button("Log out") { store.logout() }
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(20)
            }
        }
    }

    private func loadProfile(_ profile: UserProfile) {
        guard name.isEmpty else { return }
        name = profile.name
        email = profile.email
        gender = profile.gender ?? ""
        age = profile.age ?? 30
        weight = Int(profile.weightKg ?? 70)
        height = Int(profile.heightCm ?? 170)
        customTargets = profile.calorieTarget != nil || profile.proteinTarget != nil || profile.fatTarget != nil
        let targets = MacroCalculator.targets(for: profile)
        calorieTarget = String(targets.calories)
        proteinTarget = String(targets.proteinGrams)
        fatTarget = String(targets.fatsGrams)
    }

    private func saveProfile() {
        guard var profile = store.profile else { return }
        profile.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        profile.email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        profile.gender = gender.isEmpty ? nil : gender
        profile.age = age
        profile.weightKg = Double(weight)
        profile.heightCm = Double(height)
        if customTargets {
            var suggestedProfile = profile
            suggestedProfile.calorieTarget = nil
            suggestedProfile.proteinTarget = nil
            suggestedProfile.fatTarget = nil
            let suggested = MacroCalculator.targets(for: suggestedProfile)
            let calories = Int(calorieTarget) ?? suggested.calories
            let protein = Int(proteinTarget) ?? suggested.proteinGrams
            let fats = Int(fatTarget) ?? suggested.fatsGrams
            if calories < suggested.calories || protein < suggested.proteinGrams || fats < suggested.fatsGrams {
                targetWarning = "Your targets cannot be lower than the suggested minimums: \(suggested.calories) kcal, \(suggested.proteinGrams) g protein, and \(suggested.fatsGrams) g fat."
                return
            }
            profile.calorieTarget = calories
            profile.proteinTarget = protein
            profile.fatTarget = fats
        } else {
            profile.calorieTarget = nil
            profile.proteinTarget = nil
            profile.fatTarget = nil
        }
        store.saveProfile(profile)
        withAnimation { savedMessage = true }
    }
}

struct ProfileGenderField: View {
    @Binding var gender: String
    let isEditable: Bool
    private let genders = ["Female", "Male", "Non-binary", "Prefer not to say"]

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.2.fill").foregroundColor(.primaryOrange).frame(width: 24)
            Picker("Gender", selection: $gender) {
                Text("Select gender").tag("")
                ForEach(genders, id: \.self) { option in Text(option).tag(option) }
            }
            .pickerStyle(.menu)
            .tint(gender.isEmpty ? .secondary : .primary)
            .disabled(!isEditable)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .frame(minHeight: 58)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.primaryOrange.opacity(0.15), lineWidth: 1.5))
    }
}

struct ProfilePickerField: View {
    let title: String
    let unit: String
    let icon: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let isEditable: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon).foregroundColor(.accentBlue).frame(width: 24)
            Text(title).font(.subheadline.weight(.medium))
            Spacer()
            Picker(title, selection: $value) {
                ForEach(Array(range), id: \.self) { number in
                    Text("\(number)").tag(number)
                }
            }
            .pickerStyle(.menu)
            .tint(.primary)
            .disabled(!isEditable)
            Text(unit).font(.caption.weight(.semibold)).foregroundColor(.secondary).frame(width: 42, alignment: .leading)
        }
        .padding(.horizontal, 14)
        .frame(minHeight: 58)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.accentBlue.opacity(isEditable ? 0.45 : 0.12), lineWidth: 1.5))
        .opacity(isEditable ? 1 : 0.72)
    }
}

struct ProfileTargetBadge: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 5) {
            Text(value).font(.headline.weight(.bold)).foregroundColor(color)
            Text(label).font(.caption2).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
