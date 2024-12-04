Identifies unnecessary use of a `block_given?` where explicit check
of block argument would suffice.

### Example:
    # bad
    def method(&block)
      do_something if block_given?
    end

    # good
    def method(&block)
      do_something if block
    end

    # good - block is reassigned
    def method(&block)
      block ||= -> { do_something }
      warn "Using default ..." unless block_given?
      # ...
    end
