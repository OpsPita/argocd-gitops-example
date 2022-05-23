package argocdcue


#Application: {
  apiVersion: string | *"argoproj.io/v1alpha1"
  kind: string | *"Application"
  metadata: {
    name: string
    namespace: string | *"argocd"
  }
  spec: {
    project: string | *""
    destination: {
      namespace: string | *"default"
      server: string | *"https://kubernetes.default.svc"
    }
    source: {
      path: string
      repoURL: string
      targetRevision: string
    }
    syncPolicy: {
       automated: {
        prune: bool
        selfHeal: bool
       }
       syncOptions: [...string]
    }
  }

}



app: #Application & {
  metadata:
    name: "core-apps"
    namespace: "argocd"
  spec:
    project: ""
    source:
      path: "kustomization/overlays/dev/core"
      repoURL: "https://github.com/OpsPita/argocd-gitops-example.git"
      targetRevision: "main"
    syncPolicy:
      automated:
        prune: true
        selfHeal: true
      syncOptions: {
        "CreateNamespace=true"
      }
}