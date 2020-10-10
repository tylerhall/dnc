# dnc - Does Not Contain

I occassioanlly need to scan a folder and all of its subdirectories to see if any of them DO NOT contain files of a certain type.

I'm fully aware you can do this with some combination of shell commands, but I always spent 20 minutes googling for how to do it again every time I needed to. It was faster just to write this small utility myself.

    USAGE: dnc --directory <directory> --query <string> [--invert]
    
    OPTIONS:
      -d, --directory <directory>
                              The directory to recursively scan.
      -q, --query <string>    A string to search for in the filename of the directory's files.
      --invert                Invert the query. i.e., show directories that DO contain the query.
      -h, --help              Show help information.

My primary use-case is finding which albums in my music collection (folders on disk) are in a lossy format. This gives me a quick shopping list of used CDs to buy when I need something mindless to do during quarantine.

A typical command would be

    dnc -d /path/to/music -q flac

That will output something along the lines of

    /path/to/music/Violent Femmes/1999-11-23 - Viva Wisconsin
    /path/to/music/Weezer/1994-05-10 - Weezer
    /path/to/music/White Denim/2013-10-29 - Corsicana Lemonade
    /path/to/music/Yonder Mountain String Band/A Decade of Yonder Live, Vol 9_ 6_29_2006 Apple Valley, MN
    /path/to/music/Zero 7/The Garden

which means of all the folders recursively inside `/path/to/music`, those directories DO NOT contain any `flac` files.

A key difference of this script than many of the solutions that Google gives me, is I'm _not_ interested in every _file_ that does not match `query`. I just want to know about any _folders_ that do not contain matching files.

You can use the full command line arguments listed above with `--help`, or you can quickly run the command on your current directory by only passing a query string like this:

    dnc flac
