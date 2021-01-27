# kparams (in Haskell)

Extracts kernel parameter values from /proc/cmdline. Handles bare and quoted
parameters. This is a rewrite of the [original kparams](
https://github.com/mcsaucy/kparams) in Haskell.

See [kernel.org's docs on kernel parameters](
https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html) for
more information. While the docs mention using double-quotes to protect values
with spaces, we also recognize single-quotes and certain escape sequences to
support things like `quoted="\"value\""`.

Check out `test/` to see examples of what we can extract.

## Usage

`$ kparams PARAM_NAME [DEFAULT_VALUE]`

## What's the difference between the shell implementation of kparams and this?

They should be functionally similar. Error messages will differ, although they
should error under the same conditions. Most significantly, this version is
hundreds of times faster.
