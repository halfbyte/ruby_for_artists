# JRubyArt

This is one of the two successor projects of ruby processing

## /!\ Important Note on Java 9

Currently jruby_art (and jruby) does not work with the Java 9 SDK. Install the 1.8 SDK and then use /usr/libexec/java_home -v 1.8 to get the path for JAVA_HOME:

    $ export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"

This should make the installation and running of the examples possible.

## Running this example

    $  k9 --run index.rb
