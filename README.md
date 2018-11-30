# Go `ko` runner

With [Knative](https://github.com/knative/) we run current master a lot,
sometimes with multiple modules, without the need to edit any code.

This docker image automates the process of [ko](https://github.com/google/go-containerregistry/tree/master/cmd/ko) `apply`.

## Example run

```
runner=solsson/go-ko-runner@sha256:31b647c6ce06a02cf9a2aa6f1277f911fc0f1f78dca7cbd83dd7564cfcbc8ee9
kubectl create serviceaccount ko-runner --namespace=default
kubectl create clusterrolebinding ko-runner --clusterrole=cluster-admin --serviceaccount=default:ko-runner --namespace=default
kubectl run install-knative-build-pipeline --serviceaccount=ko-runner \
  --restart=Never --image=$runner \
  --env="KO_SOURCE"=github.com/knative/build-pipeline --env="KO_REVISION=master"
  # -t -i --command bash
```



