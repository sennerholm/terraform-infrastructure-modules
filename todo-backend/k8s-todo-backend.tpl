---
apiVersion: apps/v1beta1 # for versions before 1.6.0 use extensions/v1beta1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 2
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - image: ${registry_host}/${google_project}/todo-backend:${version}
        name: todo-backend
        imagePullPolicy: Always
        env:
        - name: "GOOGLE_DATASTORE_NAMESPACE"
          value: "${google_datastore_namespace}"
        - name: "GOOGLE_PROJECT_ID"
          value: "${google_project}"
        - name: "NODE_ENV"
          value: "production"
        - name: "GOOGLE_APPLICATION_CREDENTIALS"
          value: "/var/run/secrets/cloud.google.com/service-account.json"
        volumeMounts:
        - mountPath: "/var/run/secrets/cloud.google.com"
          name: "google-service-account"
      volumes:
      - name: "google-service-account"
        secret:
          secretName: "google-service-account"
