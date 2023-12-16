(@) Go to <{{< meta lmod-example.download-page >}}>, choose the version of {{< meta lmod-example.displayname >}} you want to install, copy the download link to the file, and download the file by running the following command on a {{< term Klone >}} {{< term "login node|login" >}} or {{< term "compute node" >}}. We'll use version {{< meta lmod-example.version >}} as an example:

    ``` {.bash}
    mkdir -p "/gscratch/scrubbed/$USER/downloads" && cd "$_" # <1>
    curl -LO {{< meta lmod-example.file-url >}} # <2>
    ```
    1. Create the target directory if it does not exist and navigate to it (`$_` is a special variable that expands to the last argument of the previous command).
    2. `curl` is a program you can use to download files from the web. Replace the URL with the URL for the version of {{< meta lmod-example.displayname >}} you want to install. The `-L` option tells `curl` to follow redirects, and the `-O` option tells it to save the file to the current directory.

    ::: callout-tip
    The directory `/gscratch/scrubbed/$USER/downloads` will expand to `/gscratch/scrubbed/(your username)/downloads`. This directory is a good place to save files temporarily -- see our [guide](/docs/storage/klone-storage.qmd) to storage on {{< term Klone >}} for more information. 
    :::

(@) Extract the archive and copy the contents to `/sw/contrib/mylabname-src/{{< meta lmod-example.basename >}}/{{< meta lmod-example.version >}}` (replacing `mylabname` with the name of your lab):
    
    ``` {.bash}
    unzip {{< meta lmod-example.download-filename >}} -d {{< meta lmod-example.basename >}}{{< meta lmod-example.version >}}.zip # <1>
    # Make sure you include the parentheses around the commands below. Replace "mylabname" with your lab name! # <2>
    (umask 002 && mkdir -p /sw/contrib/mylabname-src/{{< meta lmod-example.basename >}}/{{< meta lmod-example.version >}} && rsync -rlHP --chmod=a+rwX {{< meta lmod-example.basename >}}{{< meta lmod-example.version >}}/{{< meta lmod-example.copy-dir >}}/ $_) # <3>
    rm -rfv {{< meta lmod-example.download-filename >}} {{< meta lmod-example.basename >}}{{< meta lmod-example.version >}} # <4>
    ```
    1. Extract the {{< meta lmod-example.displayname >}} archive to a new directory called `{{< meta lmod-example.basename >}}{{< meta lmod-example.version >}}`.
    2. In <tt>{{< term bash >}}</tt>, parentheses create a [subshell]((https://tldp.org/LDP/abs/html/subshells.html), which runs the enclosed commands in a new shell session. We want to use it here so that we can temporarily modify the default permissions for new files and directories with the [`umask`](https://wiki.archlinux.org/title/umask) command. Your current settings will remain intact when the commands in the subshell are completed.
    3. We're running a series of commands here in a [subshell]((https://tldp.org/LDP/abs/html/subshells.html). Let's break it down:
        - `umask 002` modifies the default permissions for new files and directories so that they are readable and writable by you and your group, and readable by everyone else.
        - `mkdir -p /sw/contrib/mylabname-src/{{< meta lmod-example.basename >}}/{{< meta lmod-example.version >}}` creates the directory if it does not exist.
        - `rsync -rlHP --chmod=a+rwX {{< meta lmod-example.basename >}}{{< meta lmod-example.version >}}/{{< meta lmod-example.copy-dir >}}/ $_` copies everything under `{{< meta lmod-example.basename >}}{{< meta lmod-example.version >}}/{{< meta lmod-example.copy-dir >}}/` to `/sw/contrib/mylabname-src/{{< meta lmod-example.basename >}}/{{< meta lmod-example.version >}}`:
            - The `-r` option tells `rsync` to copy directories recursively,  `-lH` tells it to preserve {{< term "symbolic links" >}}  and {{< term "hard links" >}}, and `-P` tells it to show progress while copying.
            - `--chmod=a+rwX`  sets the permissions for the copied files and directories so that they are `r`eadable and `w`ritable by you and your group, and readable by everyone else. `X` ensures that directories can be searched (listed) and that executables can be executed by everyone, so others outside your group can use the software you install. Although `a+` means "add these permissions for everyone", because we set `umask 002` earlier, other users will not be able to edit or delete the files you install.
            - The `/` at the end of `{{< meta lmod-example.basename >}}{{< meta lmod-example.version >}}/{{< meta lmod-example.copy-dir >}}/` tells `rsync` to copy the contents of the directory, rather than the directory itself.
            - `$_` is a special variable that expands to the last argument of the previous command.
    4. Remove the downloaded file and the extracted directory.

(@) Use a text editor to create an Lmod `.lua` module file for the new release with a text editor, using `{{< meta lmod-example.version >}}.lua` as the filename:

	``` {.lua filename="`r paste0("/sw/contrib/modulefiles/mylabname/", rmarkdown::metadata$"lmod-example"$"basename", rmarkdown::metadata$"lmod-example"$"version", ".lua") `"}
	{{< include _lmod-template-header.lua >}}
	{{< meta lmod-example.modulefile-footer >}}
    ```

	::: callout-tip
	If you don't know how to use a text editor on {{< term Klone >}}, you can try [nano](https://www.nano-editor.org/), which is installed on the system. To create a new file, run `nano filename`, paste the contents of the template into the file, and save it by pressing `Ctrl+O` and then `Enter`. To exit, press `Ctrl+X`.
	:::

(@) Check that the module is available and load it:
	``` {.bash}
	module -I spider mylabname/{{< meta lmod-example.basename >}} # <1>
	module load mylabname/{{< meta lmod-example.basename >}}/{{< meta lmod-example.version >}}
	```
	1. Lmod takes some time to cache available modules. You can use the `-I` option to force Lmod to check for new modules.
