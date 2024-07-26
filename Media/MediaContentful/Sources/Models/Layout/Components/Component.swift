
import Contentful

public class Component: Resource, StatefulResource {
    public let sys: Sys
    public var state = ResourceState.upToDate
    
    public init(sys: Sys) {
        self.sys = sys
    }
}

extension Component: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(sys.id)
    }
    
    public static func == (lhs: Component, rhs: Component) -> Bool {
        return lhs.sys.id == rhs.sys.id
    }
}
