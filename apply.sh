#!/bin/bash
set -e
set -x

#https://github.com/knative/serving/blob/master/DEVELOPMENT.md#setup-your-environment-
export DOCKER_REPO_OVERRIDE="${KO_DOCKER_REPO}"

mkdir -p ${GOPATH}/src/${KO_SOURCE}
git clone https://${KO_SOURCE} ${GOPATH}/src/${KO_SOURCE}

cd ${GOPATH}/src/${KO_SOURCE}

git checkout origin/${KO_REVISION}

echo "Running ko with registry ${KO_DOCKER_REPO}"
ko apply -f config/

# You'll often want to ko apply dependencies too, or install from release, but here's some help in case not
if [ -d ./third_party ]; then
  echo "For any additional apply instructions use something like"
  echo "kubectl apply -f https://${KO_SOURCE}/raw/${KO_REVISION}/third_party/[see development readme]"
  if [ ! -z "$INSTALL_THIRD_PARTY" ]; then
    kubectl apply -R -f ./third_party
  fi
fi

# You sometimes want to exec into the pod to do stuff
echo "Sleeping for $EXIT_DELAY seconds before exit"
sleep $EXIT_DELAY
