
import Contentful

public extension StatefulContentfulClientProvider {
    
    /// A struct that represents the state of the Contentful service at any given time.
    /// One nice property of this type is that since it's a struct, a change to any member variable
    /// is a change to the entity itself. We can use this type in conjunction with a the `StateMachine` type
    /// to observe state changes in all the UI of the application.
    struct State {
        
        /// The currently selected API that the app is pulling data from.
        public var api: API
        
        /// The currently selected locale that the app is using to localize content.
        public var locale: Contentful.Locale
        
        /// If pulling data from the CPA and this switch is on, resource state pills will be shown in the user interface.
        public var editorialFeaturesEnabled: Bool
        
        /// An enumeration of all the possible API's this ContentfulService can interface with.
        ///
        /// - delivery: A enum representation of the Content Delivery API.
        /// - preview: A enum representation of the Content Preview API.
        public enum API: String, Equatable {
            case delivery
            case preview
            
            public func title() -> String {
                switch self {
                case .delivery:
                    return "API: Delivery"
                case .preview:
                    return "API: Preview"
                }
            }
        }
    }
    
}



public func ==(
    lhs: StatefulContentfulClientProvider.State.API,
    rhs: StatefulContentfulClientProvider.State.API
) -> Bool {
    switch (lhs, rhs) {
    case (.delivery, .delivery):
        return true
    case (.preview, .preview):
        return true
    default:
        return false
    }
}
