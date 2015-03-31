#Curator Windows Install

###Once installed from the npm (curator and coffescript)
Go to `C:\Users\USERNAME\AppData\Roaming\npm` Make sure the below files are correct.

##curator

```
#!/bin/sh
basedir=`dirname "$0"`
 
case `uname` in
    *CYGWIN*) basedir=`cygpath -w "$basedir"`;;
esac
 
if [ -x "$basedir/coffee" ]; then
  "$basedir/coffee"  "$basedir/node_modules/eda-curator/bin/curator" "$@"
  ret=$?
else 
  coffee  "$basedir/node_modules/eda-curator/bin/curator" "$@"
  ret=$?
fi
exit $ret

```

##curator.cmd

```

@IF EXIST "%~dp0\coffee.exe" (
  "%~dp0\coffee.exe"  "%~dp0\node_modules\eda-curator\bin\curator" %*
) ELSE (
  @SETLOCAL
  @SET PATHEXT=%PATHEXT:;.JS;=;%
  coffee  "%~dp0\node_modules\eda-curator\bin\curator" %*
)

```


##coffee

```

#!/bin/sh
basedir=`dirname "$0"`

case `uname` in
    *CYGWIN*) basedir=`cygpath -w "$basedir"`;;
esac

if [ -x "$basedir/node" ]; then
  "$basedir/node"  "$basedir/node_modules/coffee-script/bin/coffee" "$@"
  ret=$?
else 
  node  "$basedir/node_modules/coffee-script/bin/coffee" "$@"
  ret=$?
fi
exit $ret

``