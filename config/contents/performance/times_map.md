Checks for .times.map calls.
In most cases such calls can be replaced
with an explicit array creation.

@safety
    This cop's autocorrection is unsafe because `Integer#times` does nothing if receiver is 0
    or less. However, `Array.new` raises an error if argument is less than 0.

    For example:

    [source,ruby]
    ----
    -1.times{}    # does nothing
    Array.new(-1) # ArgumentError: negative array size
    ----

### Example:
    # bad
    9.times.map do |i|
      i.to_s
    end

    # good
    Array.new(9) do |i|
      i.to_s
    end