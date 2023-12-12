#!/usr/bin/env python3
import os, sys, timeit
import click


# Set up the context for the command line interface and add the options:
@click.command()
@click.option(
    "-n",  # The name of the option
    envvar="N",  # Use the environment variable `N` if it exists
    default=1000,  # Default value if `N` is not set
    help="How many numbers to join",  # Help text for the `-n` option
    type=int,  # Convert the value to an integer
)
@click.option(
    "-m",
    envvar="M",
    default=100,
    help="How many times to run the test",
    type=int,
)
@click.option(
    "--output",
    default="/dev/stdout",  # Write the result to stdout by default # <1>
    help="Path to the output file",
    type=click.Path(writable=True, dir_okay=False),  # <2>
)
def speedtest(m, n, output):  # <3>
    """Run a speed test."""  # Help text for the command

    def join_nums():  # The function to test
        return "-".join([str(i) for i in range(n)])

    bar = click.progressbar(  # Create a progress bar
        length=n * m,
        update_min_steps=n,  # Update the progress bar every `n` steps
        label=f"Running join_nums() {n}*{m} times on Python v{sys.version_info.major}.{sys.version_info.minor}",
        file=sys.stderr,  # Print the progress bar to stderr
    )

    def join_nums_progress():  # Wrap the function to add the progress bar
        result = join_nums()
        bar.update(n)  # Increment the progress bar by `n` steps
        return result

    result = timeit.timeit(join_nums_progress, number=m)  # Run the test

    bar.render_finish()  # Stop rendering the progress bar

    with open(output, "w") as f:  # Open the output file for writing
        print(result, file=f)  # Write the result to the output file

    if output != "/dev/stdout":  # Show the output path if it's not stdout
        print(f"Result written to {output}", file=sys.stderr)

speedtest()
