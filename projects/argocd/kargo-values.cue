package holos

Kargo: Values: {
	//# Default values for kargo.
	//# A human-readable version can be found in the chart README.
	//# This is a YAML-formatted file.
	//# Declare variables to be passed into your templates.
	//# @section Global Parameters
	global: {
		//# @param global.env Environment variables to add to all Kargo pods.
		env: []
		//  - name: ENV_NAME
		//    value: value
		//# @param global.envFrom Environment variables to add to all Kargo pods from ConfigMaps or Secrets.
		envFrom: []
		//  - configMapRef:
		//      name: config-map-name
		//  - secretRef:
		//      name: secret-name
		//# @param global.nodeSelector Default node selector for all Kargo pods.
		nodeSelector: {}

		//# @param global.labels Labels to add to all resources.
		labels: {}
		//# @param global.annotations Annotations to add to all resources.
		annotations: {}
		//# @param global.podLabels Labels to add to all pods.
		podLabels: {}
		//# @param global.podAnnotations Annotations to add to pods.
		podAnnotations: {}

		//# @param global.tolerations Default tolerations for all Kargo pods.
		tolerations: []
		//# @param global.affinity Default affinity for all Kargo pods.
		affinity: {}
		//# @param global.securityContext Default security context for all Kargo pods.
		securityContext: {}
	}

	//# @section Image Parameters
	image: {
		//# @param image.repository Image repository of Kargo
		repository: "ghcr.io/akuity/kargo"
		//# @param image.tag Overrides the image tag. The default tag is the value of `.Chart.AppVersion`
		tag: ""
		//# @param image.pullPolicy Image pull policy
		pullPolicy: "IfNotPresent"
		//# @param image.pullSecrets List of imagePullSecrets.
		// - name: regcred
		pullSecrets: []
	}

	//# @section RBAC
	rbac: {
		//# @param rbac.installClusterRoles Indicates if `ClusterRoles` should be installed.
		installClusterRoles: true
		//# @param rbac.installClusterRoleBindings Indicates if `ClusterRoleBindings` should be installed.
		installClusterRoleBindings: true
	}

	//# @section CRDs
	crds: {
		//# @param crds.install Indicates if Custom Resource Definitions should be installed and upgraded as part of the release. If set to `false`, the CRDs will only be installed if they do not already exist.
		install: true
		//# @param crds.keep Indicates if Custom Resource Definitions should be kept when a release is uninstalled.
		keep: true
	}

	//# @section KubeConfigs
	//# @descriptionStart
	//# Optionally point to Kubernetes Secrets containing kubeconfig for:
	//#
	//# 1. A remote cluster hosting Kargo resources
	//#
	//# 2. A remote cluster hosting Argo CD resources
	//#
	//# 3. A remote cluster that is running Argo Rollouts and is a suitable location
	//#    to execute user-defined verification processes in the form of Argo
	//#    Rollouts AnalysisRuns
	//#
	//# This flexibility is useful for various advanced use cases -- especially
	//# topologies where Kargo data may be sharded, with Kargo controllers distributed
	//# across many clusters. Any two, or even all three, of these configurations may
	//# be the same. In the average case, these should all be left unspecified. All
	//# that are unspecified will default to configuration for the cluster in which
	//# the Kargo controller is running.
	//# @descriptionEnd
	//# @skip kubeconfigSecrets
	//# @param kubeconfigSecrets.kargo [nullable] Kubernetes `Secret` name containing kubeconfig for a remote Kubernetes cluster hosting Kargo resources. Used by all Kargo components.
	// kargo: ""
	//# @param kubeconfigSecrets.argocd [nullable] Kubernetes `Secret` name containing kubeconfig for a remote Kubernetes cluster hosting Argo CD resources. Used by Kargo controller(s) only.
	// argocd: ""
	kubeconfigSecrets: {}

	//# @section API
	api: {
		//# @param api.enabled Whether the API server is enabled.
		enabled: true
		//# @param api.replicas The number of API server pods.
		replicas: 1
		//# @param api.host The domain name where Kargo's API server will be accessible. When applicable, this is used for generation of an Ingress resource, certificates, and the OpenID Connect issuer and callback URLs. Note: The value in this field MAY include a port number and MUST NOT specify the protocol (http vs https), which is automatically inferred from other configuration options.
		host: "localhost"
		//# @param api.logLevel The log level for the API server.
		logLevel: "INFO"

		//# @param api.labels Labels to add to the api resources. Merges with `global.labels`, allowing you to override or add to the global labels.
		labels: {}
		//# @param api.annotations Annotations to add to the api resources. Merges with `global.annotations`, allowing you to override or add to the global annotations.
		annotations: {}
		//# @param api.podLabels Optional labels to add to pods. Merges with `global.podLabels`, allowing you to override or add to the global labels.
		podLabels: {}
		//# @param api.podAnnotations Optional annotations to add to pods. Merges with `global.podAnnotations`, allowing you to override or add to the global annotations.
		podAnnotations: {}

		//# @param api.secretManagementEnabled Specifies whether Secret management is enabled. This affects the API server's ability to manage repository credentials and other Project-level Secrets, such as those used by AnalysisRuns for verification purposes. If using GitOps to manage Kargo Projects declaratively, the API's Secret management capabilities are not needed and can be disabled to effectively reduce the API server's attackable surface.
		secretManagementEnabled: true

		//# @param api.resources Resources limits and requests for the api containers.
		resources: {}
		// limits:
		//   cpu: 100m
		//   memory: 128Mi
		// requests:
		//   cpu: 100m
		//   memory: 128Mi
		//# @param api.nodeSelector Node selector for api pods. Defaults to `global.nodeSelector`.
		nodeSelector: {}
		//# @param api.tolerations Tolerations for api pods. Defaults to `global.tolerations`.
		tolerations: []
		//# @param api.affinity Specifies pod affinity for api pods. Defaults to `global.affinity`.
		affinity: {}
		//# @param api.securityContext Security context for api pods. Defaults to `global.securityContext`.
		securityContext: {}
		cabundle: {
			//# @param api.cabundle.configMapName Specifies the name of an optional ConfigMap containing CA certs that is managed "out of band." Values in the ConfigMap named here should each contain a single PEM-encoded CA cert. If secretName is also defined, it will take precedence over this field.
			configMapName: ""
			//# @param api.cabundle.secretName Specifies the name of an optional Secret containing CA certs that is managed "out of band." Values in the Secret named here should each contain a single PEM-encoded CA cert. If defined, the value of this field takes precedence over any in configMapName.
			secretName: ""
		}
		//# @param api.env Environment variables to add to API server pods.
		env: []
		//  - name: ENV_NAME
		//    value: value
		//# @param api.envFrom Environment variables to add to API server pods from ConfigMaps or Secrets.
		//  - configMapRef:
		//      name: config-map-name
		//  - secretRef:
		//      name: secret-name
		envFrom: []
		probes: {
			//# @param api.probes.enabled Whether liveness and readiness probes should be included in the API server deployment. It is sometimes advantageous to disable these during local development.
			enabled: true
		}
		tls: {
			//# @param api.tls.enabled Whether to enable TLS directly on the API server. This is helpful if you do not intend to use an ingress controller or if you require TLS end-to-end. All other settings in this section will be ignored when this is set to `false`.
			enabled: true
			//# @param api.tls.selfSignedCert Whether to generate a self-signed certificate for use by the API server. If `true`, `cert-manager` CRDs **must** be present in the cluster. Kargo will create and use its own namespaced issuer. If `false`, a cert secret named `kargo-api-cert` **must** be provided in the same namespace as Kargo.
			selfSignedCert: true
		}

		//# @param api.permissiveCORSPolicyEnabled Whether to enable a permissive CORS (Cross Origin Resource Sharing) policy. This is sometimes advantageous during local development, but otherwise, should generally be left disabled.
		permissiveCORSPolicyEnabled: false
		ingress: {
			//# @param api.ingress.enabled Whether to enable ingress. By default, this is disabled. Enabling ingress is advanced usage.
			enabled: false
			//# @param api.ingress.annotations Annotations specified by your ingress controller to customize the behavior of the ingress resource.
			annotations: {}
			// kubernetes.io/ingress.class: nginx
			//# @param api.ingress.ingressClassName From Kubernetes 1.18+, this field is supported if implemented by your ingress controller. When set, you do not need to add the ingress class as annotation.
			ingressClassName: null
			tls: {
				//# @param api.ingress.tls.enabled Whether to enable TLS for the ingress. All other settings in this section will be ignored when this is set to `false`.
				enabled: true
				//# @param api.ingress.tls.selfSignedCert Whether to generate a self-signed certificate for use with the API server's Ingress resource. If `true`, `cert-manager` CRDs **must** be present in the cluster. Kargo will create and use its own namespaced issuer. If `false`, a cert secret named `kargo-api-ingress-cert` **must** be provided in the same namespace as Kargo.
				selfSignedCert: true
			}
			//# @param api.ingress.pathType You may want to use `Prefix` for some controllers (like AWS LoadBalancer Ingress controller), which don't support `/` as wildcard path when pathType is set to `ImplementationSpecific`
			pathType: "ImplementationSpecific"
		}
		service: {
			//# @param api.service.type If you're not going to use an ingress controller, you may want to change this value to `LoadBalancer` for production deployments. If running locally, you may want to change it to `NodePort` OR leave it as `ClusterIP` and use `kubectl port-forward` to map a port on the local network interface to the service.
			type: "ClusterIP"
			//# @param api.service.nodePort [nullable] Host port the `Service` will be mapped to when `type` is either `NodePort` or `LoadBalancer`. If not specified, Kubernetes chooses.
			// nodePort:
			//# @param api.service.annotations Annotations to add to the API server's service. Merges with `global.annotations`, allowing you to override or add to the global annotations.
			annotations: {}
		}
		secret: {
			//# @param api.secret.name Specifies the name of an existing Secret which contains the `ADMIN_ACCOUNT_PASSWORD_HASH` and `ADMIN_ACCOUNT_TOKEN_SIGNING_KEY` values. By setting this, the Secret will **not** be generated by Helm.
			name: "admin-credentials"
		}
		adminAccount: {
			//# @param api.adminAccount.enabled Whether to enable the admin account.
			enabled: true
			//# @param api.adminAccount.passwordHash Bcrypt password hash for the admin account. A value **must** be provided for this field unless `api.secret.name` is specified.
			passwordHash: ""
			//# @param api.adminAccount.tokenSigningKey Key used to sign ID tokens (JWTs) for the admin account. It is suggested that you generate this using a password manager or a command like: `openssl rand -base64 29 \| tr -d "=+/" \| cut`. A value **must** be provided for this field, unless `api.secret.name` is specified.
			tokenSigningKey: ""
			//# @param api.adminAccount.tokenTTL Specifies how long ID tokens for the admin account are valid. (i.e. The expiry will be the time of issue plus this duration.)
			tokenTTL: "24h"
		}

		//# All settings related to enabling OpenID Connect as an authentication
		//# method.
		oidc: {
			//# @param api.oidc.enabled Whether to enable authentication using Open ID Connect.
			//# NOTE: Kargo uses the Authorization Code Flow with Proof Key for Code Exchange (PKCE) and does not require a client secret. Some OIDC identity providers may not support this. If yours does not, enabling the optional Dex server and configuring its connectors can adapt most identity providers to work this way.
			//# Note also: The PKCE code challenge used by Kargo is SHA256 hashed.
			//# For more information about PKCE, please visit: https://oauth.net/2/pkce/
			enabled: false
			//# @param api.oidc.issuerURL The issuer URL for the identity provider. If Dex is enabled, this value will be ignored and the issuer URL will be automatically configured. If Dex is not enabled, this should be set to the issuer URL provided to you by your identity provider.
			issuerURL: null
			//# @param api.oidc.clientID The client ID for the OIDC client. If Dex is enabled, this value will be ignored and the client ID will be automatically configured. If Dex is not enabled, this should be set to the client ID provided to you by your identity provider.
			clientID: null
			//# @param api.oidc.cliClientID The client ID for the OIDC client used by CLI (optional). Needed by some OIDC providers (such as Dex) that require a separate Client ID for web app login vs. CLI login (`http://localhost`). If Dex is enabled, this value will be ignored and cli client ID will be automatically configured. If Dex is not enabled, and a different client app is configured for localhost CLI login, this should be the client ID configured in the IdP.
			cliClientID: null
			//# @param api.oidc.additionalScopes The additional scopes to send to the OIDC provider. This should be set to the scopes you wish to be provided to your identity provider from clients of Kargo, the scopes openid, profile and email are always requested and don't need to be added, this value is intended for any additional ones you require.
			additionalScopes: ["groups"]
			admins: {
				//# @param api.oidc.admins.claims Subjects having any of these claims will automatically be Kargo admins.
				// sub:
				// - alice
				// - bob
				// email:
				// - alice@example.com
				// - bob@examples.com
				// groups:
				// - kargo-admin
				claims: {}}
			viewers: {
				//# @param api.oidc.viewers.claims Subjects having any of these claims will automatically receive read-only access to all Kargo resources.
				// sub:
				// - alice
				// - bob
				// email:
				// - alice@example.com
				// - bob@examples.com
				// groups:
				// - kargo-viewer
				claims: {}}
			globalServiceAccounts: {
				//# @param api.oidc.globalServiceAccounts.namespaces List of namespaces to look for shared service accounts.
				namespaces: []}
			dex: {
				//# @param api.oidc.dex.enabled Whether to enable Dex as the identity provider. When set to true, the Kargo installation will include a Dex server and the Kargo API server will be configured to make the /dex endpoint a reverse proxy for the Dex server.
				enabled: false
				image: {
					//# @param api.oidc.dex.image.repository Image repository of Dex
					repository: "ghcr.io/dexidp/dex"
					//# @param api.oidc.dex.image.tag Image tag for Dex.
					tag: "v2.37.0"
					//# @param api.oidc.dex.image.pullPolicy Image pull policy for Dex.
					pullPolicy: "IfNotPresent"
					//# @param api.oidc.dex.image.pullSecrets List of imagePullSecrets.
					// - name: regcred
					pullSecrets: []
				}

				//# @param api.oidc.dex.env Environment variables to add to Dex server pods. This is convenient for cases where api.oidc.dex.connectors needs to reference environment variables from a Secret that is managed "out of band" with a secret management solution such as Sealed Secrets.
				env: []
				// - name: CLIENT_SECRET
				//   valueFrom:
				//     secretKeyRef:
				//       name: github-dex
				//       key: dex.github.clientSecret
				//# @param api.oidc.dex.envFrom Environment variables to add to Dex server pods from ConfigMaps or Secrets. This is especially convenient for cases where api.oidc.dex.connectors needs to reference environment variables from a Secret that is managed "out of band" with a secret management solution such as Sealed Secrets.
				//  - configMapRef:
				//      name: config-map-name
				//  - secretRef:
				//      name: secret-name
				envFrom: []

				//# @param api.oidc.dex.volumes Add additional volumes to Dex pods. This is convenient for cases where api.oidc.dex.connectors needs to reference mounted data from a Secret that is managed "out of band" with a secret management solution such as Sealed Secrets.
				// - name: google-json
				//   secret:
				//     defaultMode: 420
				//     secretName: kargo-google-groups-json
				volumes: []

				//# @param api.oidc.dex.volumeMounts Add additional volume mounts to Dex pods. This is convenient for cases where api.oidc.dex.connectors needs to reference mounted data from a Secret that is managed "out of band" with a secret management solution such as Sealed Secrets.
				volumeMounts: null

				// - mountPath: /tmp/oidc
				//   name: google-json
				//   readOnly: true
				probes: {
					//# @param api.oidc.dex.probes.enabled Whether liveness and readiness probes should be included in the Dex server deployment. It is sometimes advantageous to disable these during local development.
					enabled: true
				}
				tls: {
					//# @param api.oidc.dex.tls.selfSignedCert Whether to generate a self-signed certificate for use with Dex. If `true`, `cert-manager` CRDs **must** be present in the cluster. Kargo will create and use its own namespaced issuer. If `false`, a cert secret named `kargo-dex-server-cert` **must** be provided in the same namespace as Kargo. There is no provision for running Dex without TLS.
					selfSignedCert: true
				}
				//# @param api.oidc.dex.skipApprovalScreen Whether to skip Dex's own approval screen. Since upstream identity providers will already request user consent, this second approval screen from Dex can be both superfluous and confusing.
				skipApprovalScreen: true
				//# @param api.oidc.dex.connectors Configure [Dex connectors](https://dexidp.io/docs/connectors/) to one or more upstream identity providers.
				// - id: mock
				//   name: Example
				//   type: mockCallback
				//# Google Example
				// - id: google
				//   name: Google
				//   type: google
				//   config:
				//     clientID: <your client ID>
				//     clientSecret: "$CLIENT_SECRET"
				//     redirectURI: <http(s)>://<api.host>/dex/callback
				//# GitHub Example
				// - id: github
				//   name: GitHub
				//   type: github
				//   config:
				//     clientID: <your client ID>
				//     clientSecret: "$CLIENT_SECRET"
				//     redirectURI: <http(s)>://<api.host>/dex/callback
				//# Azure Example
				// - id: microsoft
				//   name: microsoft
				//   type: Microsoft
				//   config:
				//     clientID: <your client ID>
				//     clientSecret: "$CLIENT_SECRET"
				//     redirectURI: <http(s)>://<api.host>/dex/callback
				//     tenant: <tenant ID>
				connectors: []

				//# @param api.oidc.dex.resources Resources limits and requests for the Dex server containers.
				resources: {}
				// limits:
				//   cpu: 100m
				//   memory: 128Mi
				// requests:
				//   cpu: 100m
				//   memory: 128Mi
				//# @param api.oidc.dex.nodeSelector Node selector for Dex server pods. Defaults to `global.nodeSelector`.
				nodeSelector: {}
				//# @param api.oidc.dex.tolerations Tolerations for Dex server pods. Defaults to `global.tolerations`.
				tolerations: []
				//# @param api.oidc.dex.affinity Specifies pod affinity for the Dex server pods. Defaults to `global.affinity`.
				affinity: {}
				//# @param api.oidc.dex.annotations Annotations to add to the Dex server pods. Merges with `global.annotations`, allowing you to override or add to the global annotations.
				annotations: {}
				//# @param api.oidc.dex.securityContext Security context for Dex server pods. Defaults to `global.securityContext`.
				securityContext: {}
			}
		}
		argocd: {
			//# @param api.argocd.urls Mapping of Argo CD shards names to URLs to support deep links to Argo CD URLs. If sharding is not used, map the empty string to the single Argo CD URL.
			// "": https://argocd.example.com
			// "shard2": https://argocd2.example.com
			urls: null
		}

		//# All settings relating to the use of Argo Rollouts by the API Server.
		rollouts: {
			//# @param api.rollouts.integrationEnabled Specifies whether Argo Rollouts integration is enabled. When not enabled, the API server will not be capable of creating/updating/applying AnalysesTemplate resources in the Kargo control plane. When enabled, the API server will perform a sanity check at startup. If Argo Rollouts CRDs are not found, the API server will proceed as if this integration had been explicitly disabled. Explicitly disabling is still preferable if this integration is not desired, as it will grant fewer permissions to the API server.
			integrationEnabled: true
		}
	}

	//# @section Controller
	//# All settings for the controller component
	controller: {
		//# @param controller.enabled Whether the controller is enabled.
		enabled: true

		//# @param controller.labels Labels to add to the api resources. Merges with `global.labels`, allowing you to override or add to the global labels.
		labels: {}
		//# @param controller.annotations Annotations to add to the api resources. Merges with `global.annotations`, allowing you to override or add to the global annotations.
		annotations: {}
		//# @param controller.podLabels Optional labels to add to pods. Merges with `global.podLabels`, allowing you to override or add to the global labels.
		podLabels: {}
		//# @param controller.podAnnotations Optional annotations to add to pods. Merges with `global.podAnnotations`, allowing you to override or add to the global annotations.
		podAnnotations: {}

		//# All settings relating to the service account for the controller
		serviceAccount: {
			//# @param controller.serviceAccount.iamRole Specifies the ARN of an AWS IAM role to be used by the controller in an IRSA-enabled EKS cluster.
			iamRole: ""
			//# @param controller.serviceAccount.clusterWideSecretReadingEnabled Specifies whether the controller's ServiceAccount should be granted read permissions to Secrets CLUSTER-WIDE in the Kargo control plane's cluster. Enabling this is highly discouraged and you do so at your own peril. When this is NOT enabled, the Kargo management controller will dynamically expand and contract the controller's permissions to read Secrets on a Project-by-Project basis.
			clusterWideSecretReadingEnabled: false
		}

		//# All settings relating to shared credentials (used across multiple kargo projects)
		globalCredentials: {
			//# @param controller.globalCredentials.namespaces List of namespaces to look for shared credentials. Note that as of v1.0.0, the Kargo controller does not have cluster-wide access to Secrets. The controller receives read-only permission for Secrets on a per-Project basis as Projects are created. If you designate some namespaces as homes for "global" credentials, you will need to manually grant the controller permission to read Secrets in those namespaces.
			namespaces: []}
		gitClient: {
			//# @param controller.gitClient.name Specifies the name of the Kargo controller (used when authoring Git commits).
			name: "Kargo"
			//# @param controller.gitClient.email Specifies the email of the Kargo controller (used when authoring Git commits).
			email: "no-reply@kargo.io"
			signingKeySecret: {
				//# @param controller.gitClient.signingKeySecret.name Specifies the name of an existing `Secret` which contains the Git user's signing key. The value should be accessible under `.data.signingKey` in the same namespace as Kargo. When the signing key is a GPG key, the GPG key's name and email address identity must match the values defined for `controller.gitClient.name` and `controller.gitClient.email`.
				name: ""
				//# @param controller.gitClient.signingKeySecret.type Specifies the type of the signing key. The currently supported and default option is `gpg`.
				type: ""
			}
		}

		//# @param controller.securityContext Security context for controller pods. Defaults to `global.securityContext`.
		securityContext: {}
		cabundle: {
			//# @param controller.cabundle.configMapName Specifies the name of an optional ConfigMap containing CA certs that is managed "out of band." Values in the ConfigMap named here should each contain a single PEM-encoded CA cert. If secretName is also defined, it will take precedence over this field.
			configMapName: ""
			//# @param controller.cabundle.secretName Specifies the name of an optional Secret containing CA certs that is managed "out of band." Values in the Secret named here should each contain a single PEM-encoded CA cert. If defined, the value of this field takes precedence over any in configMapName.
			secretName: ""
		}

		//# @param controller.shardName [nullable] Set a shard name only if you are running multiple controllers backed by a single underlying control plane. Setting a shard name will cause this controller to operate **only** on resources with a matching shard name. Leaving the shard name undefined will designate this controller as the default controller that is responsible exclusively for resources that are **not** assigned to a specific shard. Leaving this undefined is the correct choice when you are not using sharding at all. It is also the correct setting if you are using sharding and want to designate a controller as the default for handling resources not assigned to a specific shard. In most cases, this setting should simply be left alone.
		// shardName:
		//# All settings relating to the Argo CD control plane this controller might
		//# integrate with.
		argocd: {
			//# @param controller.argocd.integrationEnabled Specifies whether Argo CD integration is enabled. When not enabled, the controller will not watch Argo CD Application resources or factor Application health and sync state into determinations of Stage health. Argo CD-based promotion mechanisms will also fail. When enabled, the controller will perform a sanity check at startup. If Argo CD CRDs are not found, the controller will proceed as if this integration had been explicitly disabled. Explicitly disabling is still preferable if this integration is not desired, as it will grant fewer permissions to the controller.
			integrationEnabled: true
			//# @param controller.argocd.namespace The namespace into which Argo CD is installed.
			namespace: "argocd"
			//# @param controller.argocd.watchArgocdNamespaceOnly Specifies whether the reconciler that watches Argo CD Applications for the sake of forcing related Stages to reconcile should only watch Argo CD Application resources residing in Argo CD's own namespace. Note: Older versions of Argo CD only supported Argo CD Application resources in Argo CD's own namespace, but newer versions support Argo CD Application resources in any namespace. This should usually be left as `false`.
			watchArgocdNamespaceOnly: false
		}

		//# All settings relating to the use of Argo Rollouts AnalysisTemplates and
		//# AnalysisRuns as a means of verifying Stages after a Promotion.
		rollouts: {
			//# @param controller.rollouts.integrationEnabled Specifies whether Argo Rollouts integration is enabled. When not enabled, the controller will not reconcile Argo Rollouts AnalysisRun resources and attempts to verify Stages via Analysis will fail. When enabled, the controller will perform a sanity check at startup. If Argo Rollouts CRDs are not found, the controller will proceed as if this integration had been explicitly disabled. Explicitly disabling is still preferable if this integration is not desired, as it will grant fewer permissions to the controller.
			integrationEnabled: true
			//# @param controller.rollouts.controllerInstanceID Specifies a cluster on which Jobs corresponding to an AnalysisRun (used for Freight/Stage verification purposes) will be executed. This is useful in cases where the cluster hosting the Kargo control plane is not a suitable environment for executing user-defined logic. Kargo will use this as the value of the rgo-rollouts.argoproj.io/controller-instance-id label when creating AnalysisRuns. When this is left empty/undefined, no such label will be added to AnalysisRuns.
			controllerInstanceID: ""
		}

		//# @param controller.logLevel The log level for the controller.
		logLevel: "INFO"

		//# @param controller.resources Resources limits and requests for the controller containers.
		resources: {}
		// limits:
		//   cpu: 100m
		//   memory: 128Mi
		// requests:
		//   cpu: 100m
		//   memory: 128Mi
		//# @param controller.nodeSelector Node selector for controller pods. Defaults to `global.nodeSelector`.
		nodeSelector: {}
		//# @param controller.tolerations Tolerations for controller pods. Defaults to `global.tolerations`.
		tolerations: []
		//# @param controller.affinity Specifies pod affinity for controller pods. Defaults to `global.affinity`.
		affinity: {}
		//# @param controller.env Environment variables to add to controller pods.
		env: []
		//  - name: ENV_NAME
		//    value: value
		//# @param controller.envFrom Environment variables to add to controller pods from ConfigMaps or Secrets.
		//  - configMapRef:
		//      name: config-map-name
		//  - secretRef:
		//      name: secret-name
		envFrom: []
	}

	//# @section Management Controller
	//# All settings for the management controller component
	managementController: {
		//# @param managementController.enabled Whether the management controller is enabled.
		enabled: true

		//# @param managementController.logLevel The log level for the management controller.
		logLevel: "INFO"

		//# @param managementController.labels Labels to add to the api resources. Merges with `global.labels`, allowing you to override or add to the global labels.
		labels: {}
		//# @param managementController.annotations Annotations to add to the api resources. Merges with `global.annotations`, allowing you to override or add to the global annotations.
		annotations: {}
		//# @param managementController.podLabels Optional labels to add to pods. Merges with `global.podLabels`, allowing you to override or add to the global labels.
		podLabels: {}
		//# @param managementController.podAnnotations Optional annotations to add to pods. Merges with `global.podAnnotations`, allowing you to override or add to the global annotations.
		podAnnotations: {}

		//# @param managementController.securityContext Security context for management controller pods. Defaults to `global.securityContext`.
		securityContext: {}

		//# @param managementController.resources Resources limits and requests for the management controller containers.
		resources: {}
		// limits:
		//   cpu: 100m
		//   memory: 128Mi
		// requests:
		//   cpu: 100m
		//   memory: 128Mi
		//# @param managementController.nodeSelector Node selector for management controller pods. Defaults to `global.nodeSelector`.
		nodeSelector: {}
		//# @param managementController.tolerations Tolerations for management controller pods. Defaults to `global.tolerations`.
		tolerations: []
		//# @param managementController.affinity Specifies pod affinity for management controller pods. Defaults to `global.affinity`.
		affinity: {}
		//# @param managementController.env Environment variables to add to management controller pods.
		env: []
		//  - name: ENV_NAME
		//    value: value
		//# @param managementController.envFrom Environment variables to add to management controller pods from ConfigMaps or Secrets.
		//  - configMapRef:
		//      name: config-map-name
		//  - secretRef:
		//      name: secret-name
		envFrom: []
	}

	//# @section Webhooks
	webhooks: {
		//# @param webhooks.register Whether to create `ValidatingWebhookConfiguration` and `MutatingWebhookConfiguration` resources.
		register: true
	}

	//# @section Webhooks Server
	webhooksServer: {
		//# @param webhooksServer.enabled Whether the webhooks server is enabled.
		enabled: true
		//# @param webhooksServer.replicas The number of webhooks server pods.
		replicas: 1
		//# @param webhooksServer.logLevel The log level for the webhooks server.
		logLevel: "INFO"
		//# @param webhooksServer.controlplaneUserRegex Regular expression for matching controlplane users.
		controlplaneUserRegex: "" // ^system:serviceaccount:kargo:[a-z0-9]([-a-z0-9]*[a-z0-9])?$

		//# @param webhooksServer.labels Labels to add to the api resources. Merges with `global.labels`, allowing you to override or add to the global labels.
		labels: {}
		//# @param webhooksServer.annotations Annotations to add to the api resources. Merges with `global.annotations`, allowing you to override or add to the global annotations.
		annotations: {}
		//# @param webhooksServer.podLabels Optional labels to add to pods. Merges with `global.podLabels`, allowing you to override or add to the global labels.
		podLabels: {}
		//# @param webhooksServer.podAnnotations Optional annotations to add to pods. Merges with `global.podAnnotations`, allowing you to override or add to the global annotations.
		podAnnotations: {}
		tls: {
			//# @param webhooksServer.tls.selfSignedCert  Whether to generate a self-signed certificate for the controller's built-in webhook server. If `true`, `cert-manager` CRDs **must** be present in the cluster. Kargo will create and use its own namespaced issuer. If `false`, a cert secret named `kargo-webhooks-server-cert` **must** be provided in the same namespace as Kargo. There is no provision for webhooks without TLS.
			selfSignedCert: true
		}
		//# @param webhooksServer.resources Resources limits and requests for the webhooks server containers.
		resources: {}
		// limits:
		//   cpu: 100m
		//   memory: 128Mi
		// requests:
		//   cpu: 100m
		//   memory: 128Mi
		//# @param webhooksServer.nodeSelector Node selector for the webhooks server pods. Defaults to `global.nodeSelector`.
		nodeSelector: {}
		//# @param webhooksServer.tolerations Tolerations for the webhooks server pods. Defaults to `global.tolerations`.
		tolerations: []
		//# @param webhooksServer.affinity Specifies pod affinity for the webhooks server pods. Defaults to `global.affinity`.
		affinity: {}
		//# @param webhooksServer.securityContext Security context for webhooks server pods. Defaults to `global.securityContext`.
		securityContext: {}
		//# @param webhooksServer.env Environment variables to add to webhook server pods.
		env: []
		//  - name: ENV_NAME
		//    value: value
		//# @param webhooksServer.envFrom Environment variables to add to webhook server pods from ConfigMaps or Secrets.
		//  - configMapRef:
		//      name: config-map-name
		//  - secretRef:
		//      name: secret-name
		envFrom: []
	}

	//# @section Garbage Collector
	garbageCollector: {
		//# @param garbageCollector.enabled Whether the garbage collector is enabled.
		enabled: true
		//# @param garbageCollector.schedule When to run the garbage collector.
		schedule: "0 * * * *"
		//# @param garbageCollector.workers The number of concurrent workers to run. Tuning this too low will result in slow garbage collection. Tuning this too high will result in too many API calls and may result in throttling.
		workers: 3
		//# @param garbageCollector.maxRetainedPromotions The ideal maximum number of Promotions OLDER than the oldest Promotion in a non-terminal phase (for each Stage) that may be spared by the garbage collector. The ACTUAL number of older Promotions spared may exceed this ideal if some Promotions that would otherwise be deleted do not meet the minimum age criterion.
		maxRetainedPromotions: 20
		//# @param garbageCollector.minPromotionDeletionAge The minimum age a Promotion must be before considered eligible for garbage collection.
		minPromotionDeletionAge: "336h" // Two weeks
		//# @param garbageCollector.maxRetainedFreight The ideal maximum number of Freight OLDER than the oldest still in use (from each Warehouse) that may be spared by the garbage collector. The ACTUAL number of older Freight spared may exceed this ideal if some Freight that would otherwise be deleted do not meet the minimum age criterion.
		maxRetainedFreight: 20
		//# @param garbageCollector.minFreightDeletionAge The minimum age Freight must be before considered eligible for garbage collection.
		minFreightDeletionAge: "336h" // Two weeks
		//# @param garbageCollector.logLevel The log level for the garbage collector.
		logLevel: "INFO"

		//# @param garbageCollector.labels Labels to add to the api resources. Merges with `global.labels`, allowing you to override or add to the global labels.
		labels: {}
		//# @param garbageCollector.annotations Annotations to add to the api resources. Merges with `global.annotations`, allowing you to override or add to the global annotations.
		annotations: {}
		//# @param garbageCollector.podLabels Optional labels to add to pods. Merges with `global.podLabels`, allowing you to override or add to the global labels.
		podLabels: {}
		//# @param garbageCollector.podAnnotations Optional annotations to add to pods. Merges with `global.podAnnotations`, allowing you to override or add to the global annotations.
		podAnnotations: {}

		//# @param garbageCollector.resources Resources limits and requests for the garbage collector containers.
		resources: {}
		// limits:
		//   cpu: 100m
		//   memory: 128Mi
		// requests:
		//   cpu: 100m
		//   memory: 128Mi
		//# @param garbageCollector.nodeSelector Node selector for the garbage collector pods. Defaults to `global.nodeSelector`.
		nodeSelector: {}
		//# @param garbageCollector.tolerations Tolerations for the garbage collector pods. Defaults to `global.tolerations`.
		tolerations: []
		//# @param garbageCollector.affinity Specifies pod affinity for the garbage collector pods. Defaults to `global.affinity`.
		affinity: {}
		//# @param garbageCollector.securityContext Security context for garbage collector pods. Defaults to `global.securityContext`.
		securityContext: {}
		//# @param garbageCollector.env Environment variables to add to garbage collector pods.
		env: []
		//  - name: ENV_NAME
		//    value: value
		//# @param garbageCollector.envFrom Environment variables to add to garbage collector pods from ConfigMaps or Secrets.
		//  - configMapRef:
		//      name: config-map-name
		//  - secretRef:
		//      name: secret-name
		envFrom: []
	}
}
