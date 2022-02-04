import Foundation

public typealias KPJson = Dictionary<String, Any>

public struct KinoPubSDK {
    
    public static func registerDevice(clientId: String, clientSecret: String, deviceName: String? = nil, updateHandler: @escaping (AuthenticationStatus) -> ()) {
        Storage.Auth.clientId = clientId
        Storage.Auth.clientSecret = clientSecret
        Storage.Auth.deviceName = deviceName
        requestDeviceCode(updateHandler: updateHandler)
    }
    
    private static func requestDeviceCode(updateHandler: @escaping (AuthenticationStatus) -> ()) {
        let startTime = Date().timeIntervalSince1970
        API.shared.getDeviceCode(clientId: Storage.Auth.clientId, clientSecret: Storage.Auth.clientSecret) { result in
            switch result {
            case .success(let info):
                updateHandler(.code(code: info.userCode, url: info.verificationURL))
                validateAuthentication(code: info.code, expiryTime: startTime + info.expiresIn, interval: info.interval, updateHandler: updateHandler)
            case .failure(let error):
                updateHandler(.failure(error))
            }
        }
    }
    
    private static func validateAuthentication(code: String, expiryTime: TimeInterval, interval: TimeInterval, updateHandler: @escaping (AuthenticationStatus) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            API.shared.getAccessToken(clientId: Storage.Auth.clientId, clientSecret: Storage.Auth.clientSecret, code: code) { result in
                switch result {
                case .success(let info):
                    let session = KPSession(authInfo: info)
                    updateHandler(.session(session))
                    session.updateCurrentDevice(title: self.appTitle, hardware: self.hardware, software: self.software) { _ in }
                case .failure(let error):
                    if case APIError.apiErrorResponse(let responseError) = error, responseError.message == "authorization_pending" {
                        if Date().timeIntervalSince1970 + TimeInterval(5) > expiryTime {
                            requestDeviceCode(updateHandler: updateHandler)
                        }
                        else {
                            validateAuthentication(code: code, expiryTime: expiryTime, interval: interval, updateHandler: updateHandler)
                        }
                    }
                    else {
                        updateHandler(.failure(error))
                    }
                }
            }
        }
    }
    
    private static var hardware: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        if identifier == "i386" || identifier == "x86_64" {
            if let simulatorIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                return "Simulator " + simulatorIdentifier
            }
            else {
                return identifier
            }
        }
        else {
            return identifier
        }
    }
    
    private static var appTitle: String {
        Storage.Auth.deviceName ?? Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "KinoPub Swift SDK"
    }
    
    private static var software: String {
        let platformName = {
#if os(iOS)
            return "iOS"
#elseif os(watchOS)
            return "watchOS"
#elseif os(tvOS)
            return "tvOS"
#elseif os(macOS)
            return "macOS"
#else
            return "unknown"
#endif
        }()
        
        let platformVersion = [
            ProcessInfo.processInfo.operatingSystemVersion.majorVersion,
            ProcessInfo.processInfo.operatingSystemVersion.minorVersion,
            ProcessInfo.processInfo.operatingSystemVersion.patchVersion
        ]
        .map { String($0) }
        .joined(separator: ".")
        
        return platformName + " " + platformVersion
    }

    private init() {}
}

public enum AuthenticationStatus {
    case code(code: String, url: String)
    case session(KPSession)
    case failure(APIError)
}


// MARK: - Async/Await wrappers

@available(tvOS 13.0.0, watchOS 6.0, iOS 13.0.0, macOS 10.15.0, *)
public extension KinoPubSDK {
    
    static func registerDevice(clientId: String, clientSecret: String, deviceName: String? = nil) async throws -> AuthenticationStatus  {
        return try await withCheckedThrowingContinuation({ continuation in
            registerDevice(clientId: clientId, clientSecret: clientSecret, deviceName: deviceName, updateHandler: continuation.resume(returning:))
        })
    }
    
}
