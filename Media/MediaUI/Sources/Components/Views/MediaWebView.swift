
import SwiftUI
import WebKit

public struct MediaWebView: View {
    let urlString: String
    
    @State private var isLoading = true
    
    public init(urlString: String) {
        self.urlString = urlString
    }
    
    public var body: some View {
        WebView(urlString: urlString, isLoading: $isLoading)
            .overlay {
                if isLoading {
                    ProgressView()
                }
            }
    }
}

struct WebView: UIViewRepresentable {
    let urlString: String
    @Binding var isLoading: Bool
    
    init(urlString: String, isLoading: Binding<Bool>) {
        self.urlString = urlString
        _isLoading = isLoading
    }
    
    func makeUIView(context: Context) -> some UIView {
        if let url = URL(string: urlString) {
            let webView = WKWebView()
            webView.navigationDelegate = context.coordinator
            webView.load(URLRequest(url: url))
            return webView
        } else {
            return WKWebView()
        }
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator {
            isLoading = true
        } didFinish: {
            isLoading = false
        }
    }
    
    final class Coordinator: NSObject, WKNavigationDelegate {
        var didStart: () -> Void
        var didFinish: () -> Void
        
        init(didStart: @escaping () -> Void,
             didFinish: @escaping () -> Void) {
            self.didStart = didStart
            self.didFinish = didFinish
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            didStart()
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            didFinish()
        }
    }
}

struct MediaWebView_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            MediaWebView(urlString: "https://apple.com")
        }
    }
}
