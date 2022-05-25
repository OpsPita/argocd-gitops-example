package argocdcue

import (
  "argocd-gitops-example/definitions:governors"
)

#Governor & {
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