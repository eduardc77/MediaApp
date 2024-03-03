
import SwiftUI
import MediaUI
import Contentful

/**
 View controller that renders `Contentful.RichTextDocument`.
 
 The content of the document is rendered to internal text view.
 */
open class RichTextViewController: UIViewController, NSLayoutManagerDelegate, UITextViewDelegate {
    
    private enum Constant {
        static let embedSuffix = "-embed"
        static let hrSuffix = "-hr"
    }
    
    /// Renderer of the `Contentful.RichTextDocument`.
    private let renderer: RichTextDocumentRenderer
    
    /// The `renderer` renders `Contentful.RichTextDocument` into this view.
    private var textView: UITextView!
    
    /// The underlying text storage.
    private let textStorage = NSTextStorage()
    
    /// The custom `NSLayoutManager` which lays out the text within the text container and text view.
    private let layoutManager = DefaultLayoutManager()
    
    /// Document to be rendered.
    public var richTextDocument: RichTextDocument? {
        didSet { renderDocumentIfNeeded() }
    }
    
    /// Sends back the height of the textView after all the custom layout elements have been added.
    @ObservedObject private var heightObservable: RichTextHeightObservable
    
    /// Storage for exclusion paths, regions where a text is not rendered in the text container.
    private var exclusionPathsStorage: [String: UIBezierPath] = [:]
    
    private var attachmentViews = [String: UIView]()
    
    /// The custom `NSTextContainer` which manages the areas text can be rendered to.
    private var textContainer: ConcreteTextContainer!
    
    /**
     Workaround: Internal variable used for handling laying-out content on the text view
     update while changing screen orientation.
     
     Orientation change is tricky to handle for `UITextView` and its `NSLayoutManager`.
     The `layoutManager:didCompleteLayoutForTextContainer:atEnd:` method is called multiple times over the
     orientation change animation and it is difficult to detect when to layout custom subviews presented on
     the text view. I noticed that `viewWillTransition:toSize:withCoordinator` reports size of the `view` that
     will be valid after rotation animation ended and as the text view is about the same size I do a check on
     the `layoutManager:didCompleteLayoutForTextContainer:atEnd:` to detect a proper moment to layout subviews
     on the text view. It works very well with slow and quick multiple-steps orientation change operations.
     */
    private var expectedTextViewSizeAfterOrientationChange: CGSize?
    
    private var isScrollEnabled: Bool
    
    /// trim whitespace from beginning and end of rendered string
    private var trimWhitespace: Bool
    
    /// Set a custom UITextView background color
    public func updateTextViewBackground(color: UIColor) {
        textView.backgroundColor = color
    }
    
    public init(
        renderer: RichTextDocumentRenderer,
        richTextDocument: RichTextDocument? = nil,
        heightObservable: RichTextHeightObservable? = nil,
        isScrollEnabled: Bool? = nil,
        trimWhitespace: Bool? = nil
    ) {
        self.richTextDocument = richTextDocument
        self.renderer = renderer
        self.heightObservable = heightObservable ?? RichTextHeightObservable()
        self.isScrollEnabled = isScrollEnabled ?? true
        self.trimWhitespace = trimWhitespace ?? false
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stopObservingNotifications()
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        layoutManager.blockQuoteDecorationRenderer = BlockQuoteDecorationRenderer(
            blockQuoteConfiguration: renderer.configuration.blockQuote,
            textContainerInsets: renderer.configuration.contentInsets
        )
        textStorage.addLayoutManager(layoutManager)
        
        textContainer = ConcreteTextContainer(size: view.bounds.size)
        textContainer.add(provider: BlockLineFragmentProvider(
            blockQuoteConfiguration: renderer.configuration.blockQuote)
        )
        textContainer.widthTracksTextView = true
        textContainer.heightTracksTextView = true
        textContainer.lineBreakMode = .byWordWrapping
        layoutManager.addTextContainer(textContainer)
        layoutManager.delegate = self
        
        setupTextView()
        textContainer.size.height = .greatestFiniteMagnitude
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isScrollEnabled, heightObservable.height == Metric.defaultArticlePageHeight {
            calculateAndSetPreferredContentSize()
        }
    }
    
    private func setupTextView() {
        textView = UITextView(frame: view.bounds, textContainer: textContainer)
        textView.textContainerInset = renderer.configuration.contentInsets
        textView.backgroundColor = UIColor.systemBackground
        
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        if isScrollEnabled {
            textView.isScrollEnabled = true
            textView.contentSize.height = .greatestFiniteMagnitude
        } else {
            // omitting .greatestFiniteMagnitude lets UITextView fit content when not scrolling
            textView.isScrollEnabled = false
        }
        textView.isEditable = false
        textView.delegate = self
    }
    
    private func invalidateLayout() {
        exclusionPathsStorage.removeAll()
        attachmentViews.forEach { _, view in view.removeFromSuperview() }
        attachmentViews.removeAll()
        textView.textContainer.exclusionPaths.removeAll()
    }
    
    private func stopObservingNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func renderDocumentIfNeeded() {
        guard let document = richTextDocument else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            var output = self.renderer.render(document: document)
            if self.trimWhitespace {
                output = output.trim()
            }
            self.textStorage.beginEditing()
            self.textStorage.setAttributedString(output)
            self.textStorage.endEditing()
            if self.isScrollEnabled {
                self.calculateAndSetPreferredContentSize()
            } else {
                self.preferredContentSize.height = Metric.defaultArticlePageHeight
            }
            self.applyTextViewStyles()
        }
    }
    
    private func applyTextViewStyles() {
        self.textView.linkTextAttributes = [.foregroundColor: self.renderer.configuration.styleProvider.hyperlinkColor]
    }
    
    private func calculateAndSetPreferredContentSize() {
        let newContentSize = textView.sizeThatFits(textView.contentSize)
        guard newContentSize != preferredContentSize else {
            return
        }
        preferredContentSize = newContentSize
        heightObservable.height = newContentSize.height
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // Expect text view to be of the passed in `size`.
        expectedTextViewSizeAfterOrientationChange = size
        invalidateLayout()
    }
    
    // MARK: - NSLayoutManagerDelegate
    
    public func layoutManager(
        _ layoutManager: NSLayoutManager,
        didCompleteLayoutFor textContainer: NSTextContainer?,
        atEnd layoutFinishedFlag: Bool
    ) {
        guard layoutFinishedFlag == true else { 
            return
        }
        // When expected size is specified the text view size have to match. Otherwise that is not a proper moment
        // for laying out the content while changing orientation.
        if let expectedSize = expectedTextViewSizeAfterOrientationChange, expectedSize != textView.bounds.size {
            return
        }
        layoutElementsOnTextView(containerSize: textView.bounds.size)
        expectedTextViewSizeAfterOrientationChange = nil
    }
    
    private func layoutElementsOnTextView(containerSize: CGSize) {
        textView.textStorage.enumerateAttributes(
            in: textView.textStorage.fullRange,
            options: []
        ) { [weak self] attributes, range, _ in
            if attributes.keys.contains(.embed) {
                guard let self = self, let attributedView = attributes[.embed] as? UIView else {
                    return
                }
                
                // In cases if table row or cell has to be rendered on its own in the future, more if cases have to be added here
                
                if let blockAttachment = attributedView as? ResourceLinkBlockViewRepresentable {
                    // Async is needed as if there are multiple tables, the starting positions of each will get calculated wrong, so they have to be recalculated after everything else is drawn, and has to be done one after the other instead of concurrently.
                    DispatchQueue.main.async {
                        self.layoutEmbedElementResourceBlock(attributedView: blockAttachment,  attributes: attributes, range: range, containerSize: containerSize)
                    }
                } else if let tableAttachment = attributedView as? SimpleTableView {
                    // Async is needed as if there are multiple tables, the starting positions of each will get calculated wrong, so they have to be recalculated after everything else is drawn, and has to be done one after the other instead of concurrently.
                    DispatchQueue.main.async {
                        self.layoutEmbedElementTable(attributedView: tableAttachment, attributes: attributes, range: range, containerSize: containerSize)
                    }
                    
                } else {
                    attributedView.isHidden = true
                }
                
            } else if attributes.keys.contains(.horizontalRule) {
                // Async is needed as if there are multiple tables, the starting positions of each will get calculated wrong, so they have to be recalculated after everything else is drawn, and has to be done one after the other instead of concurrently.
                DispatchQueue.main.async {
                    self?.layoutHorizontalRuleElement(attributes: attributes, range: range, containerSize: containerSize)
                }
            }
        }
    }
    
    private func layoutEmbedElementResourceBlock(
        attributedView: ResourceLinkBlockViewRepresentable,
        attributes: [NSAttributedString.Key: Any],
        range: NSRange,
        containerSize: CGSize) {
            let contentInset = renderer.configuration.contentInsets
            
            let glyphRange = layoutManager.glyphRange(
                forCharacterRange: NSRange(location: range.location, length: 1),
                actualCharacterRange: nil
            )
            
            let glyphIndex = glyphRange.location
            guard glyphIndex != NSNotFound && glyphRange.length == 1 else {
                attributedView.isHidden = true
                return
            }
            
            let lineFragmentRect = layoutManager.lineFragmentRect(
                forGlyphAt: glyphIndex,
                effectiveRange: nil
            )
            let glyphLocation = layoutManager.location(forGlyphAt: glyphIndex)
            
            let newWidth = containerSize.width
            - lineFragmentRect.minX
            - glyphLocation.x
            - contentInset.left
            - contentInset.right
            
            let scaleFactor = newWidth / attributedView.frame.width
            let newHeight = scaleFactor * attributedView.frame.height
            
            // Rect specifying an area where text should not be rendered.
            // The rect is being updated right before the exclusion path is created.
            var boundingRect = CGRect(
                x: lineFragmentRect.minX,
                y: lineFragmentRect.minY,
                width: containerSize.width,
                height: newHeight
            )
            
            // Rect specifying an area where the attachment is rendered. This can differ from the `boundingRect`.
            let attachmentRect = CGRect(
                x: lineFragmentRect.minX + glyphLocation.x + contentInset.left,
                y: lineFragmentRect.minY + contentInset.top,
                width: newWidth,
                height: newHeight
            )
            
            if attributedView.superview == nil {
                attributedView.frame = attachmentRect
                
                attributedView.layout(with: attachmentRect.width)
                
                let exclusionKey = String(range.hashValue) + Constant.embedSuffix
                
                // Update bounding rect after laying out the view.
                let updatedRect = attributedView.frame
                boundingRect.size.height = updatedRect.height
                
                addExclusionPath(for: boundingRect, key: exclusionKey, attributes: attributes)
                
                textView.addSubview(attributedView)
                attachmentViews[exclusionKey] = attributedView
            }
        }
    
    private func layoutEmbedElementTable(
        attributedView: SimpleTableView,
        attributes: [NSAttributedString.Key: Any],
        range: NSRange,
        containerSize: CGSize) {
            let contentInset = renderer.configuration.contentInsets
            
            let glyphRange = layoutManager.glyphRange(
                forCharacterRange: NSRange(location: range.location, length: 1),
                actualCharacterRange: nil
            )
            
            let glyphIndex = glyphRange.location
            guard glyphIndex != NSNotFound && glyphRange.length == 1 else {
                attributedView.isHidden = true
                return
            }
            
            let lineFragmentRect = layoutManager.lineFragmentRect(
                forGlyphAt: glyphIndex,
                effectiveRange: nil
            )
            
            let glyphLocation = layoutManager.location(forGlyphAt: glyphIndex)
            
            let newWidth = containerSize.width
            - lineFragmentRect.minX
            - glyphLocation.x
            - contentInset.left
            - contentInset.right
            
            // Rect specifying an area where text should not be rendered.
            // The rect is being updated right before the exclusion path is created.
            var boundingRect = CGRect(
                x: lineFragmentRect.minX,
                y: lineFragmentRect.minY,
                width: containerSize.width,
                height: 100
            )
            
            // Rect specifying an area where the attachment is rendered. This can differ from the `boundingRect`.
            var attachmentRect = CGRect(
                x: lineFragmentRect.minX + glyphLocation.x + contentInset.left,
                y: lineFragmentRect.minY + contentInset.top,
                width: newWidth,
                height: 100
            )
            
            if attributedView.superview == nil {
                textView.addSubview(attributedView)
                attributedView.frame = attachmentRect
                attributedView.setNeedsLayout()
                attributedView.layoutIfNeeded()
                boundingRect.size.height = attributedView.contentSize.height
                attachmentRect.size.height = boundingRect.size.height
                attributedView.frame = attachmentRect
                
                let exclusionKey = String(range.hashValue) + Constant.embedSuffix
                self.addExclusionPath(for: boundingRect, key: exclusionKey, attributes: attributes)
                self.attachmentViews[exclusionKey] = attributedView
            }
        }
    
    private func layoutHorizontalRuleElement(attributes: [NSAttributedString.Key: Any], range: NSRange, containerSize: CGSize) {
        let contentInset = renderer.configuration.contentInsets
        
        guard let attributedView = attributes[.horizontalRule] as? UIView else {
            return
        }
        let glyphRange = layoutManager.glyphRange(
            forCharacterRange: NSRange(location: range.location, length: 1),
            actualCharacterRange: nil
        )
        let glyphIndex = glyphRange.location
        guard glyphIndex != NSNotFound && glyphRange.length == 1 else {
            attributedView.isHidden = true
            return
        }
        let lineFragmentRect = layoutManager.lineFragmentRect(
            forGlyphAt: glyphIndex,
            effectiveRange: nil
        )
        let glyphLocation = layoutManager.location(forGlyphAt: glyphIndex)
        
        let newWidth = containerSize.width
        - lineFragmentRect.minX
        - contentInset.left
        - contentInset.right
        let boundingRect = CGRect(
            x: lineFragmentRect.minX,
            y: lineFragmentRect.minY,
            width: containerSize.width,
            height: 0
        )
        let attachmentRect = CGRect(
            x: lineFragmentRect.minX + glyphLocation.x + contentInset.left,
            y: lineFragmentRect.minY + contentInset.top,
            width: newWidth,
            height: attributedView.frame.height
        )
        let exclusionKey = String(range.hashValue) + Constant.hrSuffix
        addExclusionPath(for: boundingRect, key: exclusionKey, attributes: attributes)
        
        if attributedView.superview == nil {
            attributedView.frame = attachmentRect
            textView.addSubview(attributedView)
            attachmentViews[exclusionKey] = attributedView
        }
    }
    
    /**
     Adds exclusion path for a passed in rect.
     - Parameters:
     - rect: Rect for which exclusion path should be set.
     - key: String uniquely representing the exclusion rect.
     */
    private func addExclusionPath(for rect: CGRect, key: String, attributes: [NSAttributedString.Key: Any]) {
        guard exclusionPathsStorage[key] == nil else {
            return
        }
        let exclusionPath = UIBezierPath(rect: rect)
        exclusionPathsStorage[key] = exclusionPath
        textView.textContainer.exclusionPaths.append(exclusionPath)
        
    }
    
    // MARK: - UITextViewDelegate
    
    public func textView(_ textView: UITextView,
                         shouldInteractWith URL: URL,
                         in characterRange: NSRange,
                         interaction: UITextItemInteraction) -> Bool {
        let attributes = textView.attributedText.attributes(at: characterRange.location, longestEffectiveRange: nil, in: characterRange)
        
        // Asset or Entry hyperlink
        if let linkToResource = attributes[NSAttributedString.Key(rawValue: ResourceLinkInlineRenderer.kContentfulLinkKey)] as? Contentful.Link {
            renderer.configuration.onResourceHyperlinkPressed?(linkToResource)
            return false
        }
        // URL hyperlink interceptor
        if let link = attributes[.link] as? String, let callback = renderer.configuration.onHyperlinkPressed {
            callback(link)
            
            return false
        }
        return true
    }
}


public final class RichTextHeightObservable: ObservableObject {
    @Published public var height: CGFloat = Metric.defaultArticlePageHeight
    
    public init() {}
}
