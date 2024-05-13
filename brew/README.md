# Homebrew

## Leaving a machine

```sh
brew leaves > brew-formulaes.txt
brew list --cask > brew-casks.txt

```

## Installing on a new machine

```sh
xargs brew install < brew-formulaes.txt
xargs brew install --cask < brew-casks.txt
```
