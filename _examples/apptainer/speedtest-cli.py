#!/usr/bin/env python3
import os, sys, timeit
import click
from math import sqrt


@click.command()  # Set up the context for the command line interface
@click.option(
    "-n",  # The name of the option
    envvar="N",  # Use the environment variable N if it exists
    default=1000,  # Default value if N is not set
    help="How many numbers to join",  # Help text for the -n option
    type=int,  # Convert the value to an integer
)
@click.option(
    "-m",  # The name of the option
    envvar="M",  # Use the environment variable M if it exists
    default=100,  # Default value if M is not set
    help="How many times to run the test",  # Help text for the -m option
    type=int,  # Convert the value to an integer
)
@click.option(
    "--output",
    envvar="OUTPUT_FILE",  # Use the environment variable OUTPUT_FILE if it exists
    default="/dev/stdout",  # Default value if OUTPUT_FILE is not set # <1>
    help="Output file to write the results to",
    type=click.Path(writable=True, dir_okay=False),
)
def speedtest(m, n, output):
    """Run a speed test."""  # Help text for the command

    bar = click.progressbar(
        length=n * m,
        update_min_steps=sqrt(n * m), # How often to update the progress bar
        label="Joining numbers",
        file=sys.stderr,
    )  # <2>

    # Function to test:
    def join_nums():
        result = "-".join([str(i) for i in range(n)])
        bar.update(n)
        return result

    # Print details about the test to stderr:
    print(
        f"Running join_nums() {n}*{m} times on Python v{sys.version_info.major}.{sys.version_info.minor}",
        file=sys.stderr,
    )
    # Run the test:
    result = timeit.timeit(join_nums, number=m)
    bar.render_finish()

    # Print the result:
    with open(output, "w") as f:  # Open the output file for writing
        print(result, file=f)
    print(f"Result written to {output}", file=sys.stderr)


# Run the command:
speedtest()
