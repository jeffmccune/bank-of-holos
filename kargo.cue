@if(!NoKargo && !NoArgoRollouts && !NoArgoCD)
package holos

#Kargo: {
	Namespace: string
	Values: {...}
}

Kargo: #Kargo & {
	Namespace: "kargo"

	// Holos specific kustomizations
	Values: #KargoValues & {
		// Istio handles mTLS for us.
		api: ingress: tls: enabled: false
		// Secret generated by the kargo-secrets holos component.
		api: secret: name: "admin-credentials"
	}
}

// Register namespaces and components with the project.
Projects: {
	argocd: {
		namespaces: (Kargo.Namespace): _
		_components: {
			"kargo-secrets": _
			"kargo":         _
		}
	}
}

// Register the HTTPRoute to the backend Service
HTTPRoutes: kargo: _backendRefs: "kargo-api": namespace: Kargo.Namespace