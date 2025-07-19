import SwiftUI

struct JobFiltersView: View {
    @EnvironmentObject var jobManager: JobManager
    @Environment(\.dismiss) var dismiss
    
    @State private var filters = JobFilters()
    @State private var minRateText = ""
    @State private var maxRateText = ""
    @State private var maxDistanceText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.black, Color(red: 0.1, green: 0.1, blue: 0.2)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Job Types
                        FilterSection(title: "Job Types", icon: "hammer.circle.fill") {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(JobType.allCases, id: \.self) { jobType in
                                    FilterChip(
                                        title: jobType.displayName,
                                        icon: jobType.icon,
                                        isSelected: filters.jobTypes.contains(jobType)
                                    ) {
                                        toggleJobType(jobType)
                                    }
                                }
                            }
                        }
                        
                        // Experience Levels
                        FilterSection(title: "Experience Level", icon: "star.circle.fill") {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(ExperienceLevel.allCases, id: \.self) { level in
                                    FilterChip(
                                        title: level.displayName,
                                        icon: "star.fill",
                                        isSelected: filters.experienceLevels.contains(level)
                                    ) {
                                        toggleExperienceLevel(level)
                                    }
                                }
                            }
                        }
                        
                        // Site Types
                        FilterSection(title: "Site Types", icon: "location.circle.fill") {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(Location.SiteType.allCases, id: \.self) { siteType in
                                    FilterChip(
                                        title: siteType.displayName,
                                        icon: siteType.icon,
                                        isSelected: filters.siteTypes.contains(siteType)
                                    ) {
                                        toggleSiteType(siteType)
                                    }
                                }
                            }
                        }
                        
                        // Rate Range
                        FilterSection(title: "Hourly Rate (AUD)", icon: "dollarsign.circle.fill") {
                            HStack(spacing: 15) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Minimum")
                                        .font(.subheadline)
                                        .foregroundColor(.cyan)
                                    
                                    TextField("$0", text: $minRateText)
                                        .keyboardType(.decimalPad)
                                        .textFieldStyle(NeonTextFieldStyle())
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Maximum")
                                        .font(.subheadline)
                                        .foregroundColor(.cyan)
                                    
                                    TextField("$200", text: $maxRateText)
                                        .keyboardType(.decimalPad)
                                        .textFieldStyle(NeonTextFieldStyle())
                                }
                            }
                        }
                        
                        // Distance
                        FilterSection(title: "Maximum Distance", icon: "location.circle.fill") {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    TextField("100", text: $maxDistanceText)
                                        .keyboardType(.decimalPad)
                                        .textFieldStyle(NeonTextFieldStyle())
                                        .frame(width: 80)
                                    
                                    Text("km")
                                        .foregroundColor(.gray)
                                    
                                    Spacer()
                                }
                                
                                Text("Only show jobs within this distance from your current location")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        // Special Filters
                        FilterSection(title: "Special Requirements", icon: "checkmark.circle.fill") {
                            VStack(spacing: 15) {
                                FilterToggle(
                                    title: "Urgent Jobs Only",
                                    subtitle: "Jobs requiring immediate attention",
                                    isOn: $filters.urgentOnly
                                )
                                
                                FilterToggle(
                                    title: "FIFO Available",
                                    subtitle: "Fly-in, fly-out positions",
                                    isOn: $filters.fifoOnly
                                )
                                
                                FilterToggle(
                                    title: "Night Shift Available",
                                    subtitle: "Willing to work night shifts",
                                    isOn: $filters.nightShiftAvailable
                                )
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Filter Jobs")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.cyan)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear All") {
                        clearFilters()
                    }
                    .foregroundColor(.red)
                    .disabled(!filters.hasActiveFilters)
                }
            }
            .safeAreaInset(edge: .bottom) {
                bottomActionButtons
            }
        }
        .onAppear {
            loadCurrentFilters()
        }
    }
    
    private var bottomActionButtons: some View {
        VStack(spacing: 12) {
            // Apply Filters Button
            Button {
                applyFilters()
            } label: {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Apply Filters")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [.cyan, .blue],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(color: .cyan.opacity(0.3), radius: 5)
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Color.black.opacity(0.9))
    }
    
    private func toggleJobType(_ jobType: JobType) {
        if filters.jobTypes.contains(jobType) {
            filters.jobTypes.removeAll { $0 == jobType }
        } else {
            filters.jobTypes.append(jobType)
        }
    }
    
    private func toggleExperienceLevel(_ level: ExperienceLevel) {
        if filters.experienceLevels.contains(level) {
            filters.experienceLevels.removeAll { $0 == level }
        } else {
            filters.experienceLevels.append(level)
        }
    }
    
    private func toggleSiteType(_ siteType: Location.SiteType) {
        if filters.siteTypes.contains(siteType) {
            filters.siteTypes.removeAll { $0 == siteType }
        } else {
            filters.siteTypes.append(siteType)
        }
    }
    
    private func loadCurrentFilters() {
        filters = jobManager.jobFilters
        minRateText = filters.minRate > 0 ? String(Int(filters.minRate)) : ""
        maxRateText = filters.maxRate > 0 ? String(Int(filters.maxRate)) : ""
        maxDistanceText = filters.maxDistance > 0 ? String(Int(filters.maxDistance)) : ""
    }
    
    private func applyFilters() {
        // Parse text fields
        filters.minRate = Double(minRateText) ?? 0
        filters.maxRate = Double(maxRateText) ?? 0
        filters.maxDistance = Double(maxDistanceText) ?? 0
        
        jobManager.applyFilters(filters)
        dismiss()
    }
    
    private func clearFilters() {
        filters = JobFilters()
        minRateText = ""
        maxRateText = ""
        maxDistanceText = ""
    }
}

struct FilterSection<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.cyan)
                    .font(.title3)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            content()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.cyan.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct FilterChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.caption)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.cyan.opacity(0.3) : Color.black.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isSelected ? Color.cyan : Color.gray.opacity(0.3), lineWidth: 1)
                    )
            )
            .foregroundColor(isSelected ? .cyan : .gray)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FilterToggle: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .cyan))
        }
        .padding(.vertical, 4)
    }
}

struct NeonTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.black.opacity(0.3))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.cyan.opacity(0.5), lineWidth: 1)
            )
            .foregroundColor(.white)
    }
}

#Preview {
    JobFiltersView()
        .environmentObject(JobManager())
        .preferredColorScheme(.dark)
}
