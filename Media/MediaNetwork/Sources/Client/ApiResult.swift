
import Foundation

/**
 This type can be returned by an ``ApiClient`` when a client
 requests data from an external API.
 */
public struct ApiResult {

    public init(
        data: Data,
        response: URLResponse
    ) {
        self.data = data
        self.response = response
    }

    public var data: Data
    public var response: URLResponse
}
