# Copyright 2018 TriggerMesh, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang:1.11.2-stretch@sha256:498f71698c1bcbf50d6e5f08ce60c30ccab3ab5b6775c4b5395b1ae1a367bdab

RUN curl -SLs https://dl.k8s.io/v1.12.3/kubernetes-client-linux-amd64.tar.gz | tar xzf - --strip-components=3 -C /usr/local/bin/

RUN curl https://raw.githubusercontent.com/golang/dep/f0d88bbe4c99d3bf4a81ad42f27d09b3fd0b7e59/install.sh | sh

RUN go get github.com/google/go-containerregistry/cmd/ko

COPY apply.sh /usr/local/bin/apply
ENTRYPOINT ["/usr/local/bin/apply"]

RUN mkdir -p /nonexistent/.docker && chown -R nobody:nogroup ${GOPATH} /nonexistent
USER nobody
RUN echo '{}' > /nonexistent/.docker/config.json

# Default values here are meant as examples, with https://github.com/triggermesh/knative-local-registry
ENV KO_DOCKER_REPO=knative.registry.svc.cluster.local/go-ko-runner
ENV KO_SOURCE=github.com/knative/build-pipeline
ENV KO_REVISION=master

# Seconds, "infinity" for never
ENV EXIT_DELAY=1
