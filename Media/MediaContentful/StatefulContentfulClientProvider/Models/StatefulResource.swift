
import Contentful

/// A resource which has it's state.
public protocol StatefulResource: AnyObject {
    var state: ResourceState { get set }
}
