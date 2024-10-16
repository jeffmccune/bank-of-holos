package holos

#Values: {

	// +docs:section=Global
	// Default values for cert-manager.
	// This is a YAML-formatted file.
	// Declare variables to be passed into your templates.
	global: {
		// Reference to one or more secrets to be used when pulling images.
		// For more information, see [Pull an Image from a Private Registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/).
		//
		// For example:
		//  imagePullSecrets:
		//    - name: "image-pull-secret"
		imagePullSecrets: []

		// Labels to apply to all resources.
		// Please note that this does not add labels to the resources created dynamically by the controllers.
		// For these resources, you have to add the labels in the template in the cert-manager custom resource:
		// For example, podTemplate/ ingressTemplate in ACMEChallengeSolverHTTP01Ingress
		// For more information, see the [cert-manager documentation](https://cert-manager.io/docs/reference/api-docs/#acme.cert-manager.io/v1.ACMEChallengeSolverHTTP01Ingress).
		// For example, secretTemplate in CertificateSpec
		// For more information, see the [cert-manager documentation](https://cert-manager.io/docs/reference/api-docs/#cert-manager.io/v1.CertificateSpec).
		commonLabels: {}

		// The number of old ReplicaSets to retain to allow rollback (if not set, the default Kubernetes value is set to 10).
		// +docs:property
		// revisionHistoryLimit: 1
		// The optional priority class to be used for the cert-manager pods.
		priorityClassName: ""
		rbac: {
			// Create required ClusterRoles and ClusterRoleBindings for cert-manager.
			create: true
			// Aggregate ClusterRoles to Kubernetes default user-facing roles. For more information, see [User-facing roles](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#user-facing-roles)
			aggregateClusterRoles: true
		}
		podSecurityPolicy: {
			// Create PodSecurityPolicy for cert-manager.
			//
			// Note that PodSecurityPolicy was deprecated in Kubernetes 1.21 and removed in Kubernetes 1.25.
			enabled: false
			// Configure the PodSecurityPolicy to use AppArmor.
			useAppArmor: true
		}

		// Set the verbosity of cert-manager. A range of 0 - 6, with 6 being the most verbose.
		logLevel: 2
		leaderElection: {
			// Override the namespace used for the leader election lease.
			// The duration that non-leader candidates will wait after observing a
			// leadership renewal until attempting to acquire leadership of a led but
			// unrenewed leader slot. This is effectively the maximum duration that a
			// leader can be stopped before it is replaced by another candidate.
			// +docs:property
			// leaseDuration: 60s
			// The interval between attempts by the acting master to renew a leadership
			// slot before it stops leading. This must be less than or equal to the
			// lease duration.
			// +docs:property
			// renewDeadline: 40s
			// The duration the clients should wait between attempting acquisition and
			// renewal of a leadership.
			// +docs:property
			// retryPeriod: 15s
			namespace: string | *"kube-system"
		}
	}

	// This option is equivalent to setting crds.enabled=true and crds.keep=true.
	// Deprecated: use crds.enabled and crds.keep instead.
	installCRDs: *false | true
	crds: {
		// This option decides if the CRDs should be installed
		// as part of the Helm installation.
		enabled: *false | true

		// This option makes it so that the "helm.sh/resource-policy": keep
		// annotation is added to the CRD. This will prevent Helm from uninstalling
		// the CRD when the Helm release is uninstalled.
		// WARNING: when the CRDs are removed, all cert-manager custom resources
		// (Certificates, Issuers, ...) will be removed too by the garbage collector.
		keep: true
	}

	// +docs:section=Controller
	// The number of replicas of the cert-manager controller to run.
	//
	// The default is 1, but in production set this to 2 or 3 to provide high
	// availability.
	//
	// If `replicas > 1`, consider setting `podDisruptionBudget.enabled=true`.
	//
	// Note that cert-manager uses leader election to ensure that there can
	// only be a single instance active at a time.
	replicaCount: 1

	// Deployment update strategy for the cert-manager controller deployment.
	// For more information, see the [Kubernetes documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy).
	//
	// For example:
	//  strategy:
	//    type: RollingUpdate
	//    rollingUpdate:
	//      maxSurge: 0
	//      maxUnavailable: 1
	strategy: {}
	podDisruptionBudget: {
		// Enable or disable the PodDisruptionBudget resource.
		//
		// This prevents downtime during voluntary disruptions such as during a Node upgrade.
		// For example, the PodDisruptionBudget will block `kubectl drain`
		// if it is used on the Node where the only remaining cert-manager
		// Pod is currently running.
		// This configures the minimum available pods for disruptions. It can either be set to
		// an integer (e.g. 1) or a percentage value (e.g. 25%).
		// It cannot be used if `maxUnavailable` is set.
		// +docs:property
		// +docs:type=unknown
		// minAvailable: 1
		// This configures the maximum unavailable pods for disruptions. It can either be set to
		// an integer (e.g. 1) or a percentage value (e.g. 25%).
		// it cannot be used if `minAvailable` is set.
		// +docs:property
		// +docs:type=unknown
		// maxUnavailable: 1
		enabled: false
	}

	// A comma-separated list of feature gates that should be enabled on the
	// controller pod.
	featureGates: ""

	// The maximum number of challenges that can be scheduled as 'processing' at once.
	maxConcurrentChallenges: 60
	image: {

		// The container registry to pull the manager image from.
		// +docs:property
		// registry: quay.io
		// The container image for the cert-manager controller.
		// +docs:property
		repository: "quay.io/jetstack/cert-manager-controller"

		// Override the image tag to deploy by setting this variable.
		// If no value is set, the chart's appVersion is used.
		// +docs:property
		// tag: vX.Y.Z
		// Setting a digest will override any tag.
		// +docs:property
		// digest: sha256:0e072dddd1f7f8fc8909a2ca6f65e76c5f0d2fcfb8be47935ae3457e8bbceb20
		// Kubernetes imagePullPolicy on Deployment.
		pullPolicy: "IfNotPresent"
	}

	// Override the namespace used to store DNS provider credentials etc. for ClusterIssuer
	// resources. By default, the same namespace as cert-manager is deployed within is
	// used. This namespace will not be automatically created by the Helm chart.
	clusterResourceNamespace: ""

	// This namespace allows you to define where the services are installed into.
	// If not set then they use the namespace of the release.
	// This is helpful when installing cert manager as a chart dependency (sub chart).
	namespace: ""

	// Override the "cert-manager.fullname" value. This value is used as part of
	// most of the names of the resources created by this Helm chart.
	// +docs:property
	// fullnameOverride: "my-cert-manager"
	// Override the "cert-manager.name" value, which is used to annotate some of
	// the resources that are created by this Chart (using "app.kubernetes.io/name").
	// NOTE: There are some inconsistencies in the Helm chart when it comes to
	// these annotations (some resources use eg. "cainjector.name" which resolves
	// to the value "cainjector").
	// +docs:property
	// nameOverride: "my-cert-manager"
	serviceAccount: {
		// Specifies whether a service account should be created.
		create: true

		// The name of the service account to use.
		// If not set and create is true, a name is generated using the fullname template.
		// +docs:property
		// name: ""
		// Optional additional annotations to add to the controller's Service Account.
		// +docs:property
		// annotations: {}
		// Optional additional labels to add to the controller's Service Account.
		// +docs:property
		// labels: {}
		// Automount API credentials for a Service Account.
		automountServiceAccountToken: true
	}

	// Automounting API credentials for a particular pod.
	// +docs:property
	// automountServiceAccountToken: true
	// When this flag is enabled, secrets will be automatically removed when the certificate resource is deleted.
	enableCertificateOwnerRef: false

	// This property is used to configure options for the controller pod.
	// This allows setting options that would usually be provided using flags.
	//
	// If `apiVersion` and `kind` are unspecified they default to the current latest
	// version (currently `controller.config.cert-manager.io/v1alpha1`). You can pin
	// the version by specifying the `apiVersion` yourself.
	//
	// For example:
	//  config:
	//    apiVersion: controller.config.cert-manager.io/v1alpha1
	//    kind: ControllerConfiguration
	//    logging:
	//      verbosity: 2
	//      format: text
	//    leaderElectionConfig:
	//      namespace: kube-system
	//    kubernetesAPIQPS: 9000
	//    kubernetesAPIBurst: 9000
	//    numberOfConcurrentWorkers: 200
	//    featureGates:
	//      AdditionalCertificateOutputFormats: true
	//      DisallowInsecureCSRUsageDefinition: true
	//      ExperimentalCertificateSigningRequestControllers: true
	//      ExperimentalGatewayAPISupport: true
	//      LiteralCertificateSubject: true
	//      SecretsFilteredCaching: true
	//      ServerSideApply: true
	//      StableCertificateRequestName: true
	//      UseCertificateRequestBasicConstraints: true
	//      ValidateCAA: true
	//    # Configure the metrics server for TLS
	//    # See https://cert-manager.io/docs/devops-tips/prometheus-metrics/#tls
	//    metricsTLSConfig:
	//      dynamic:
	//        secretNamespace: "cert-manager"
	//        secretName: "cert-manager-metrics-ca"
	//        dnsNames:
	//        - cert-manager-metrics
	config: {}

	// Setting Nameservers for DNS01 Self Check.
	// For more information, see the [cert-manager documentation](https://cert-manager.io/docs/configuration/acme/dns01/#setting-nameservers-for-dns01-self-check).
	// A comma-separated string with the host and port of the recursive nameservers cert-manager should query.
	dns01RecursiveNameservers: ""

	// Forces cert-manager to use only the recursive nameservers for verification.
	// Enabling this option could cause the DNS01 self check to take longer owing to caching performed by the recursive nameservers.
	dns01RecursiveNameserversOnly: false

	// Option to disable cert-manager's build-in auto-approver. The auto-approver
	// approves all CertificateRequests that reference issuers matching the 'approveSignerNames'
	// option. This 'disableAutoApproval' option is useful when you want to make all approval decisions
	// using a different approver (like approver-policy - https://github.com/cert-manager/approver-policy).
	disableAutoApproval: false

	// List of signer names that cert-manager will approve by default. CertificateRequests
	// referencing these signer names will be auto-approved by cert-manager. Defaults to just
	// approving the cert-manager.io Issuer and ClusterIssuer issuers. When set to an empty
	// array, ALL issuers will be auto-approved by cert-manager. To disable the auto-approval,
	// because eg. you are using approver-policy, you can enable 'disableAutoApproval'.
	// ref: https://cert-manager.io/docs/concepts/certificaterequest/#approval
	// +docs:property
	approveSignerNames: [
		"issuers.cert-manager.io/*",
		"clusterissuers.cert-manager.io/*",
	]

	// Additional command line flags to pass to cert-manager controller binary.
	// To see all available flags run `docker run quay.io/jetstack/cert-manager-controller:<version> --help`.
	//
	// Use this flag to enable or disable arbitrary controllers. For example, to disable the CertificateRequests approver.
	//
	// For example:
	//  extraArgs:
	//    - --controllers=*,-certificaterequests-approver
	extraArgs: []

	// Additional environment variables to pass to cert-manager controller binary.
	// For example:
	//  extraEnv:
	//  - name: SOME_VAR
	//    value: 'some value'
	extraEnv: []

	// Resources to provide to the cert-manager controller pod.
	//
	// For example:
	//  requests:
	//    cpu: 10m
	//    memory: 32Mi
	//
	// For more information, see [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).
	resources: {}

	// Pod Security Context.
	// For more information, see [Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).
	// +docs:property
	securityContext: {
		runAsNonRoot: true
		seccompProfile: type: "RuntimeDefault"
	}

	// Container Security Context to be set on the controller component container.
	// For more information, see [Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).
	// +docs:property
	containerSecurityContext: {
		allowPrivilegeEscalation: false
		capabilities: drop: ["ALL"]
		readOnlyRootFilesystem: true
	}

	// Additional volumes to add to the cert-manager controller pod.
	volumes: []

	// Additional volume mounts to add to the cert-manager controller container.
	volumeMounts: []

	// Optional additional annotations to add to the controller Deployment.
	// +docs:property
	// deploymentAnnotations: {}
	// Optional additional annotations to add to the controller Pods.
	// +docs:property
	// podAnnotations: {}
	// Optional additional labels to add to the controller Pods.
	podLabels: {}

	// Optional annotations to add to the controller Service.
	// +docs:property
	// serviceAnnotations: {}
	// Optional additional labels to add to the controller Service.
	// +docs:property
	// serviceLabels: {}
	// Optionally set the IP family policy for the controller Service to configure dual-stack; see [Configure dual-stack](https://kubernetes.io/docs/concepts/services-networking/dual-stack/#services).
	// +docs:property
	// serviceIPFamilyPolicy: ""
	// Optionally set the IP families for the controller Service that should be supported, in the order in which they should be applied to ClusterIP. Can be IPv4 and/or IPv6.
	// +docs:property
	// serviceIPFamilies: []
	// Optional DNS settings. These are useful if you have a public and private DNS zone for
	// the same domain on Route 53. The following is an example of ensuring
	// cert-manager can access an ingress or DNS TXT records at all times.
	// Note that this requires Kubernetes 1.10 or `CustomPodDNS` feature gate enabled for
	// the cluster to work.
	// Pod DNS policy.
	// For more information, see [Pod's DNS Policy](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-s-dns-policy).
	// +docs:property
	// podDnsPolicy: "None"
	// Pod DNS configuration. The podDnsConfig field is optional and can work with any podDnsPolicy
	// settings. However, when a Pod's dnsPolicy is set to "None", the dnsConfig field has to be specified.
	// For more information, see [Pod's DNS Config](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#pod-dns-config).
	// +docs:property
	// podDnsConfig:
	//   nameservers:
	//     - "1.1.1.1"
	//     - "8.8.8.8"
	// Optional hostAliases for cert-manager-controller pods. May be useful when performing ACME DNS-01 self checks.
	// - ip: 127.0.0.1
	//   hostnames:
	//   - foo.local
	//   - bar.local
	// - ip: 10.1.2.3
	//   hostnames:
	//   - foo.remote
	//   - bar.remote
	hostAliases: []

	// The nodeSelector on Pods tells Kubernetes to schedule Pods on the nodes with
	// matching labels.
	// For more information, see [Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/).
	//
	// This default ensures that Pods are only scheduled to Linux nodes.
	// It prevents Pods being scheduled to Windows nodes in a mixed OS cluster.
	// +docs:property
	nodeSelector: {
		"kubernetes.io/os": "linux"
	}

	// +docs:ignore
	ingressShim: {}

	// Optional default issuer to use for ingress resources.
	// +docs:property=ingressShim.defaultIssuerName
	// defaultIssuerName: ""
	// Optional default issuer kind to use for ingress resources.
	// +docs:property=ingressShim.defaultIssuerKind
	// defaultIssuerKind: ""
	// Optional default issuer group to use for ingress resources.
	// +docs:property=ingressShim.defaultIssuerGroup
	// defaultIssuerGroup: ""
	// Use these variables to configure the HTTP_PROXY environment variables.
	// Configures the HTTP_PROXY environment variable where a HTTP proxy is required.
	// +docs:property
	// http_proxy: "http://proxy:8080"
	// Configures the HTTPS_PROXY environment variable where a HTTP proxy is required.
	// +docs:property
	// https_proxy: "https://proxy:8080"
	// Configures the NO_PROXY environment variable where a HTTP proxy is required,
	// but certain domains should be excluded.
	// +docs:property
	// no_proxy: 127.0.0.1,localhost
	// A Kubernetes Affinity, if required. For more information, see [Affinity v1 core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#affinity-v1-core).
	//
	// For example:
	//   affinity:
	//     nodeAffinity:
	//      requiredDuringSchedulingIgnoredDuringExecution:
	//        nodeSelectorTerms:
	//        - matchExpressions:
	//          - key: foo.bar.com/role
	//            operator: In
	//            values:
	//            - master
	affinity: {}

	// A list of Kubernetes Tolerations, if required. For more information, see [Toleration v1 core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#toleration-v1-core).
	//
	// For example:
	//   tolerations:
	//   - key: foo.bar.com/role
	//     operator: Equal
	//     value: master
	//     effect: NoSchedule
	tolerations: []

	// A list of Kubernetes TopologySpreadConstraints, if required. For more information, see [Topology spread constraint v1 core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#topologyspreadconstraint-v1-core
	//
	// For example:
	//   topologySpreadConstraints:
	//   - maxSkew: 2
	//     topologyKey: topology.kubernetes.io/zone
	//     whenUnsatisfiable: ScheduleAnyway
	//     labelSelector:
	//       matchLabels:
	//         app.kubernetes.io/instance: cert-manager
	//         app.kubernetes.io/component: controller
	topologySpreadConstraints: []

	// LivenessProbe settings for the controller container of the controller Pod.
	//
	// This is enabled by default, in order to enable the clock-skew liveness probe that
	// restarts the controller in case of a skew between the system clock and the monotonic clock.
	// LivenessProbe durations and thresholds are based on those used for the Kubernetes
	// controller-manager. For more information see the following on the
	// [Kubernetes GitHub repository](https://github.com/kubernetes/kubernetes/blob/806b30170c61a38fedd54cc9ede4cd6275a1ad3b/cmd/kubeadm/app/util/staticpod/utils.go#L241-L245)
	// +docs:property
	livenessProbe: {
		enabled:             true
		initialDelaySeconds: 10
		periodSeconds:       10
		timeoutSeconds:      15
		successThreshold:    1
		failureThreshold:    8
	}

	// enableServiceLinks indicates whether information about services should be
	// injected into the pod's environment variables, matching the syntax of Docker
	// links.
	enableServiceLinks: false

	// +docs:section=Prometheus
	prometheus: {
		// Enable Prometheus monitoring for the cert-manager controller and webhook.
		// If you use the Prometheus Operator, set prometheus.podmonitor.enabled or
		// prometheus.servicemonitor.enabled, to create a PodMonitor or a
		// ServiceMonitor resource.
		// Otherwise, 'prometheus.io' annotations are added to the cert-manager and
		// cert-manager-webhook Deployments.
		// Note that you can not enable both PodMonitor and ServiceMonitor as they are
		// mutually exclusive. Enabling both will result in an error.
		enabled: true
		servicemonitor: {
			// Create a ServiceMonitor to add cert-manager to Prometheus.
			enabled: false

			// The namespace that the service monitor should live in, defaults
			// to the cert-manager namespace.
			// +docs:property
			// namespace: cert-manager
			// Specifies the `prometheus` label on the created ServiceMonitor. This is
			// used when different Prometheus instances have label selectors matching
			// different ServiceMonitors.
			prometheusInstance: "default"

			// The target port to set on the ServiceMonitor. This must match the port that the
			// cert-manager controller is listening on for metrics.
			targetPort: 9402

			// The path to scrape for metrics.
			path: "/metrics"

			// The interval to scrape metrics.
			interval: "60s"

			// The timeout before a metrics scrape fails.
			scrapeTimeout: "30s"

			// Additional labels to add to the ServiceMonitor.
			labels: {}

			// Additional annotations to add to the ServiceMonitor.
			annotations: {}

			// Keep labels from scraped data, overriding server-side labels.
			honorLabels: false

			// EndpointAdditionalProperties allows setting additional properties on the
			// endpoint such as relabelings, metricRelabelings etc.
			//
			// For example:
			//  endpointAdditionalProperties:
			//   relabelings:
			//   - action: replace
			//     sourceLabels:
			//     - __meta_kubernetes_pod_node_name
			//     targetLabel: instance
			//
			// +docs:property
			endpointAdditionalProperties: {}
		}

		// Note that you can not enable both PodMonitor and ServiceMonitor as they are mutually exclusive. Enabling both will result in an error.
		podmonitor: {
			// Create a PodMonitor to add cert-manager to Prometheus.
			enabled: false

			// The namespace that the pod monitor should live in, defaults
			// to the cert-manager namespace.
			// +docs:property
			// namespace: cert-manager
			// Specifies the `prometheus` label on the created PodMonitor. This is
			// used when different Prometheus instances have label selectors matching
			// different PodMonitors.
			prometheusInstance: "default"

			// The path to scrape for metrics.
			path: "/metrics"

			// The interval to scrape metrics.
			interval: "60s"

			// The timeout before a metrics scrape fails.
			scrapeTimeout: "30s"

			// Additional labels to add to the PodMonitor.
			labels: {}

			// Additional annotations to add to the PodMonitor.
			annotations: {}

			// Keep labels from scraped data, overriding server-side labels.
			honorLabels: false

			// EndpointAdditionalProperties allows setting additional properties on the
			// endpoint such as relabelings, metricRelabelings etc.
			//
			// For example:
			//  endpointAdditionalProperties:
			//   relabelings:
			//   - action: replace
			//     sourceLabels:
			//     - __meta_kubernetes_pod_node_name
			//     targetLabel: instance
			//   # Configure the PodMonitor for TLS connections
			//   # See https://cert-manager.io/docs/devops-tips/prometheus-metrics/#tls
			//   scheme: https
			//   tlsConfig:
			//     serverName: cert-manager-metrics
			//     ca:
			//       secret:
			//         name: cert-manager-metrics-ca
			//         key: "tls.crt"
			//
			// +docs:property
			endpointAdditionalProperties: {}
		}
	}

	// +docs:section=Webhook
	webhook: {
		// Number of replicas of the cert-manager webhook to run.
		//
		// The default is 1, but in production set this to 2 or 3 to provide high
		// availability.
		//
		// If `replicas > 1`, consider setting `webhook.podDisruptionBudget.enabled=true`.
		replicaCount: 1

		// The number of seconds the API server should wait for the webhook to respond before treating the call as a failure.
		// The value must be between 1 and 30 seconds. For more information, see
		// [Validating webhook configuration v1](https://kubernetes.io/docs/reference/kubernetes-api/extend-resources/validating-webhook-configuration-v1/).
		//
		// The default is set to the maximum value of 30 seconds as
		// users sometimes report that the connection between the K8S API server and
		// the cert-manager webhook server times out.
		// If *this* timeout is reached, the error message will be "context deadline exceeded",
		// which doesn't help the user diagnose what phase of the HTTPS connection timed out.
		// For example, it could be during DNS resolution, TCP connection, TLS
		// negotiation, HTTP negotiation, or slow HTTP response from the webhook
		// server.
		// By setting this timeout to its maximum value the underlying timeout error
		// message has more chance of being returned to the end user.
		timeoutSeconds: 30

		// This is used to configure options for the webhook pod.
		// This allows setting options that would usually be provided using flags.
		//
		// If `apiVersion` and `kind` are unspecified they default to the current latest
		// version (currently `webhook.config.cert-manager.io/v1alpha1`). You can pin
		// the version by specifying the `apiVersion` yourself.
		//
		// For example:
		//  apiVersion: webhook.config.cert-manager.io/v1alpha1
		//  kind: WebhookConfiguration
		//  # The port that the webhook listens on for requests.
		//  # In GKE private clusters, by default Kubernetes apiservers are allowed to
		//  # talk to the cluster nodes only on 443 and 10250. Configuring
		//  # securePort: 10250 therefore will work out-of-the-box without needing to add firewall
		//  # rules or requiring NET_BIND_SERVICE capabilities to bind port numbers < 1000.
		//  # This should be uncommented and set as a default by the chart once
		//  # the apiVersion of WebhookConfiguration graduates beyond v1alpha1.
		//  securePort: 10250
		//  # Configure the metrics server for TLS
		//  # See https://cert-manager.io/docs/devops-tips/prometheus-metrics/#tls
		//  metricsTLSConfig:
		//    dynamic:
		//      secretNamespace: "cert-manager"
		//      secretName: "cert-manager-metrics-ca"
		//      dnsNames:
		//      - cert-manager-metrics
		config: {}

		// The update strategy for the cert-manager webhook deployment.
		// For more information, see the [Kubernetes documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy)
		//
		// For example:
		//  strategy:
		//    type: RollingUpdate
		//    rollingUpdate:
		//      maxSurge: 0
		//      maxUnavailable: 1
		strategy: {}

		// Pod Security Context to be set on the webhook component Pod.
		// For more information, see [Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).
		// +docs:property
		securityContext: {
			runAsNonRoot: true
			seccompProfile: type: "RuntimeDefault"
		}

		// Container Security Context to be set on the webhook component container.
		// For more information, see [Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).
		// +docs:property
		containerSecurityContext: {
			allowPrivilegeEscalation: false
			capabilities: drop: ["ALL"]
			readOnlyRootFilesystem: true
		}
		podDisruptionBudget: {
			// Enable or disable the PodDisruptionBudget resource.
			//
			// This prevents downtime during voluntary disruptions such as during a Node upgrade.
			// For example, the PodDisruptionBudget will block `kubectl drain`
			// if it is used on the Node where the only remaining cert-manager
			// Pod is currently running.
			// This property configures the minimum available pods for disruptions. Can either be set to
			// an integer (e.g. 1) or a percentage value (e.g. 25%).
			// It cannot be used if `maxUnavailable` is set.
			// +docs:property
			// +docs:type=unknown
			// minAvailable: 1
			// This property configures the maximum unavailable pods for disruptions. Can either be set to
			// an integer (e.g. 1) or a percentage value (e.g. 25%).
			// It cannot be used if `minAvailable` is set.
			// +docs:property
			// +docs:type=unknown
			// maxUnavailable: 1
			enabled: false
		}

		// Optional additional annotations to add to the webhook Deployment.
		// +docs:property
		// deploymentAnnotations: {}
		// Optional additional annotations to add to the webhook Pods.
		// +docs:property
		// podAnnotations: {}
		// Optional additional annotations to add to the webhook Service.
		// +docs:property
		// serviceAnnotations: {}
		// Optional additional annotations to add to the webhook MutatingWebhookConfiguration.
		// +docs:property
		// mutatingWebhookConfigurationAnnotations: {}
		// Optional additional annotations to add to the webhook ValidatingWebhookConfiguration.
		// +docs:property
		// validatingWebhookConfigurationAnnotations: {}
		validatingWebhookConfiguration: {
			// Configure spec.namespaceSelector for validating webhooks.
			// +docs:property
			namespaceSelector: {
				matchExpressions: [{
					key:      "cert-manager.io/disable-validation"
					operator: "NotIn"
					values: ["true"]
				}]
			}
		}
		mutatingWebhookConfiguration: {
			// Configure spec.namespaceSelector for mutating webhooks.
			// +docs:property
			//  matchLabels:
			//    key: value
			//  matchExpressions:
			//    - key: kubernetes.io/metadata.name
			//      operator: NotIn
			//      values:
			//        - kube-system
			namespaceSelector: {}}

		// Additional command line flags to pass to cert-manager webhook binary.
		// To see all available flags run `docker run quay.io/jetstack/cert-manager-webhook:<version> --help`.
		// Path to a file containing a WebhookConfiguration object used to configure the webhook.
		// - --config=<path-to-config-file>
		extraArgs: []

		// Additional environment variables to pass to cert-manager webhook binary.
		// For example:
		//  extraEnv:
		//  - name: SOME_VAR
		//    value: 'some value'
		extraEnv: []

		// Comma separated list of feature gates that should be enabled on the
		// webhook pod.
		featureGates: ""

		// Resources to provide to the cert-manager webhook pod.
		//
		// For example:
		//  requests:
		//    cpu: 10m
		//    memory: 32Mi
		//
		// For more information, see [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).
		resources: {}

		// Liveness probe values.
		// For more information, see [Container probes](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes).
		//
		// +docs:property
		livenessProbe: {
			failureThreshold:    3
			initialDelaySeconds: 60
			periodSeconds:       10
			successThreshold:    1
			timeoutSeconds:      1
		}

		// Readiness probe values.
		// For more information, see [Container probes](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes).
		//
		// +docs:property
		readinessProbe: {
			failureThreshold:    3
			initialDelaySeconds: 5
			periodSeconds:       5
			successThreshold:    1
			timeoutSeconds:      1
		}

		// The nodeSelector on Pods tells Kubernetes to schedule Pods on the nodes with
		// matching labels.
		// For more information, see [Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/).
		//
		// This default ensures that Pods are only scheduled to Linux nodes.
		// It prevents Pods being scheduled to Windows nodes in a mixed OS cluster.
		// +docs:property
		nodeSelector: {
			"kubernetes.io/os": "linux"
		}

		// A Kubernetes Affinity, if required. For more information, see [Affinity v1 core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#affinity-v1-core).
		//
		// For example:
		//   affinity:
		//     nodeAffinity:
		//      requiredDuringSchedulingIgnoredDuringExecution:
		//        nodeSelectorTerms:
		//        - matchExpressions:
		//          - key: foo.bar.com/role
		//            operator: In
		//            values:
		//            - master
		affinity: {}

		// A list of Kubernetes Tolerations, if required. For more information, see [Toleration v1 core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#toleration-v1-core).
		//
		// For example:
		//   tolerations:
		//   - key: foo.bar.com/role
		//     operator: Equal
		//     value: master
		//     effect: NoSchedule
		tolerations: []

		// A list of Kubernetes TopologySpreadConstraints, if required. For more information, see [Topology spread constraint v1 core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#topologyspreadconstraint-v1-core).
		//
		// For example:
		//   topologySpreadConstraints:
		//   - maxSkew: 2
		//     topologyKey: topology.kubernetes.io/zone
		//     whenUnsatisfiable: ScheduleAnyway
		//     labelSelector:
		//       matchLabels:
		//         app.kubernetes.io/instance: cert-manager
		//         app.kubernetes.io/component: controller
		topologySpreadConstraints: []

		// Optional additional labels to add to the Webhook Pods.
		podLabels: {}

		// Optional additional labels to add to the Webhook Service.
		serviceLabels: {}

		// Optionally set the IP family policy for the controller Service to configure dual-stack; see [Configure dual-stack](https://kubernetes.io/docs/concepts/services-networking/dual-stack/#services).
		serviceIPFamilyPolicy: ""

		// Optionally set the IP families for the controller Service that should be supported, in the order in which they should be applied to ClusterIP. Can be IPv4 and/or IPv6.
		serviceIPFamilies: []
		image: {

			// The container registry to pull the webhook image from.
			// +docs:property
			// registry: quay.io
			// The container image for the cert-manager webhook
			// +docs:property
			repository: "quay.io/jetstack/cert-manager-webhook"

			// Override the image tag to deploy by setting this variable.
			// If no value is set, the chart's appVersion will be used.
			// +docs:property
			// tag: vX.Y.Z
			// Setting a digest will override any tag
			// +docs:property
			// digest: sha256:0e072dddd1f7f8fc8909a2ca6f65e76c5f0d2fcfb8be47935ae3457e8bbceb20
			// Kubernetes imagePullPolicy on Deployment.
			pullPolicy: "IfNotPresent"
		}
		serviceAccount: {
			// Specifies whether a service account should be created.
			create: true

			// The name of the service account to use.
			// If not set and create is true, a name is generated using the fullname template.
			// +docs:property
			// name: ""
			// Optional additional annotations to add to the webhook's Service Account.
			// +docs:property
			// annotations: {}
			// Optional additional labels to add to the webhook's Service Account.
			// +docs:property
			// labels: {}
			// Automount API credentials for a Service Account.
			automountServiceAccountToken: true
		}

		// Automounting API credentials for a particular pod.
		// +docs:property
		// automountServiceAccountToken: true
		// The port that the webhook listens on for requests.
		// In GKE private clusters, by default Kubernetes apiservers are allowed to
		// talk to the cluster nodes only on 443 and 10250. Configuring
		// securePort: 10250, therefore will work out-of-the-box without needing to add firewall
		// rules or requiring NET_BIND_SERVICE capabilities to bind port numbers <1000.
		securePort: 10250

		// Specifies if the webhook should be started in hostNetwork mode.
		//
		// Required for use in some managed kubernetes clusters (such as AWS EKS) with custom
		// CNI (such as calico), because control-plane managed by AWS cannot communicate
		// with pods' IP CIDR and admission webhooks are not working
		//
		// Since the default port for the webhook conflicts with kubelet on the host
		// network, `webhook.securePort` should be changed to an available port if
		// running in hostNetwork mode.
		hostNetwork: false

		// Specifies how the service should be handled. Useful if you want to expose the
		// webhook outside of the cluster. In some cases, the control plane cannot
		// reach internal services.
		serviceType: "ClusterIP"

		// Specify the load balancer IP for the created service.
		// +docs:property
		// loadBalancerIP: "10.10.10.10"
		// Overrides the mutating webhook and validating webhook so they reach the webhook
		// service using the `url` field instead of a service.
		// host:
		url: {}

		// Enables default network policies for webhooks.
		networkPolicy: {
			// Create network policies for the webhooks.
			enabled: false

			// Ingress rule for the webhook network policy. By default, it allows all
			// inbound traffic.
			// +docs:property
			ingress: [{
				from: [{
					ipBlock: cidr: "0.0.0.0/0"
				}]
			}]

			// Egress rule for the webhook network policy. By default, it allows all
			// outbound traffic to ports 80 and 443, as well as DNS ports.
			// +docs:property
			egress: [{
				ports: [{
					port:     80
					protocol: "TCP"
				}, {
					port:     443
					protocol: "TCP"
				}, {
					port:     53
					protocol: "TCP"
				}, {
					port:     53
					protocol: "UDP"
				}, {
					// On OpenShift and OKD, the Kubernetes API server listens on.
					// port 6443.
					port:     6443
					protocol: "TCP"
				}]
				to: [{
					ipBlock: cidr: "0.0.0.0/0"
				}]
			}]
		}

		// Additional volumes to add to the cert-manager controller pod.
		volumes: []

		// Additional volume mounts to add to the cert-manager controller container.
		volumeMounts: []

		// enableServiceLinks indicates whether information about services should be
		// injected into the pod's environment variables, matching the syntax of Docker
		// links.
		enableServiceLinks: false
	}

	// +docs:section=CA Injector
	cainjector: {
		// Create the CA Injector deployment
		enabled: true

		// The number of replicas of the cert-manager cainjector to run.
		//
		// The default is 1, but in production set this to 2 or 3 to provide high
		// availability.
		//
		// If `replicas > 1`, consider setting `cainjector.podDisruptionBudget.enabled=true`.
		//
		// Note that cert-manager uses leader election to ensure that there can
		// only be a single instance active at a time.
		replicaCount: 1

		// This is used to configure options for the cainjector pod.
		// It allows setting options that are usually provided via flags.
		//
		// If `apiVersion` and `kind` are unspecified they default to the current latest
		// version (currently `cainjector.config.cert-manager.io/v1alpha1`). You can pin
		// the version by specifying the `apiVersion` yourself.
		//
		// For example:
		//  apiVersion: cainjector.config.cert-manager.io/v1alpha1
		//  kind: CAInjectorConfiguration
		//  logging:
		//   verbosity: 2
		//   format: text
		//  leaderElectionConfig:
		//   namespace: kube-system
		//  # Configure the metrics server for TLS
		//  # See https://cert-manager.io/docs/devops-tips/prometheus-metrics/#tls
		//  metricsTLSConfig:
		//    dynamic:
		//      secretNamespace: "cert-manager"
		//      secretName: "cert-manager-metrics-ca"
		//      dnsNames:
		//      - cert-manager-metrics
		config: {}

		// Deployment update strategy for the cert-manager cainjector deployment.
		// For more information, see the [Kubernetes documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy).
		//
		// For example:
		//  strategy:
		//    type: RollingUpdate
		//    rollingUpdate:
		//      maxSurge: 0
		//      maxUnavailable: 1
		strategy: {}

		// Pod Security Context to be set on the cainjector component Pod
		// For more information, see [Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).
		// +docs:property
		securityContext: {
			runAsNonRoot: true
			seccompProfile: type: "RuntimeDefault"
		}

		// Container Security Context to be set on the cainjector component container
		// For more information, see [Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).
		// +docs:property
		containerSecurityContext: {
			allowPrivilegeEscalation: false
			capabilities: drop: ["ALL"]
			readOnlyRootFilesystem: true
		}
		podDisruptionBudget: {
			// Enable or disable the PodDisruptionBudget resource.
			//
			// This prevents downtime during voluntary disruptions such as during a Node upgrade.
			// For example, the PodDisruptionBudget will block `kubectl drain`
			// if it is used on the Node where the only remaining cert-manager
			// Pod is currently running.
			// `minAvailable` configures the minimum available pods for disruptions. It can either be set to
			// an integer (e.g. 1) or a percentage value (e.g. 25%).
			// Cannot be used if `maxUnavailable` is set.
			// +docs:property
			// +docs:type=unknown
			// minAvailable: 1
			// `maxUnavailable` configures the maximum unavailable pods for disruptions. It can either be set to
			// an integer (e.g. 1) or a percentage value (e.g. 25%).
			// Cannot be used if `minAvailable` is set.
			// +docs:property
			// +docs:type=unknown
			// maxUnavailable: 1
			enabled: false
		}

		// Optional additional annotations to add to the cainjector Deployment.
		// +docs:property
		// deploymentAnnotations: {}
		// Optional additional annotations to add to the cainjector Pods.
		// +docs:property
		// podAnnotations: {}
		// Optional additional annotations to add to the cainjector metrics Service.
		// +docs:property
		// serviceAnnotations: {}
		// Additional command line flags to pass to cert-manager cainjector binary.
		// To see all available flags run `docker run quay.io/jetstack/cert-manager-cainjector:<version> --help`.
		// Enable profiling for cainjector.
		// - --enable-profiling=true
		extraArgs: []

		// Additional environment variables to pass to cert-manager cainjector binary.
		// For example:
		//  extraEnv:
		//  - name: SOME_VAR
		//    value: 'some value'
		extraEnv: []

		// Comma separated list of feature gates that should be enabled on the
		// cainjector pod.
		featureGates: ""

		// Resources to provide to the cert-manager cainjector pod.
		//
		// For example:
		//  requests:
		//    cpu: 10m
		//    memory: 32Mi
		//
		// For more information, see [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).
		resources: {}

		// The nodeSelector on Pods tells Kubernetes to schedule Pods on the nodes with
		// matching labels.
		// For more information, see [Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/).
		//
		// This default ensures that Pods are only scheduled to Linux nodes.
		// It prevents Pods being scheduled to Windows nodes in a mixed OS cluster.
		// +docs:property
		nodeSelector: {
			"kubernetes.io/os": "linux"
		}

		// A Kubernetes Affinity, if required. For more information, see [Affinity v1 core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#affinity-v1-core).
		//
		// For example:
		//   affinity:
		//     nodeAffinity:
		//      requiredDuringSchedulingIgnoredDuringExecution:
		//        nodeSelectorTerms:
		//        - matchExpressions:
		//          - key: foo.bar.com/role
		//            operator: In
		//            values:
		//            - master
		affinity: {}

		// A list of Kubernetes Tolerations, if required. For more information, see [Toleration v1 core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#toleration-v1-core).
		//
		// For example:
		//   tolerations:
		//   - key: foo.bar.com/role
		//     operator: Equal
		//     value: master
		//     effect: NoSchedule
		tolerations: []

		// A list of Kubernetes TopologySpreadConstraints, if required. For more information, see [Topology spread constraint v1 core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#topologyspreadconstraint-v1-core).
		//
		// For example:
		//   topologySpreadConstraints:
		//   - maxSkew: 2
		//     topologyKey: topology.kubernetes.io/zone
		//     whenUnsatisfiable: ScheduleAnyway
		//     labelSelector:
		//       matchLabels:
		//         app.kubernetes.io/instance: cert-manager
		//         app.kubernetes.io/component: controller
		topologySpreadConstraints: []

		// Optional additional labels to add to the CA Injector Pods.
		podLabels: {}

		// Optional additional labels to add to the CA Injector metrics Service.
		serviceLabels: {}
		image: {

			// The container registry to pull the cainjector image from.
			// +docs:property
			// registry: quay.io
			// The container image for the cert-manager cainjector
			// +docs:property
			repository: "quay.io/jetstack/cert-manager-cainjector"

			// Override the image tag to deploy by setting this variable.
			// If no value is set, the chart's appVersion will be used.
			// +docs:property
			// tag: vX.Y.Z
			// Setting a digest will override any tag.
			// +docs:property
			// digest: sha256:0e072dddd1f7f8fc8909a2ca6f65e76c5f0d2fcfb8be47935ae3457e8bbceb20
			// Kubernetes imagePullPolicy on Deployment.
			pullPolicy: "IfNotPresent"
		}
		serviceAccount: {
			// Specifies whether a service account should be created.
			create: true

			// The name of the service account to use.
			// If not set and create is true, a name is generated using the fullname template
			// +docs:property
			// name: ""
			// Optional additional annotations to add to the cainjector's Service Account.
			// +docs:property
			// annotations: {}
			// Optional additional labels to add to the cainjector's Service Account.
			// +docs:property
			// labels: {}
			// Automount API credentials for a Service Account.
			automountServiceAccountToken: true
		}

		// Automounting API credentials for a particular pod.
		// +docs:property
		// automountServiceAccountToken: true
		// Additional volumes to add to the cert-manager controller pod.
		volumes: []

		// Additional volume mounts to add to the cert-manager controller container.
		volumeMounts: []

		// enableServiceLinks indicates whether information about services should be
		// injected into the pod's environment variables, matching the syntax of Docker
		// links.
		enableServiceLinks: false
	}

	// +docs:section=ACME Solver
	acmesolver: {
		image: {

			// The container registry to pull the acmesolver image from.
			// +docs:property
			// registry: quay.io
			// The container image for the cert-manager acmesolver.
			// +docs:property
			repository: "quay.io/jetstack/cert-manager-acmesolver"

			// Override the image tag to deploy by setting this variable.
			// If no value is set, the chart's appVersion is used.
			// +docs:property
			// tag: vX.Y.Z
			// Setting a digest will override any tag.
			// +docs:property
			// digest: sha256:0e072dddd1f7f8fc8909a2ca6f65e76c5f0d2fcfb8be47935ae3457e8bbceb20
			// Kubernetes imagePullPolicy on Deployment.
			pullPolicy: "IfNotPresent"
		}
	}

	// +docs:section=Startup API Check
	// This startupapicheck is a Helm post-install hook that waits for the webhook
	// endpoints to become available.
	// The check is implemented using a Kubernetes Job - if you are injecting mesh
	// sidecar proxies into cert-manager pods, ensure that they
	// are not injected into this Job's pod. Otherwise, the installation may time out
	// owing to the Job never being completed because the sidecar proxy does not exit.
	// For more information, see [this note](https://github.com/cert-manager/cert-manager/pull/4414).
	startupapicheck: {
		// Enables the startup api check.
		enabled: *true | false

		// Pod Security Context to be set on the startupapicheck component Pod.
		// For more information, see [Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).
		// +docs:property
		securityContext: {
			runAsNonRoot: true
			seccompProfile: type: "RuntimeDefault"
		}

		// Container Security Context to be set on the controller component container.
		// For more information, see [Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).
		// +docs:property
		containerSecurityContext: {
			allowPrivilegeEscalation: false
			capabilities: drop: ["ALL"]
			readOnlyRootFilesystem: true
		}

		// Timeout for 'kubectl check api' command.
		timeout: "1m"

		// Job backoffLimit
		backoffLimit: 4

		// Optional additional annotations to add to the startupapicheck Job.
		// +docs:property
		jobAnnotations: {
			"helm.sh/hook":               "post-install"
			"helm.sh/hook-weight":        "1"
			"helm.sh/hook-delete-policy": "before-hook-creation,hook-succeeded"
		}

		// Optional additional annotations to add to the startupapicheck Pods.
		// +docs:property
		// podAnnotations: {}
		// Additional command line flags to pass to startupapicheck binary.
		// To see all available flags run `docker run quay.io/jetstack/cert-manager-startupapicheck:<version> --help`.
		//
		// Verbose logging is enabled by default so that if startupapicheck fails, you
		// can know what exactly caused the failure. Verbose logs include details of
		// the webhook URL, IP address and TCP connect errors for example.
		// +docs:property
		extraArgs: ["-v"]

		// Additional environment variables to pass to cert-manager startupapicheck binary.
		// For example:
		//  extraEnv:
		//  - name: SOME_VAR
		//    value: 'some value'
		extraEnv: []

		// Resources to provide to the cert-manager controller pod.
		//
		// For example:
		//  requests:
		//    cpu: 10m
		//    memory: 32Mi
		//
		// For more information, see [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).
		resources: {}

		// The nodeSelector on Pods tells Kubernetes to schedule Pods on the nodes with
		// matching labels.
		// For more information, see [Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/).
		//
		// This default ensures that Pods are only scheduled to Linux nodes.
		// It prevents Pods being scheduled to Windows nodes in a mixed OS cluster.
		// +docs:property
		nodeSelector: {
			"kubernetes.io/os": "linux"
		}

		// A Kubernetes Affinity, if required. For more information, see [Affinity v1 core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#affinity-v1-core).
		// For example:
		//   affinity:
		//     nodeAffinity:
		//      requiredDuringSchedulingIgnoredDuringExecution:
		//        nodeSelectorTerms:
		//        - matchExpressions:
		//          - key: foo.bar.com/role
		//            operator: In
		//            values:
		//            - master
		affinity: {}

		// A list of Kubernetes Tolerations, if required. For more information, see [Toleration v1 core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#toleration-v1-core).
		//
		// For example:
		//   tolerations:
		//   - key: foo.bar.com/role
		//     operator: Equal
		//     value: master
		//     effect: NoSchedule
		tolerations: []

		// Optional additional labels to add to the startupapicheck Pods.
		podLabels: {}
		image: {

			// The container registry to pull the startupapicheck image from.
			// +docs:property
			// registry: quay.io
			// The container image for the cert-manager startupapicheck.
			// +docs:property
			repository: "quay.io/jetstack/cert-manager-startupapicheck"

			// Override the image tag to deploy by setting this variable.
			// If no value is set, the chart's appVersion is used.
			// +docs:property
			// tag: vX.Y.Z
			// Setting a digest will override any tag.
			// +docs:property
			// digest: sha256:0e072dddd1f7f8fc8909a2ca6f65e76c5f0d2fcfb8be47935ae3457e8bbceb20
			// Kubernetes imagePullPolicy on Deployment.
			pullPolicy: "IfNotPresent"
		}
		rbac: {
			// annotations for the startup API Check job RBAC and PSP resources.
			// +docs:property
			annotations: {
				"helm.sh/hook":               "post-install"
				"helm.sh/hook-weight":        "-5"
				"helm.sh/hook-delete-policy": "before-hook-creation,hook-succeeded"
			}
		}

		// Automounting API credentials for a particular pod.
		// +docs:property
		// automountServiceAccountToken: true
		serviceAccount: {
			// Specifies whether a service account should be created.
			create: true

			// The name of the service account to use.
			// If not set and create is true, a name is generated using the fullname template.
			// +docs:property
			// name: ""
			// Optional additional annotations to add to the Job's Service Account.
			// +docs:property
			annotations: {
				"helm.sh/hook":               "post-install"
				"helm.sh/hook-weight":        "-5"
				"helm.sh/hook-delete-policy": "before-hook-creation,hook-succeeded"
			}

			// Automount API credentials for a Service Account.
			// +docs:property
			// Optional additional labels to add to the startupapicheck's Service Account.
			// +docs:property
			// labels: {}
			automountServiceAccountToken: true
		}

		// Additional volumes to add to the cert-manager controller pod.
		volumes: []

		// Additional volume mounts to add to the cert-manager controller container.
		volumeMounts: []

		// enableServiceLinks indicates whether information about services should be
		// injected into pod's environment variables, matching the syntax of Docker
		// links.
		enableServiceLinks: false
	}

	// Create dynamic manifests via values.
	//
	// For example:
	// extraObjects:
	//   - |
	//     apiVersion: v1
	//     kind: ConfigMap
	//     metadata:
	//       name: '{{ template "cert-manager.fullname" . }}-extra-configmap'
	extraObjects: []

	// Field used by our release pipeline to produce the static manifests.
	// The field defaults to "helm" but is set to "static" when we render
	// the static YAML manifests.
	// +docs:hidden
	creator: "helm"

	// Field that can be used as a condition when cert-manager is a dependency.
	// This definition is only here as a placeholder such that it is included in
	// the json schema.
	// See https://helm.sh/docs/chart_best_practices/dependencies/#conditions-and-tags
	// for more info.
	// +docs:hidden
	enabled: true
}