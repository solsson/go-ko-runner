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

FROM golang:1.13.1-stretch@sha256:86f0859c5aa16bf6e168eeaa7ec7b99eb8b91e46f14eccf02fd1bcdf6fc51ea3

RUN curl -SLs https://dl.k8s.io/v1.14.7/kubernetes-client-linux-amd64.tar.gz | tar xzf - --strip-components=3 -C /usr/local/bin/

RUN curl https://raw.githubusercontent.com/golang/dep/1f7c19e5f52f49ffb9f956f64c010be14683468b/install.sh | sh

RUN go get github.com/google/ko/cmd/ko

COPY apply.sh /usr/local/bin/apply
ENTRYPOINT ["/usr/local/bin/apply"]

RUN mkdir -p /nonexistent/.docker && chown -R nobody:nogroup ${GOPATH} /nonexistent
USER nobody
RUN echo '{}' > /nonexistent/.docker/config.json

# Default values here are meant as examples, with https://github.com/triggermesh/knative-local-registry
ENV KO_DOCKER_REPO=builds-registry.ystack.svc.cluster.local/go-ko-runner
ENV KO_SOURCE=github.com/knative/serving
ENV KO_REVISION=master
ENV KO_APPLY_PATH=config/

# Seconds, "infinity" for never
ENV EXIT_DELAY=1
