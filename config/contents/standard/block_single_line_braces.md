Check for uses of braces around single line blocks, but allows either
braces or do/end for multi-line blocks.

### Example:
    # bad - single line block
    items.each do |item| item / 5 end

    # good - single line block
    items.each { |item| item / 5 }
