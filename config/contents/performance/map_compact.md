In Ruby 2.7, `Enumerable#filter_map` has been added.

This cop identifies places where `map { ... }.compact` can be replaced by `filter_map`.

@safety
    This cop's autocorrection is unsafe because `map { ... }.compact` might yield
    different results than `filter_map`. As illustrated in the example, `filter_map`
    also filters out falsy values, while `compact` only gets rid of `nil`.

[source,ruby]
----
[true, false, nil].compact              #=> [true, false]
[true, false, nil].filter_map(&:itself) #=> [true]
----

### Example:
    # bad
    ary.map(&:foo).compact
    ary.collect(&:foo).compact

    # good
    ary.filter_map(&:foo)
    ary.map(&:foo).compact!
    ary.compact.map(&:foo)
