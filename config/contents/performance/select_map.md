In Ruby 2.7, `Enumerable#filter_map` has been added.

This cop identifies places where `select.map` can be replaced by `filter_map`.

### Example:
    # bad
    ary.select(&:foo).map(&:bar)
    ary.filter(&:foo).map(&:bar)

    # good
    ary.filter_map { |o| o.bar if o.foo }
