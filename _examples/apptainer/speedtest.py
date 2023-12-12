#!/usr/bin/env python3
import os, sys, timeit

# Get the values of the environment variables M and N, or use default values:
n = int(os.getenv("N", default=1000))  # How many numbers to join # <1>
m = int(os.getenv("M", default=100))  # How many times to run the test # <1>


# Function to test:
def join_nums():
    return "-".join([str(i) for i in range(n)])


# Print details about the test to stderr: # <2>
print(
    f"Running join_nums() {n}*{m} times on Python v{sys.version_info.major}.{sys.version_info.minor}",
    file=sys.stderr,  # <2>
)

# Run the test:
result = timeit.timeit(join_nums, number=m)  # <3>

# Print the result:
print(result)  # <4>
