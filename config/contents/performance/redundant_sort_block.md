Identifies places where `sort { |a, b| a <=> b }` can be replaced with `sort`.

### Example:
    # bad
    array.sort { |a, b| a <=> b }

    # good
    array.sort
