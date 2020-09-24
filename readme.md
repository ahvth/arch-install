The goal of this project is to automate installation of arch linux, with paramaters specified in a config file (archconfig).

The packagefile allows users to specify a list of packages to install to allow for a completely custom-tailored OS defined entirely in 2 files.

#####development and deployment scheme

```
clone <- master -> develop
|           ^      |
deployment  |      push trigger
            |      |
            |_____ automated test
```

#####TODO

automate vbox
