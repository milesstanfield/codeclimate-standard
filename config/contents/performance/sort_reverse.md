Identifies places where `sort { |a, b| b <=> a }`
can be replaced by a faster `sort.reverse`.

### Example:
    # bad
    array.sort { |a, b| b <=> a }

    # good
    array.sort.reverse
