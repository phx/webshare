# webshare

This script is used to easily copy files to a directory on a remote host that is used as the document root of a web index.

It supports nested directories and wildcards and copies the resulting URL or list of URLs to the clipboard.

## Instructions:

Change the following variables in the script:

```
URL='https://yourshareurl.com'
WEBROOT='/mnt/media/shared'
FILEHOST='user@host'
```

You should ideally have passwordless SSH set up for the `FILEHOST`.

The `clipboard()` function is currently set up for MacOS, but feel free to change it to your own clipboard copy command.

Ideally, copy `share.sh` into your `$PATH` as something like `share`.

## Usage:

```
share [-dir subdirectory_name] file(s)
```

### Example 1:

```
share file.txt
# This will create https://yourshareurl.com/file.txt
```

### Example 2:

Now let's say you have the following files in a `tools` directory:
```
filea.zip
fileb.zip
filec.zip
```

```
share -dir new_subdirectory tools/*
# This will create the following URLs:
# https://yourshareurl.com/new_subdirectory/tools/filea.zip
# https://yourshareurl.com/new_subdirectory/tools/fileb.zip
# https://yourshareurl.com/new_subdirectory/tools/filec.zip
```
