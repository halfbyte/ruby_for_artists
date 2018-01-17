# Soundgen

A very simple demo of how to do synthesis in ruby.

## Listening

play.sh uses sox's play command (brew install sox or similar before trying) to pipe the soundgen
output into your soundcard. To keep things simple, I'm rendering 32 bit floats to STDOUT and then
it's a matter of correctly configuring sox to expect the correct output.

* -t raw  -> raw data without any file format
* -b 32   -> single precision floats are effectively stored as 32 bits
* -r 44100 -> Use 44.1k as the sample rate
* -c 1 -> Only one channel. Use -c 2 if you render stero channels
* -e floating-point -> this is the encoding method
* --endian little -> just make sure that we use the correct endianness regardless of system
* - --> just enables STDIN

On the ruby side, I'm using Array#pack to correctly output the exact type of data. In this case 'e'
stands for single precision, little endian. We could use 'E' and use -b 64, but that's a waste of
resources.

## Saving

Simply use sox with the same options and then supply a filename with the proper extension as the last parameter:

    $ ruby soundgen.rb | sox -t raw -b 32 -r 44100 -c 1 -e floating-point --endian little - test.wav
