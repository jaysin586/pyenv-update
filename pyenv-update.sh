#!/bin/bash

# A function to update the python version in a local pyenv virtualenv
# Usage: pyenv_update <version>
# Example: pyenv_update 3.9.7
# Note: This will install the python version if it is missing.
#       It will then remove the virtualenv and recreate it.
pyenv_update() {
  PYENV_FILE=.python-version
  PYENV_FREEZE_FILE=.requirements-lock.txt
  if [ -z "$1" ]; then
      echo "Please specify the version of python to update to."
      return
  fi

  if [ -f "$PYENV_FILE" ]; then
      echo "$PYENV_FILE exists."
  else
      echo "$PYENV_FILE does not exist."
      return
  fi

  pyenv install -s "$1"
  pyenv_version=$(head -n 1 $PYENV_FILE)
  pip freeze > "$PYENV_FREEZE_FILE"
  pyenv uninstall -f "$pyenv_version"
  pyenv virtualenv "$1" "$pyenv_version"
  pip install --upgrade pip
  pip install -r "$PYENV_FREEZE_FILE"
  rm "$PYENV_FREEZE_FILE"
}