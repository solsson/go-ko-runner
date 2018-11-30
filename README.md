# Go `ko` runner

With [Knative](https://github.com/knative/) we run current master a lot,
sometimes with multiple modules, without the need to edit any code.

This docker image automates the process of [ko](https://github.com/google/go-containerregistry/tree/master/cmd/ko) `apply`.

## Example run

This example assumes that you have https://github.com/triggermesh/knative-local-registry in your cluster,
which is why there's no authentication setup for Docker push.

```
runner=solsson/go-ko-runner@sha256:3967f69d7bf0c512c3bad65538bf66b661ceab9a5d37c1b1f2dd8cafe944142a
kubectl create serviceaccount ko-runner --namespace=default
kubectl create clusterrolebinding ko-runner --clusterrole=cluster-admin --serviceaccount=default:ko-runner --namespace=default
kubectl run install-knative-build-pipeline --serviceaccount=ko-runner \
  --restart=Never --image=$runner \
  --env="KO_SOURCE=github.com/knative/build-pipeline" --env="KO_REVISION=master" \
  --env="EXIT_DELAY=infinity"
```

The exit delay is there because you might want to `kubectl exec -ti install-knative-build-pipeline` and do stuff 🙂. After installation you'll probably want to:

```
kubectl create clusterrolebinding ko-runner
kubectl create serviceaccount ko-runner
```

## Support

We would love your feedback on this project so don't hesitate to let us know what is wrong and how we could improve it, just file an [issue](https://github.com/triggermesh/charts/issues/new)

## Code of Conduct

This plugin is by no means part of [CNCF](https://www.cncf.io/) but we abide by its [code of conduct](https://github.com/cncf/foundation/blob/master/code-of-conduct.md)
