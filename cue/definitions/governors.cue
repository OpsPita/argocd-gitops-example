package definitions

#Governor: {
  #ArgoCDKind & {
    metadata: {
      name: =~ "governor-"
    }
    spec: {
      source:{
        targetRevision: "main" | "master" |  "feature*" | "release-stg" | "develop"
      }
    }
  }
}




