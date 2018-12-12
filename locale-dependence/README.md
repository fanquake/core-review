### Locale Dependence

Where possible, usage of locale dependent functions should be avoided, as  
their usage can produce unexpected results.

Some examples include:

### std::isspace
Compile [isspace.cpp](isspace.cpp):
```
clang++ -o isspace isspace.cpp 
```

Run:
```
echo $LANG
en_AU.UTF-8

./isspace
1 0 1

LANG=C ./isspace
0 0 0

LANG=it_IT.ISO8859-15 ./isspace
0 0 1

LANG=uk_UA.KOI8-U ./isspace
0 1 0
```
