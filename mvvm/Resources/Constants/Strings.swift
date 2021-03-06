// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Alerts {
    internal enum Error {
      /// Ok
      internal static let cancelActionTitle = L10n.tr("Localizable", "Alerts.Error.cancelActionTitle")
      /// Error!
      internal static let title = L10n.tr("Localizable", "Alerts.Error.title")
    }
  }

  internal enum PostDetail {
    /// Number of comments: %d
    internal static func numberOfComments(_ p1: Int) -> String {
      return L10n.tr("Localizable", "PostDetail.numberOfComments", p1)
    }
  }

  internal enum PostList {
    /// Sorry, there is no data
    internal static let noDataMessage = L10n.tr("Localizable", "PostList.noDataMessage")
    /// Posts
    internal static let title = L10n.tr("Localizable", "PostList.title")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
