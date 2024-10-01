// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go github.com/holos-run/holos/api/author/v1alpha3

// Package v1alpha3 contains CUE definitions intended as convenience wrappers
// around the core data types defined in package core.  The purpose of these
// wrappers is to make life easier for platform engineers by reducing boiler
// plate code and generating component build plans in a consistent manner.
package v1alpha3

import (
	core "github.com/holos-run/holos/api/core/v1alpha3"
	"google.golang.org/protobuf/types/known/structpb"
)

// Component represents the fields common the different kinds of component.  All
// components have a name, support mixing in resources, and produce a BuildPlan.
#ComponentFields: {
	// Name represents the Component name.
	Name: string

	// Resources are kubernetes api objects to mix into the output.
	Resources: {...} @go(,map[string]any)

	// ArgoConfig represents the ArgoCD GitOps configuration for this Component.
	ArgoConfig: #ArgoConfig

	// BuildPlan represents the derived BuildPlan for the Holos cli to render.
	BuildPlan: core.#BuildPlan
}

// Helm provides a BuildPlan via the Output field which contains one HelmChart
// from package core.  Useful as a convenience wrapper to render a HelmChart
// with optional mix-in resources and Kustomization post-processing.
#Helm: {
	#ComponentFields

	// Version represents the chart version.
	Version: string

	// Namespace represents the helm namespace option when rendering the chart.
	Namespace: string

	// Repo represents the chart repository
	Repo: {
		name: string @go(Name)
		url:  string @go(URL)
	} @go(,"struct{Name string \"json:\\\"name\\\"\"; URL string \"json:\\\"url\\\"\"}")

	// Values represents data to marshal into a values.yaml for helm.
	Values: _ & {...} @go(,interface{})

	// Chart represents the derived HelmChart for inclusion in the BuildPlan
	// Output field value.  The default HelmChart field values are derived from
	// other Helm field values and should be sufficient for most use cases.
	Chart: core.#HelmChart

	// EnableKustomizePostProcessor processes helm output with kustomize if true.
	EnableKustomizePostProcessor: bool & (true | *false)

	// KustomizeFiles represents additional files to include in a Kustomization
	// resources list.  Useful to patch helm output.  The implementation is a
	// struct with filename keys and structs as values.  Holos encodes the struct
	// value to yaml then writes the result to the filename key.  Component
	// authors may then reference the filename in the kustomization.yaml resources
	// or patches lists.
	// Requires EnableKustomizePostProcessor: true.
	KustomizeFiles: {...} & {[string]: {...}} @go(,map[string]any)

	// KustomizePatches represents patches to apply to the helm output.  Requires
	// EnableKustomizePostProcessor: true.
	KustomizePatches: {...} & {[string]: {...}} @go(,map[core.InternalLabel]any)

	// KustomizeResources represents additional resources files to include in the
	// kustomize resources list.
	KustomizeResources: {...} & {[string]: {...}} @go(,map[string]any)
}

// Kustomize provides a BuildPlan via the Output field which contains one
// KustomizeBuild from package core.
#Kustomize: {
	#ComponentFields

	// Kustomization represents the kustomize build plan for holos to render.
	Kustomization: core.#KustomizeBuild
}

// Kubernetes provides a BuildPlan via the Output field which contains inline
// API Objects provided directly from CUE.
#Kubernetes: {
	#ComponentFields

	// Objects represents the kubernetes api objects for the Component.
	Objects: core.#KubernetesObjects
}

// ArgoConfig represents the ArgoCD GitOps configuration for a Component.
// Useful to define once at the root of the Platform configuration and reuse
// across all Components.
#ArgoConfig: {
	// Enabled causes holos to render an ArgoCD Application resource for GitOps if true.
	Enabled: bool & (true | *false)

	// ClusterName represents the cluster within the platform the Application
	// resource is intended for.
	ClusterName: string

	// DeployRoot represents the path from the git repository root to the `deploy`
	// rendering output directory.  Used as a prefix for the
	// Application.spec.source.path field.
	DeployRoot: string & (string | *".")

	// RepoURL represents the value passed to the Application.spec.source.repoURL
	// field.
	RepoURL: string

	// TargetRevision represents the value passed to the
	// Application.spec.source.targetRevision field.  Defaults to the branch named
	// main.
	TargetRevision: string & (string | *"main")

	// AppProject represents the ArgoCD Project to associate the Application with.
	AppProject: string & (string | *"default")
}

// Cluster represents a cluster managed by the Platform.
#Cluster: {
	// Name represents the cluster name, for example "east1", "west1", or
	// "management".
	name: string @go(Name)

	// Primary represents if the cluster is marked as the primary among a set of
	// candidate clusters.  Useful for promotion of database leaders.
	primary: bool & (true | *false) @go(Primary)
}

// Fleet represents a named collection of similarly configured Clusters.  Useful
// to segregate workload clusters from their management cluster.
#Fleet: {
	name: string @go(Name)

	// Clusters represents a mapping of Clusters by their name.
	clusters: {[string]: #Cluster} & {[Name=_]: name: Name} @go(Clusters,map[string]Cluster)
}

// StandardFleets represents the standard set of Clusters in a Platform
// segmented into Fleets by their purpose.  The management Fleet contains a
// single Cluster, for example a GKE autopilot cluster with no workloads
// deployed for reliability and cost efficiency.  The workload Fleet contains
// all other Clusters which contain workloads and sync Secrets from the
// management cluster.
#StandardFleets: {
	// Workload represents a Fleet of zero or more workload Clusters.
	workload: #Fleet & {name: "workload"} @go(Workload)

	// Management represents a Fleet with one Cluster named management.
	management: #Fleet & {name: "management"} @go(Management)
}

// Platform is a convenience structure to produce a core Platform specification
// value in the Output field.  Useful to collect components at the root of the
// Platform configuration tree as a struct, which are automatically converted
// into a list for the core Platform spec output.
#Platform: {
	// Name represents the Platform name.
	Name: string & (string | *"holos")

	// Components is a structured map of components to manage by their name.
	Components: {[string]: core.#PlatformSpecComponent} @go(,map[string]core.PlatformSpecComponent)

	// Model represents the Platform model holos gets from from the
	// PlatformService.GetPlatform rpc method and provides to CUE using a tag.
	Model: structpb.#Struct & {...}

	// Output represents the core Platform spec for the holos cli to iterate over
	// and render each listed Component, injecting the Model.
	Output: core.#Platform

	// Domain represents the primary domain the Platform operates in.  This field
	// is intended as a sensible default for component authors to reference and
	// platform operators to define.
	Domain: string & (string | *"holos.localhost")
}

// Organization represents organizational metadata useful across the platform.
#Organization: {
	Name:        string
	DisplayName: string
	Domain:      string
}

// OrganizationStrict represents organizational metadata useful across the
// platform.  This is an example of using CUE regular expressions to constrain
// and validate configuration.
#OrganizationStrict: {
	#Organization

	// Name represents the organization name as a resource name.  Must be 63
	// characters or less.  Must start with a letter.  May contain non-repeating
	// hyphens, letters, and numbers.  Must end with a letter or number.
	Name: string & (=~"^[a-z][0-9a-z-]{1,61}[0-9a-z]$" & !~"--")

	// DisplayName represents the human readable organization name.
	DisplayName: string & (=~"^[0-9A-Za-z][0-9A-Za-z ]{2,61}[0-9A-Za-z]$" & !~"  ")
}

// Projects represents projects managed by the platform team for use by other
// teams using the platform.
#Projects: {[string]: #Project}

// Project represents logical grouping of components owned by one or more teams.
// Useful for the platform team to manage resources for project teams to use.
#Project: {
	// Name represents project name.
	Name: string

	// Owner represents the team who own this project.
	Owner: #Owner

	// Namespaces represents the namespaces assigned to this project.
	Namespaces: {[string]: #Namespace} @go(,map[core.NameLabel]Namespace)

	// Hostnames represents the host names to expose for this project.
	Hostnames: {[string]: #Hostname} @go(,map[core.NameLabel]Hostname)
}

// Owner represents the owner of a resource.  For example, the name and email
// address of an engineering team.
#Owner: {
	Name:  string
	Email: string
}

// Namespace represents a Kubernetes namespace.
#Namespace: {
	Name: string
}

// Hostname represents the left most dns label of a domain name.
#Hostname: {
	// Name represents the subdomain to expose, e.g. "www"
	Name: string

	// Namespace represents the namespace metadata.name field of backend object
	// reference.
	Namespace: string

	// Service represents the Service metadata.name field of backend object
	// reference.
	Service: string
}