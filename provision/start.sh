#!/bin/bash
set -o errexit
# set -o nounset

__DIR__="$(cd "$(dirname "${0}")"; echo $(pwd))"
__BASE__="$(basename "${0}")"
__FILE__="${__DIR__}/${__BASE__}"

function _list_excluded_apps() {
  local file=$1
  local -a excluded_apps=()
  if [[ -f $file ]];then
    excluded_apps=$(cat "$file")
  fi
  echo ${excluded_apps[@]}
}

function _install_app() {
  local app=$1 app_folder=$2
  local runfile="${app_folder}/run.sh"
  if [ ! -f "$runfile" ];then
    bash "${runfile}"
    local ec=$?
    echo "------------------------------------"
    echo
    if [[ $ec -ne 0 ]];then
      echo "Can not install app '${app}'." >&2
      exit 1
    fi
  else
    echo
    echo "Unable to locate $runfile, skipping install"
    echo "------------------------------------"
    echo
  fi
}

function install_apps() {
  local apps_folder=$1 excluded_apps=$2
  for app in $(ls ${apps_folder}); do
    if [[ " ${excluded_apps[@]} " =~ " ${app} " ]]; then
      echo "App '${app}' is excluded and will not be installed."
    else
      echo "Installing app '${app}'"
      echo "------------------------------------"
      echo
      _install_app ${app} "${apps_folder}${app}"
      local ec=$?
      echo "------------------------------------"
      echo
      if [[ $ec -ne 0 ]];then
        echo "Can not install app '${app}'." >&2
        exit 1
      fi
    fi
  done
}

function start_apps() {
  if [[ -f $PROJECTLIST ]];then
    for project in $(cat "$PROJECTLIST")
    do
      echo "Starting project ${project}"
      echo "------------------------------------"
      echo
      rbrequire --project="${project}"
      local ec=$?
      echo "------------------------------------"
      echo
      if [ $ec -ne 0 ];then
        echo "Can not start ${project}." >&2
        exit 1
      fi
    done
  fi
}

function cleanup_images() {
  local images=$(docker images -f "dangling=true" -q)
  if [[ ! -z $images ]];then
    echo
    echo "Remove not tagged images"
    echo "------------------------------------"
    echo
    OUT=$(docker rmi $images)
    echo $OUT
    echo "------------------------------------"
    echo
  fi
}

function cleanup_containers() {
  local containers="$(docker ps --filter "status=exited" -qa)"
  if [[ ! -z $containers ]];then
    echo
    echo "Clean up exited container"
    echo "------------------------------------"
    echo
    docker rm $containers 2> /dev/null
    echo "------------------------------------"
    echo
  fi
}

function print_usage() {
  local usage="Usage: $(basename "$0") [options] --apps-folder=FOLDER

    Provisioning script that will build and install and run the apps located in
    the apps folder. For each app it will try to locate its run.sh script and
    execute it.
    The goal of this provisioning script is to start Docker containers (one for
    each app) in the vagrant box.

Required:
    --apps-folder=FOLDER must be the parent folder containing all the Docker
                         projects that must be started within this Box

Options:
    --help                show this help text and exit
    --excluded-apps=FILE  set the file containing the list of apps to exclude
                          (one per line)
"
    echo "$usage"
}

function main() {
  if [[ $# == 0 ]];then
    echo "Wrong usage of $__FILE__, use --help option to show help" >&2
    exit 1
  fi

  local apps_folder_opt= apps_folder=
  local excluded_apps_opt= excluded_apps=

  for i in "$@"
  do
    case $i in
      --apps-folder=*)
      apps_folder_opt="${i#*=}"
      if [[ -d $apps_folder_opt ]];then
        apps_folder=$apps_folder_opt
        if [[ "${apps_folder: -1}" != "/" ]];then
          apps_folder="$apps_folder/"
        fi
      else
        echo "--apps-folder option must be an existing folder"
        exit 1
      fi
      shift
      ;;
      --excluded-apps=*)
      excluded_apps_opt="${i#*=}" excluded_apps=
      if [[ -f $excluded_apps_opt ]];then
        excluded_apps=$excluded_apps_opt
      else
        echo "--excluded-apps option must be an existing file"
        exit 1
      fi
      shift
      ;;
      --help)
        print_usage
        exit 0
      shift
      ;;
      *)
      # unknown option
      ;;
    esac
  done

  if [[ -z "$apps_folder_opt" ]];then
    echo "--apps-folder option is required"
    exit 1
  fi

  if [[ ! -z "$apps_folder" ]];then
    echo "------------------------------------"
    echo
    local -a excluded_apps=$(_list_excluded_apps "$excluded_apps")
    install_apps $apps_folder $excluded_apps
    # start_apps $apps_folder $excluded_apps
    # cleanup_containers
    # cleanup_images
  fi
}

main "$@"
