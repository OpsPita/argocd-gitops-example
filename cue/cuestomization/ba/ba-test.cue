package argocdcue
import (
  "github.com/OpsPita/argocd-gitops-example/definitions"
)

definitions.#BA & {
  metadata: {
    name: "ba-test"
  }
  spec:{
    source:{
      path: "kustomization/overlays/dev/core"
      repoURL: "https://github.com/OpsPita/argocd-gitops-example.git"
    }
    syncPolicy: {
      automated: {
        prune: true
        selfHeal: true
      }
      syncOptions: [
        "CreateNamespace=true"
      ]
      }
  }
}