Identifies usages of `first`, `last`, `[0]` or `[-1]`
chained to `select`, `find_all` or `filter` and change them to use
`detect` instead.

@safety
    This cop is unsafe because it assumes that the receiver is an
    `Array` or equivalent, but can't reliably detect it. For example,
    if the receiver is a `Hash`, it may report a false positive.

### Example:
    # bad
    [].select { |item| true }.first
    [].select { |item| true }.last
    [].find_all { |item| true }.first
    [].find_all { |item| true }.last
    [].filter { |item| true }.first
    [].filter { |item| true }.last
    [].filter { |item| true }[0]
    [].filter { |item| true }[-1]

    # good
    [].detect { |item| true }
    [].reverse.detect { |item| true }
