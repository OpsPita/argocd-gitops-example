package argocdcue

import (
  "github.com/OpsPita/argocd-gitops-example/definitions"
)

definitions.#Governor & {
  metadata: {
    name: "governor-core"
  }
  spec:{
    source:{
      path: "kustomization/overlays/dev/core"
      repoURL: "https://github.com/OpsPita/argocd-gitops-example.git"
    }
  }
}