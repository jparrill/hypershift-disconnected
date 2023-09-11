A Hosted Cluster as the documentation [mentioned here](https://hypershift-docs.netlify.app/reference/concepts-and-personas/) it's just an OCP API endpoint managed by Hypershift but we will include also the term called HostedControlPlane in this concept to be more readable and easy to understand.

The Hosted Cluster contains 2 parts, the Control Plane which runs in the management cluster as pods and the Data plane which are running in external nodes managed by the end user.

Now with the base set, we can begin our Hosted Cluster deployment. Usually an ACM/MCE user will use the web-ui to create a cluster, but here we will use the manifests which give us more freedom to change the artifacts.