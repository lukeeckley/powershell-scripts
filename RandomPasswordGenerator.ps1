# Super simple random password generator in one-line. But now there's more comments than line's of code.
# The 33..126 is the range of ASCII characters to use for our password. http://www.asciitable.com/
-join(33..126|%{[char]$_}|Get-Random -C 28)
