extension radius

param namespace string
param replicas string

resource env 'Applications.Core/environments@2023-10-01-preview' = {
  name: 'env'
  properties: {
    compute: {
      kind: 'kubernetes'
      namespace: namespace
    }
  }
}

resource app 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'app'
  properties: {
    environment: env.id
  }
}

resource ctnr 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'ctnr'
  properties: {
    application: app.id
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
    extensions: [
      {
        kind: 'manualScaling'
        replicas: 5
      }
      {
        kind: 'kubernetesNamespace'
        namespace: namespace
      }
    ]
  }
}
