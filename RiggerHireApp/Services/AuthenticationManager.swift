import Foundation
import Combine
import LocalAuthentication

@MainActor
class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var requiresTwoFactorAuth = false
    @Published var authToken: String?
    
    private let keychain = KeychainService()
    private let apiService = APIService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadStoredAuthState()
    }
    
    // MARK: - Authentication Methods
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let request = LoginRequest(email: email, password: password)
            let response = try await apiService.post("/auth/login", body: request, responseType: LoginResponse.self)
            
            if response.requiresTwoFactorAuth {
                requiresTwoFactorAuth = true
            } else {
                await handleSuccessfulLogin(response: response)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func verifyTwoFactorCode(_ code: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let request = TwoFactorRequest(code: code)
            let response = try await apiService.post("/auth/verify-2fa", body: request, responseType: LoginResponse.self)
            await handleSuccessfulLogin(response: response)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func signUp(firstName: String, lastName: String, email: String, password: String, userType: UserType) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let request = SignUpRequest(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password,
                userType: userType
            )
            let response = try await apiService.post("/auth/signup", body: request, responseType: LoginResponse.self)
            await handleSuccessfulLogin(response: response)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func signInWithBiometrics() async {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            errorMessage = "Biometric authentication not available"
            return
        }
        
        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Sign in to RiggerHire App"
            )
            
            if success, let storedToken = keychain.get("auth_token") {
                authToken = storedToken
                await loadUserProfile()
            }
        } catch {
            errorMessage = "Biometric authentication failed"
        }
    }
    
    func refreshToken() async {
        guard let currentToken = authToken else { return }
        
        do {
            let request = RefreshTokenRequest(token: currentToken)
            let response = try await apiService.post("/auth/refresh", body: request, responseType: TokenResponse.self)
            
            authToken = response.accessToken
            keychain.set(response.accessToken, for: "auth_token")
            
            if let refreshToken = response.refreshToken {
                keychain.set(refreshToken, for: "refresh_token")
            }
        } catch {
            // If refresh fails, sign out user
            signOut()
        }
    }
    
    func signOut() {
        isAuthenticated = false
        currentUser = nil
        authToken = nil
        requiresTwoFactorAuth = false
        errorMessage = nil
        
        // Clear stored credentials
        keychain.delete("auth_token")
        keychain.delete("refresh_token")
        keychain.delete("user_data")
    }
    
    func deleteAccount() async {
        guard let user = currentUser else { return }
        
        isLoading = true
        
        do {
            try await apiService.delete("/auth/account/\(user.id)")
            signOut()
        } catch {
            errorMessage = "Failed to delete account: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func forgotPassword(email: String) async -> Bool {
        do {
            let request = ForgotPasswordRequest(email: email)
            try await apiService.post("/auth/forgot-password", body: request, responseType: EmptyResponse.self)
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func resetPassword(token: String, newPassword: String) async -> Bool {
        do {
            let request = ResetPasswordRequest(token: token, newPassword: newPassword)
            try await apiService.post("/auth/reset-password", body: request, responseType: EmptyResponse.self)
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    // MARK: - Profile Management
    
    func updateProfile(_ user: User) async {
        guard let currentUser = currentUser else { return }
        
        isLoading = true
        
        do {
            let updatedUser = try await apiService.put("/users/\(currentUser.id)", body: user, responseType: User.self)
            self.currentUser = updatedUser
            
            // Store updated user data
            if let userData = try? JSONEncoder().encode(updatedUser) {
                keychain.set(String(data: userData, encoding: .utf8) ?? "", for: "user_data")
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func uploadProfileImage(_ imageData: Data) async -> String? {
        guard let user = currentUser else { return nil }
        
        do {
            let response = try await apiService.uploadImage(
                "/users/\(user.id)/profile-image",
                imageData: imageData,
                responseType: ImageUploadResponse.self
            )
            
            // Update user profile with new image URL
            var updatedUser = user
            updatedUser.profileImageURL = response.imageURL
            await updateProfile(updatedUser)
            
            return response.imageURL
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }
    
    // MARK: - Private Methods
    
    private func handleSuccessfulLogin(response: LoginResponse) async {
        authToken = response.accessToken
        currentUser = response.user
        isAuthenticated = true
        requiresTwoFactorAuth = false
        
        // Store credentials securely
        keychain.set(response.accessToken, for: "auth_token")
        
        if let refreshToken = response.refreshToken {
            keychain.set(refreshToken, for: "refresh_token")
        }
        
        if let userData = try? JSONEncoder().encode(response.user) {
            keychain.set(String(data: userData, encoding: .utf8) ?? "", for: "user_data")
        }
        
        // Schedule token refresh
        scheduleTokenRefresh()
    }
    
    private func loadStoredAuthState() {
        guard let storedToken = keychain.get("auth_token"),
              let userData = keychain.get("user_data"),
              let userDataEncoded = userData.data(using: .utf8),
              let user = try? JSONDecoder().decode(User.self, from: userDataEncoded) else {
            return
        }
        
        authToken = storedToken
        currentUser = user
        isAuthenticated = true
        
        // Verify token is still valid
        Task {
            await loadUserProfile()
        }
    }
    
    private func loadUserProfile() async {
        guard let token = authToken else {
            signOut()
            return
        }
        
        do {
            let user = try await apiService.get("/auth/profile", responseType: User.self)
            currentUser = user
            isAuthenticated = true
        } catch {
            signOut()
        }
    }
    
    private func scheduleTokenRefresh() {
        // Refresh token every 50 minutes (tokens typically expire in 1 hour)
        Timer.scheduledTimer(withTimeInterval: 3000, repeats: true) { _ in
            Task {
                await self.refreshToken()
            }
        }
    }
}

// MARK: - Request/Response Models

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String?
    let user: User
    let requiresTwoFactorAuth: Bool
}

struct SignUpRequest: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let userType: UserType
}

struct TwoFactorRequest: Codable {
    let code: String
}

struct RefreshTokenRequest: Codable {
    let token: String
}

struct TokenResponse: Codable {
    let accessToken: String
    let refreshToken: String?
}

struct ForgotPasswordRequest: Codable {
    let email: String
}

struct ResetPasswordRequest: Codable {
    let token: String
    let newPassword: String
}

struct ImageUploadResponse: Codable {
    let imageURL: String
}

struct EmptyResponse: Codable {}

// MARK: - Keychain Service

class KeychainService {
    func set(_ value: String, for key: String) {
        let data = value.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func get(_ key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return value
    }
    
    func delete(_ key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
