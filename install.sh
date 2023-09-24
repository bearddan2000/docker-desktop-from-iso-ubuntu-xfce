#!/usr/bin/env bash

basefile="install"
logfile="general.log"
timestamp=`date '+%Y-%m-%d %H:%M:%S'`

if [ "$#" -ne 1 ]; then
  msg="[ERROR]: $basefile failed to receive enough args"
  echo "$msg"
  echo "$msg" >> $logfile
  exit 1
fi

function setup-logging(){
  scope="setup-logging"
  info_base="[$timestamp INFO]: $basefile::$scope"

  echo "$info_base started" >> $logfile

  echo "$info_base removing old logs" >> $logfile

  rm -f $logfile

  echo "$info_base ended" >> $logfile

  echo "================" >> $logfile
}

function root-check(){
  scope="root-check"
  info_base="[$timestamp INFO]: $basefile::$scope"

  echo "$info_base started" >> $logfile

  #Make sure the script is running as root.
  if [ "$UID" -ne "0" ]; then
    echo "[$timestamp ERROR]: $basefile::$scope you must be root to run $0" >> $logfile
    echo "==================" >> $logfile
    echo "You must be root to run $0. Try the following"
    echo "sudo $0"
    exit 1
  fi

  echo "$info_base ended" >> $logfile
  echo "================" >> $logfile
}

function docker-check() {
  scope="docker-check"
  info_base="[$timestamp INFO]: $basefile::$scope"
  cmd=`docker -v`

  echo "$info_base started" >> $logfile

  if [ -z "$cmd" ]; then
    echo "$info_base docker not installed"
    echo "$info_base docker not installed" >> $logfile
  fi

  echo "$info_base ended" >> $logfile
  echo "================" >> $logfile

}

function usage() {
    echo ""
    echo "Usage: "
    echo ""
    echo "-u: start."
    echo "-d: tear down."
    echo "-h: Display this help and exit."
    echo ""
}
function start-up(){

  scope="start-up"
  docker_img_name=`head -n 1 README.md | sed 's/# //'`
  info_base="[$timestamp INFO]: $basefile::$scope"

  echo "$info_base started" >> $logfile

  xhost + localhost:docker

  sudo docker build -t $docker_img_name .

  echo "$info_base running image" >> $logfile

 #   --privileged \
 #   --tmpfs /tmp \
 #  --tmpfs /run \
 #  -v /var/run/docker.sock:/var/run/docker.sock \
 
  sudo docker run --rm \
    -e PUID=1000   -e PGID=1000 \
    -e TZ=Etc/UTC \
    -w /workspace \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    $docker_img_name systemd

  echo "$info_base running image" >> $logfile

  echo "$info_base ended" >> $logfile

  echo "================" >> $logfile
}
function tear-down(){

    scope="tear-down"
    docker_img_name=`head -n 1 README.md | sed 's/# //'`
    info_base="[$timestamp INFO]: $basefile::$scope"

    echo "$info_base started" >> $logfile

    echo "$info_base services removed" >> $logfile

    xhost \
      && sudo docker stop $docker_img_name \
      && sudo docker rm $docker_img_name

    echo "$info_base ended" >> $logfile

    echo "================" >> $logfile
}

root-check
docker-check

while getopts ":udh" opts; do
  case $opts in
    u)
      setup-logging
      start-up ;;
    d)
      tear-down ;;
    h)
      usage
      exit 0 ;;
    /?)
      usage
      exit 1 ;;
  esac
done
