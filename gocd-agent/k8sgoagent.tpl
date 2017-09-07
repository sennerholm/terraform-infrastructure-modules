---
apiVersion: apps/v1beta1 # for versions before 1.6.0 use extensions/v1beta1
kind: Deployment
metadata:
  name: gocd-agent
spec:
  replicas: 2
  template:
    metadata:
      labels:
        app: gocd-agent
    spec:
      containers:
      - image: sennerholm/gocd-agent-gcloud:v17.9.2
        name: gocd-agent
        imagePullPolicy: Always
        securityContext:
          privileged: true
        env:
        - name: "GO_SERVER_URL"
          value: "${go_url}/go"
        - name: "AGENT_AUTO_REGISTER_KEY"
          value: "${go_auto_reg}"
        - name: "GOOGLE_APPLICATION_CREDENTIALS"
          value: "/var/run/secrets/cloud.google.com/service-account.json"
        - name: "PROJECT_ID"
          value: "${google_project}"
        volumeMounts:
        - mountPath: "/usr/bin/docker"
          name: "docker-command"
        - mountPath: "/var/run/docker.sock"
          name: docker-sock
        - mountPath: "/var/run/secrets/cloud.google.com"
          name: "google-service-account"
        - name: "ssh-key"
          mountPath: "/my-ssh-keys"
      volumes:
      - name: "docker-command"
        hostPath:
# directory location on host
          path: "/usr/bin/docker"
      - name: "docker-sock"
        hostPath:
          path: "/var/run/docker.sock"
      - name: "google-service-account"
        secret:
          secretName: "google-service-account"
# Converted from octal mode...
          defaultMode: 256
      - name: "ssh-key"
        secret:
            secretName: "ssh-key"