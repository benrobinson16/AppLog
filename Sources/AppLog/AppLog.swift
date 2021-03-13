// Copyright (c) 2021 Benjamin Robinson.
// All Rights Reserved.

import Foundation

public struct AppLog {
    
    // MARK: - Properties
    
    private let filename: String
    
    // MARK: - Init
    
    /// Makes a new instance that writes to the provided `txt` file.
    public init(filename: String = "applog.txt") {
        self.filename = filename
    }
    
    // MARK: - Reporting
    
    /// Makes a new log in the specified file.
    /// - Parameters:
    ///   - contents: The contents of the log.
    ///   - severity: The severity of the reported event. Changes the formatting in the file.
    ///   - file: The file that is sending this log. No need to override.
    ///   - function: The function that is sending this log. No need to override.
    ///   - line: The line that is sending this log. No need to override.
    public func report(_ contents: String, severity: Severity = .normal, file: String = #file, function: String = #function, line: UInt = #line) {
        #if !DEBUG
        guard severity != .debug else { return }
        #endif
        appendToFile(contents: severity.parse(contents, file: file, function: function, line: line))
    }
    
    /// Makes a new log in the specified file.
    /// - Parameters:
    ///   - contents: The contents of the log.
    ///   - severity: The severity of the reported event. Changes the formatting in the file.
    ///   - file: The file that is sending this log. No need to override.
    ///   - function: The function that is sending this log. No need to override.
    ///   - line: The line that is sending this log. No need to override.
    public func report(_ contents: String..., severity: Severity = .normal, file: String = #file, function: String = #function, line: UInt = #line) {
        #if !DEBUG
        guard severity != .debug else { return }
        #endif
        let total = contents.joined()
        appendToFile(contents: severity.parse(total, file: file, function: function, line: line))
    }
    
    /// Makes a new log in the specified file.
    /// - Parameters:
    ///   - contents: The contents of the log.
    ///   - severity: The severity of the reported event. Changes the formatting in the file.
    ///   - file: The file that is sending this log. No need to override.
    ///   - function: The function that is sending this log. No need to override.
    ///   - line: The line that is sending this log. No need to override.
    public func report(_ contents: Error, severity: Severity = .normal, file: String = #file, function: String = #function, line: UInt = #line) {
        #if !DEBUG
        guard severity != .debug else { return }
        #endif
        let formatted = contents.localizedDescription
        appendToFile(contents: severity.parse(formatted, file: file, function: function, line: line))
    }
    
    /// Makes a new log in the specified file.
    /// - Parameters:
    ///   - contents: The contents of the log.
    ///   - severity: The severity of the reported event. Changes the formatting in the file.
    ///   - file: The file that is sending this log. No need to override.
    ///   - function: The function that is sending this log. No need to override.
    ///   - line: The line that is sending this log. No need to override.
    public func report(_ contents: Error..., severity: Severity = .normal, file: String = #file, function: String = #function, line: UInt = #line) {
        #if !DEBUG
        guard severity != .debug else { return }
        #endif
        let total = contents.map { $0.localizedDescription }.joined()
        appendToFile(contents: severity.parse(total, file: file, function: function, line: line))
    }
    
    // MARK: - Private
    
    private var fileurl: URL {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsUrl.appendingPathComponent(filename)
    }
    
    private func appendToFile(contents: String) {
        let url = fileurl
        do {
            if FileManager.default.fileExists(atPath: url.path) {
                let fileHandle = try FileHandle(forWritingTo: url)
                fileHandle.seekToEndOfFile()
                fileHandle.write(("\n" + contents).data(using: .utf8) ?? ("ERROR CONVERTING TO DATA".data(using: .utf8)!))
                fileHandle.closeFile()
            } else {
                try contents.write(to: url, atomically: true, encoding: .utf8)
            }
        } catch {
            // Error
        }
    }
    
    // MARK: - Severity
    
    /// Denotes the severity of a log and provides formatting for the log message.
    public enum Severity {
        
        /// The most serious severity. Use to denote major failures and/or fatal errors.
        ///
        /// Provides data in the following format:
        /// ```
        /// --- CRITICAL ---
        ///
        /// <contents>
        ///
        /// DATE: <date>
        ///
        /// SENDER-FILE: <sender-file>
        /// SENDER-FUNCTION: <sender-function>
        /// SENDER-LINE: <sender-line>
        ///
        /// IMMEDIATE ACTION REQUIRED
        ///
        /// -- END CRITICAL ---
        /// ```
        case critical
        
        /// Use for standard error reporting.
        ///
        /// Provides data in the following format:
        /// ```
        /// ERROR:
        ///     <contents>
        ///     DATE: <date>
        ///     SENDER: <sender-file>, <sender-function>, <sender-line>
        /// ```
        case error
        
        /// The default severity level of logs.
        ///
        /// Provides data in the following format:
        /// ```
        /// <date>, <sender-file>, <sender-function>, <sender-line> --- <contents>
        /// ```
        case normal
        
        /// Used for debug builds (excluded from errors file in production). Uses the same format as `.normal`.
        case debug
        
        func parse(_ contents: String, file: String, function: String, line: UInt) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            let dateString = formatter.string(from: Date())
            let shortFile = file.components(separatedBy: "/").last ?? "error"
            
            switch self {
            case .critical:
                return "\n\n--- CRITICAL ---\n\n\(contents)\n\nDATE: \(dateString)\n\nSENDER-FILE: \(shortFile)\nSENDER-FUNCTION: \(function)\nSENDER-LINE: \(line)\n\nIMMEDIATE ACTION REQUIRED\n\n--- END CRITICAL ---\n"
            case .error:
                return "ERROR:\n\t\(contents)\n\tDATE: \(dateString)\n\tSENDER: \(shortFile), \(function), \(line)"
            case .normal, .debug:
                return "\(dateString), \(shortFile), \(function), \(line) --- \(contents)"
            }
        }
    }
}
