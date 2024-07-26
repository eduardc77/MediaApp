
public extension CodingUserInfoKey {
    /// Custom key used by the `context` dictionary of `NodeRenderer` methods to store `RenderingConfiguration`.
    static let rendererConfiguration = CodingUserInfoKey(rawValue: "rendererConfigurationKey")!

    /// Custom key used by the `context` dictionary of `NodeRenderer` methods to store `ListContext`.
    static let listContext = CodingUserInfoKey(rawValue: "listItemContextKey")!
}

extension Dictionary where Key == CodingUserInfoKey {
    var rendererConfiguration: RendererConfiguration {
        return self[.rendererConfiguration] as! RendererConfiguration
    }
}
