SEFontKit
=============

A library with some usefull extensions to UIFont.

SEFontMetricView
________________

Inspired by this blog entry, the SEFontMetricView is an extension to UITextField that allows to see the metrics of the font being used in the text field.

This view displays reference values for the following values:

- BaseLine:
- Ascender: The top y-coordinate, offset from the baseline, of the receiver’s longest ascender.
- Descender: The bottom y-coordinate, offset from the baseline, of the receiver’s longest descender.
- Cap Height: This value measures (in points) the maximum height of a capital character.
- X Height: This value measures (in points) the height of the lowercase character "x".

