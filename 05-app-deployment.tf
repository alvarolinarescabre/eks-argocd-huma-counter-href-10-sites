resource "kubectl_manifest" "argocd_app_project" {
  yaml_body = file("${path.root}/argocd/app/app-project.yaml")

  depends_on = [kubectl_manifest.kgateway_helm]
}

resource "kubectl_manifest" "argocd_application" {
  yaml_body = file("${path.root}/argocd/app/application.yaml")

  depends_on = [kubectl_manifest.argocd_app_project]
}

# The Gateway resources used to be applied here; they are now part of the
# counter-api Application. Forget them without deleting them, so the NLB (and
# its DNS name) survive the hand-over to Argo CD.
removed {
  from = kubectl_manifest.app_gateway

  lifecycle {
    destroy = false
  }
}
