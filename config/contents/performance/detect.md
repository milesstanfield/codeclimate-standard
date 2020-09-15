This cop is used to identify usages of
`select.first`, `select.last`, `find_all.first`, `find_all.last`, `filter.first`, and `filter.last`
and change them to use `detect` instead.

### Example:
    # bad
    [].select { |item| true }.first
    [].select { |item| true }.last
    [].find_all { |item| true }.first
    [].find_all { |item| true }.last
    [].filter { |item| true }.first
    [].filter { |item| true }.last

    # good
    [].detect { |item| true }
    [].reverse.detect { |item| true }

`ActiveRecord` compatibility:
`ActiveRecord` does not implement a `detect` method and `find` has its
own meaning. Correcting ActiveRecord methods with this cop should be
considered unsafe.