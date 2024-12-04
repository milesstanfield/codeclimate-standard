Identifies places where `reverse.first(n)` and `reverse.first`
can be replaced by `last(n).reverse` and `last`.

### Example:

    # bad
    array.reverse.first(5)
    array.reverse.first

    # good
    array.last(5).reverse
    array.last
