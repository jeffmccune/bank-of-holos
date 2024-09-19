package holos

// Manage on workload clusters only
for Cluster in #Fleets.workload.clusters {
	#Platform: Components: "\(Cluster.name)/podinfo": {
		path:    "projects/migration/components/podinfo"
		cluster: Cluster.name
	}
}
