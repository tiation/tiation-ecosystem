import SwiftUI
import MapKit

struct JobDetailView: View {
    let job: Job
    @EnvironmentObject var jobManager: JobManager
    @Environment(\.dismiss) var dismiss
    @State private var isApplying = false
    @State private var showingFullDescription = false
    
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
                    VStack(spacing: 20) {
                        // Header Section
                        headerSection
                        
                        // Quick Stats
                        quickStatsSection
                        
                        // Job Description
                        descriptionSection
                        
                        // Location and Map
                        locationSection
                        
                        // Requirements
                        requirementsSection
                        
                        // Equipment and Safety
                        equipmentSafetySection
                        
                        // Schedule and Duration
                        scheduleSection
                        
                        // Payment Information
                        paymentSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.cyan)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Share job
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.cyan)
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                if job.status == .posted {
                    applyButton
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                // Job type icon and badge
                HStack {
                    Image(systemName: job.jobType.icon)
                        .foregroundColor(.cyan)
                        .font(.title2)
                    
                    Text(job.jobType.displayName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.cyan)
                }
                
                Spacer()
                
                // Urgency badge
                if job.isUrgent {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.caption)
                        Text(job.urgencyLevel.displayName)
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.orange)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            
            // Job title
            Text(job.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            // Rate and status
            HStack {
                Text(job.formattedRate)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
                Spacer()
                
                StatusBadge(status: job.status)
            }
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
    
    private var quickStatsSection: some View {
        HStack(spacing: 15) {
            QuickStatItem(
                icon: "star.fill",
                title: job.experienceLevel.displayName,
                color: .yellow
            )
            
            QuickStatItem(
                icon: "clock.fill",
                title: job.shiftPattern.displayName,
                color: .blue
            )
            
            if let distance = job.distanceFromCurrentLocation {
                QuickStatItem(
                    icon: "location.fill",
                    title: String(format: "%.1f km", distance),
                    color: .purple
                )
            }
        }
    }
    
    private var descriptionSection: some View {
        DetailSection(title: "Job Description", icon: "text.alignleft") {
            VStack(alignment: .leading, spacing: 12) {
                Text(job.description)
                    .font(.body)
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
                
                if job.weatherDependency {
                    HStack {
                        Image(systemName: "cloud.rain.fill")
                            .foregroundColor(.blue)
                        Text("Weather dependent work")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
                }
                
                if job.heightWork {
                    HStack {
                        Image(systemName: "arrow.up.to.line.alt")
                            .foregroundColor(.orange)
                        Text("Height work involved")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(6)
                }
            }
        }
    }
    
    private var locationSection: some View {
        DetailSection(title: "Location", icon: "location.circle.fill") {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: job.location.siteType.icon)
                        .foregroundColor(.cyan)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(job.location.siteType.displayName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.cyan)
                        
                        Text(job.location.address)
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Text("\(job.location.city), \(job.location.state) \(job.location.postcode)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                
                // Mini map
                if let coordinate = job.location.coordinate {
                    Map(coordinateRegion: .constant(MKCoordinateRegion(
                        center: coordinate.clLocation,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )), annotationItems: [job]) { job in
                        MapPin(coordinate: job.location.coordinate!.clLocation, tint: .cyan)
                    }
                    .frame(height: 150)
                    .cornerRadius(8)
                    .allowsHitTesting(false)
                }
            }
        }
    }
    
    private var requirementsSection: some View {
        DetailSection(title: "Requirements", icon: "checkmark.circle.fill") {
            VStack(alignment: .leading, spacing: 12) {
                // Experience level
                RequirementItem(
                    title: "Experience Level",
                    value: job.experienceLevel.displayName,
                    met: true // Assume met for now
                )
                
                // Certifications
                VStack(alignment: .leading, spacing: 8) {
                    Text("Required Certifications")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    
                    ForEach(job.requiredCertifications, id: \.self) { cert in
                        RequirementItem(
                            title: cert,
                            value: "Required",
                            met: true // Check against user profile
                        )
                    }
                }
                
                // Insurance
                RequirementItem(
                    title: "Insurance Coverage",
                    value: String(format: "$%.0f", job.insuranceRequired),
                    met: true
                )
            }
        }
    }
    
    private var equipmentSafetySection: some View {
        Group {
            if !job.equipmentRequired.isEmpty {
                DetailSection(title: "Equipment Required", icon: "wrench.and.screwdriver.fill") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(job.equipmentRequired, id: \.self) { equipment in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.caption)
                                
                                Text(equipment)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(6)
                        }
                    }
                }
            }
            
            if !job.safetyRequirements.isEmpty {
                DetailSection(title: "Safety Requirements", icon: "shield.fill") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 8) {
                        ForEach(job.safetyRequirements, id: \.self) { safety in
                            HStack {
                                Image(systemName: "shield.checkered")
                                    .foregroundColor(.orange)
                                    .font(.caption)
                                
                                Text(safety)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(6)
                        }
                    }
                }
            }
        }
    }
    
    private var scheduleSection: some View {
        DetailSection(title: "Schedule & Duration", icon: "calendar.circle.fill") {
            VStack(spacing: 12) {
                ScheduleItem(
                    title: "Start Date",
                    value: DateFormatter.detailed.string(from: job.startDate),
                    icon: "calendar.badge.plus"
                )
                
                if let endDate = job.endDate {
                    ScheduleItem(
                        title: "End Date",
                        value: DateFormatter.detailed.string(from: endDate),
                        icon: "calendar.badge.minus"
                    )
                }
                
                ScheduleItem(
                    title: "Duration",
                    value: job.duration.displayName,
                    icon: "clock"
                )
                
                ScheduleItem(
                    title: "Shift Pattern",
                    value: job.shiftPattern.displayName,
                    icon: "moon.fill"
                )
            }
        }
    }
    
    private var paymentSection: some View {
        DetailSection(title: "Payment Information", icon: "dollarsign.circle.fill") {
            VStack(spacing: 12) {
                PaymentItem(
                    title: "Hourly Rate",
                    value: job.formattedRate,
                    highlighted: true
                )
                
                PaymentItem(
                    title: "Currency",
                    value: job.currency
                )
                
                PaymentItem(
                    title: "Payment Schedule",
                    value: "Weekly via Stripe"
                )
                
                PaymentItem(
                    title: "Insurance Required",
                    value: String(format: "$%.0f coverage", job.insuranceRequired)
                )
            }
        }
    }
    
    private var applyButton: some View {
        VStack(spacing: 12) {
            Button {
                isApplying = true
                Task {
                    let success = await jobManager.applyForJob(job)
                    isApplying = false
                    if success {
                        dismiss()
                    }
                }
            } label: {
                HStack {
                    if isApplying {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "paperplane.fill")
                        Text("Apply for Job")
                            .fontWeight(.semibold)
                    }
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
            .disabled(isApplying)
            .shadow(color: .cyan.opacity(0.3), radius: 5)
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Color.black.opacity(0.9))
    }
}

// MARK: - Supporting Views

struct DetailSection<Content: View>: View {
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

struct QuickStatItem: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct StatusBadge: View {
    let status: JobStatus
    
    var body: some View {
        Text(status.displayName)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color(status.color).opacity(0.8))
            .cornerRadius(8)
    }
}

struct RequirementItem: View {
    let title: String
    let value: String
    let met: Bool
    
    var body: some View {
        HStack {
            Image(systemName: met ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(met ? .green : .red)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white)
                
                Text(value)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}

struct ScheduleItem: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.caption)
                .frame(width: 20)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
    }
}

struct PaymentItem: View {
    let title: String
    let value: String
    var highlighted: Bool = false
    
    var body: some View {
        HStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(highlighted ? .subheadline : .caption)
                .fontWeight(highlighted ? .bold : .medium)
                .foregroundColor(highlighted ? .green : .white)
        }
    }
}

// MARK: - Date Formatter Extension

extension DateFormatter {
    static let detailed: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter
    }()
}

#Preview {
    JobDetailView(job: Job(
        title: "Mobile Crane Operator - Mining Site",
        description: "Experienced mobile crane operator required for mining equipment installation and maintenance work.",
        location: Location(
            address: "Mine Site Alpha",
            city: "Karratha",
            state: "WA",
            postcode: "6714",
            country: "Australia",
            siteType: .miningsite,
            coordinate: Coordinate(latitude: -20.7364, longitude: 116.8467)
        ),
        rate: 95.50,
        jobType: .mobileCraneOperator,
        duration: .daily,
        startDate: Date().addingTimeInterval(86400),
        clientId: UUID()
    ))
    .environmentObject(JobManager())
    .preferredColorScheme(.dark)
}
