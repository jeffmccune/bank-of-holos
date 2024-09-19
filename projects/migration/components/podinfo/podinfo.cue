package holos

// highlight-next-line
import ks "sigs.k8s.io/kustomize/api/types"

// Produce a helm chart build plan.
// highlight-next-line
(#Helm & _Chart).BuildPlan

// highlight-next-line
_Chart: {
	Name:    "podinfo"
	Version: "6.6.2"
	// highlight-next-line
	Namespace: #Migration.Namespace

	// Necessary to ensure the resources go to the correct namespace.
	// highlight-next-line
	EnableKustomizePostProcessor: true
	// highlight-next-line
	KustomizeFiles: "kustomization.yaml": ks.#Kustomization & {
		namespace: Namespace
	}

	Repo: name: "podinfo"
	Repo: url:  "https://stefanprodan.github.io/podinfo"
}
