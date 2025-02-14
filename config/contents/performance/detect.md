This cop is used to identify usages of `first`, `last`, `[0]` or `[-1]`
chained to `select`, `find_all` or `filter` and change them to use
`detect` instead.

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

`ActiveRecord` compatibility:
`ActiveRecord` does not implement a `detect` method and `find` has its
own meaning. Correcting ActiveRecord methods with this cop should be
considered unsafe.