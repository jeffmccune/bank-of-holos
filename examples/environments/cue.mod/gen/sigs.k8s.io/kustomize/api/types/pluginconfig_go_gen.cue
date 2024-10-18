// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go sigs.k8s.io/kustomize/api/types

package types

#HelmConfig: {
	Enabled: bool
	Command: string
	ApiVersions: [...string] @go(,[]string)
	KubeVersion: string
}

// PluginConfig holds plugin configuration.
#PluginConfig: {
	// PluginRestrictions distinguishes plugin restrictions.
	PluginRestrictions: #PluginRestrictions

	// BpLoadingOptions distinguishes builtin plugin behaviors.
	BpLoadingOptions: #BuiltinPluginLoadingOptions

	// FnpLoadingOptions sets the way function-based plugin behaviors.
	FnpLoadingOptions: #FnPluginLoadingOptions

	// HelmConfig contains metadata needed for allowing and running helm.
	HelmConfig: #HelmConfig
}
