Identifies places where custom code finding the sum of elements
in some Enumerable object can be replaced by `Enumerable#sum` method.

@safety
    Autocorrections are unproblematic wherever an initial value is provided explicitly:

    [source,ruby]
    ----
    [1, 2, 3].reduce(4, :+) # => 10
    [1, 2, 3].sum(4) # => 10

    [].reduce(4, :+) # => 4
    [].sum(4) # => 4
    ----

    This also holds true for non-numeric types which implement a `:+` method:

    [source,ruby]
    ----
    ['l', 'o'].reduce('Hel', :+) # => "Hello"
    ['l', 'o'].sum('Hel') # => "Hello"
    ----

    When no initial value is provided though, `Enumerable#reduce` will pick the first enumerated value
    as initial value and successively add all following values to it, whereas
    `Enumerable#sum` will set an initial value of `0` (`Integer`) which can lead to a `TypeError`:

    [source,ruby]
    ----
    [].reduce(:+) # => nil
    [1, 2, 3].reduce(:+) # => 6
    ['H', 'e', 'l', 'l', 'o'].reduce(:+) # => "Hello"

    [].sum # => 0
    [1, 2, 3].sum # => 6
    ['H', 'e', 'l', 'l', 'o'].sum # => in `+': String can't be coerced into Integer (TypeError)
    ----

### Example: OnlySumOrWithInitialValue: false (default)
    # bad
    [1, 2, 3].inject(:+)                        # Autocorrections for cases without initial value are unsafe
    [1, 2, 3].inject(&:+)                       # and will only be performed when using the `-A` option.
    [1, 2, 3].reduce { |acc, elem| acc + elem } # They can be prohibited completely using `SafeAutoCorrect: true`.
    [1, 2, 3].reduce(10, :+)
    [1, 2, 3].map { |elem| elem ** 2 }.sum
    [1, 2, 3].collect(&:count).sum(10)

    # good
    [1, 2, 3].sum
    [1, 2, 3].sum(10)
    [1, 2, 3].sum { |elem| elem ** 2 }
    [1, 2, 3].sum(10, &:count)

### Example: OnlySumOrWithInitialValue: true
    # bad
    [1, 2, 3].reduce(10, :+)
    [1, 2, 3].map { |elem| elem ** 2 }.sum
    [1, 2, 3].collect(&:count).sum(10)

    # good
    [1, 2, 3].sum(10)
    [1, 2, 3].sum { |elem| elem ** 2 }
    [1, 2, 3].sum(10, &:count)
