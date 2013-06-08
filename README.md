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
