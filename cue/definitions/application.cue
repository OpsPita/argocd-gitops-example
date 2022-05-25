package definitions

import (
  "strings"
)

#ArgoCDKind: {
  #CRDetails & {}
  // #Metadata & {}
  metadata: {
    name: string | *strings.TrimSuffix(strings.Split(spec.source.repoURL,"/")[4] ,".git")
    namespace: string | *"argocd"
  }
  spec:{
  #Spec & {}
  
    }


}

#Spec: {
  // spec: {
    project: string | *""
    #Destination & {}
    #Source & {}
    #SyncPolicy & {}
  // }
}


#CRDetails: {
    apiVersion: string | *"argoproj.io/v1alpha1"
    kind: string | *"Application"
}
#Metadata: {
  metadata: {
    name: string |  #Source.source.repoURL & {}
    namespace: string | *"argocd"
  }
}
#SyncPolicy: {
    syncPolicy: {
       automated: {
        prune: bool | *true
        selfHeal: bool | *true
       }
       syncOptions: [...string]
    }
}
#Source: {
    source: {
      path: string
      repoURL: string
      targetRevision: string | *"main"
    }
}
#Destination: {
      destination: {
      namespace: string | *"default"
      server: string | *"https://kubernetes.default.svc"
    }
}

