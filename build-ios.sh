#!/bin/sh

# Color
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Define signal handler and its variable
allowAbort=true;
myInterruptHandler()
{
    if $allowAbort; then
        echo "${RED}The build process has been terminated by user"
        exit 1;
    fi;
}

# Register signal handler
trap myInterruptHandler SIGINT;

case $1 in
  production)
    export BUILD_TARGET=$1
    ;;
  dev)
    export BUILD_TARGET=$1
    ;;
  *)
    echo "${RED}Invalid BUILD_TARGET value $1${NC}"
    echo "${RED}Possible value 'production', 'dev'${NC}"
    exit
    ;;
esac

echo "Start iOS Building..."
echo "target=$BUILD_TARGET"
echo "Flutter Clean..."
fvm flutter clean

fvm flutter pub get

echo "Flutter Building..."
fvm flutter build ios --release
# flutter build ios --bundle-sksl-path flutter_01.sksl.json --release --flavor $BUILD_TARGET -v lib/main_$BUILD_TARGET.dart

# Validate Build Result
if [ $? -eq 0 ]
then
  echo "${GREEN}Build Successfully!${NC}"
else
  echo "${RED}Build Failed!"
  exit 1
fi

# Deploy by fastlane via testflight
if [[ $2 = 'testflight' || $3 = 'testflight' ]]; 
then
  which fastlane
  if [ $? -eq 0 ]
  then
    echo "${GREEN}Fastlane Detected!${NC}"
  else
    echo "${RED}Fastland command not found${NC}"
    echo "${YELLOW}Please install fastlane by the command below: \n brew install fastlane${NC}"
    exit 1
  fi

  echo "Deploy ios to firebase distribution..."
  cd ./ios
  bundle exec fastlane ios --env $BUILD_TARGET testflight_distribution
  if [ $? -eq 0 ]
  then
    echo "${GREEN}Deploy Successfully!${NC}"
    cd ..
  else
    echo "${RED}Deploy Failed!${NC}"
    cd ..
    exit 1
    fi
fi

