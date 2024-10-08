// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/holos-run/holos/api/v1alpha1

package v1alpha1

// BuildPlan is the primary interface between CUE and the Holos cli.
#BuildPlan: {
	#TypeMeta

	// Metadata represents the holos component name
	metadata?: #ObjectMeta    @go(Metadata)
	spec?:     #BuildPlanSpec @go(Spec)
}

#BuildPlanSpec: {
	disabled?:   bool                 @go(Disabled)
	components?: #BuildPlanComponents @go(Components)

	// DeployFiles keys represent file paths relative to the cluster deploy
	// directory.  Map values represent the string encoded file contents.  Used to
	// write the argocd Application, but may be used to render any file from CUE.
	deployFiles?: #FileContentMap @go(DeployFiles)
}

#BuildPlanComponents: {
	helmChartList?: [...#HelmChart] @go(HelmChartList,[]HelmChart)
	kubernetesObjectsList?: [...#KubernetesObjects] @go(KubernetesObjectsList,[]KubernetesObjects)
	kustomizeBuildList?: [...#KustomizeBuild] @go(KustomizeBuildList,[]KustomizeBuild)
	resources?: {[string]: #KubernetesObjects} @go(Resources,map[string]KubernetesObjects)
}
