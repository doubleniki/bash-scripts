source ../tools/base.sh

find_tb_scripts_path() {
  # find a path in $PATH that contains ToolBox
  for path in $(echo "$PATH" | tr ":" "\n"); do
    if [[ $path == *"ToolBox"* ]]; then
      echo "$path"
      break
    fi
  done

  # if no path found, exit
  if [ -z "$path" ]; then
    echo "ToolBox scripts not found. Exiting..."
    exit 1
  fi

  # return the path
  return "$path"
}

find_cmd_script_by_path() {
  cd "$1" || exit 1

  # get all cmd scripts
  cmd_scripts=$(ls | grep -E ".cmd$")

  # iterate over the scripts and find the one that matches the name
  for script in $cmd_scripts; do
    if [[ $script == *"$2"* ]]; then
      echo "$script"
      break
    fi
  done

  # if no script found, exit
  if [ -z "$script" ]; then
    echo "Script not found. Exiting..."
    exit 1
  fi

  # return the script
  return "$script"
}

create_shortcut() {
  # create a shortcut for the script
  echo "alias $1='$2'" >> "$BASH_CFG"
}

create_alias() {
  path=$(find_tb_scripts_path)
  script=$(find_cmd_script_by_path "$path" "$1")
  create_shortcut "$1" "$path/$script"
}
