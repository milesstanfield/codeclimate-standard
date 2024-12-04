Identifies places where `Concurrent.monotonic_time`
can be replaced by `Process.clock_gettime(Process::CLOCK_MONOTONIC)`.

### Example:

    # bad
    Concurrent.monotonic_time

    # good
    Process.clock_gettime(Process::CLOCK_MONOTONIC)
