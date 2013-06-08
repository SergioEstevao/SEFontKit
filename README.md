## SEFontKit

A library with some usefull extensions to UIFont, a view to visualize font metrics and two pickers: one from fonts another for attributes.

### SEFontMetricView

Inspired by this [blog entry](http://www.cocoanetics.com/2010/02/understanding-uifont/), the SEFontMetricsView is an extension to UITextField that allows to see the metrics of the font being used in the text field.

This view displays reference values for the following values:

- BaseLine:
- Ascender: The top y-coordinate, offset from the baseline, of the receiver’s longest ascender.
- Descender: The bottom y-coordinate, offset from the baseline, of the receiver’s longest descender.
- Cap Height: This value measures (in points) the maximum height of a capital character.
- X Height: This value measures (in points) the height of the lowercase character "x".

### SEFontPickerViewController

A view controller that allows you to pick a font from the system.

###SETextAttributesPickerViewController

A viewController that allows you to configure the attributes for an attributed string.

## Demo

Build and run the `Demo` project in Xcode to see `SEFontKit` in action.

## Requirements

`SEFontKit` is compatible with iOS 4.3+ as a deployment target, but must be compiled using the iOS 6 SDK. If you get compiler errors for undefined constants, try upgrading to the latest version of Xcode, and updating your project to the recommended build settings.

`SEFontKit` also requires the `CoreText` and `Core Graphics` frameworks wich you will have to add them to your project.

## Contact

Sergio Estevao

- http://github.com/SergioEstevao
- http://twitter.com/SergioEstevao
- sergioestevao@gmail.com

## License

SEFontKit is available under the MIT license. See the LICENSE file for more info.
