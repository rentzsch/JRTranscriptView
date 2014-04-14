JRTranscriptView
================

I couldn't get iOS 7's UITextView to behave like I wanted, so I wrote JRTranscriptView from scratch using Text Kit.

Highlights:

- Logging framework agnostic -- it's just a text view.
- Simple API. Just append strings or clear the entire view.
- Automatically scrolls as strings are appended.
	- But respects the user's scroll position.
- No needless animation.
- Customizable font.
	- But a sane default is provided: *Menlo 10*.

Version History
---------------

### v1.0: Apr 14 2014

- Initial release.