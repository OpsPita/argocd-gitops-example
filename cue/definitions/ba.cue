package definitions

#BA: {
  #ArgoCDKind & {
    metadata: {
      name: =~ "ba-"
    }
    spec: {
      source:{
        targetRevision: "main" | "master" |  "feature*" | "release-stg"
      }
    }
  }
}



