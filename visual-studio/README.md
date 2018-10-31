### Visual Studio Code Workspace

`tasks.json` and `settings.json` contain macOS specific configurations for  
a Visual Studio Code workspace around Bitcoin Core. Place the two files inside  
a `.vscode` directory at the top level of the source code.

#### settings.json
Contains `clang-format`, `python3` and editor related configurations.

#### tasks.json
Contains Bitcoin Core specific tasks, including running:
* `./autogen`
* `./configure`
* `./configure` using depends
* `make check`
* Functional tests
* Extended functional tests
* Linters

More info on `tasks.json` is available [here](https://go.microsoft.com/fwlink/?LinkId=733558).
