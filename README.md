# Kubernetes Helper Scripts

This repository contains a set of simple Bash scripts created to make working with Kubernetes easier and faster.

The goal of this project is to automate common Kubernetes setup tasks such as installing tools, creating useful aliases, enabling auto-completion, and cleaning up resources.

## Project Files

```
.
├── 1-install.sh
├── 2-aliases.sh
├── 3-auto-complete.sh
└── 4-cleanup.sh
```

---

## 1. Install Script

The `1-install.sh` script is used to install the required Kubernetes tools. It can be used to prepare a Linux environment for working with Kubernetes.

**Example tools that may be installed:**

- `kubectl`
- `helm`
- `kubeadm`
- `kubelet`

---

## 2. Aliases Script

The `2-aliases.sh` script contains useful command aliases to make Kubernetes commands shorter and easier to use.

**Example aliases:**

```bash
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgn='kubectl get nodes'
```

Instead of writing:

```bash
kubectl get pods
```

You can simply write:

```bash
kgp
```

---

## 3. Auto-Complete Script

The `3-auto-complete.sh` script enables Kubernetes command auto-completion. This helps when writing `kubectl` commands by allowing the terminal to suggest commands, resources, and options.

**Example:**

```bash
kubectl get po<TAB>
```

This makes working with Kubernetes faster and reduces typing mistakes.

---

## 4. Cleanup Script

The `4-cleanup.sh` script is used to clean up Kubernetes resources or reset the environment. It can be helpful when practicing Kubernetes labs or removing old resources.

**Example cleanup tasks:**

- Delete pods
- Delete deployments
- Delete services
- Reset Kubernetes environment

---

## How to Use

### Step 1: Give Execute Permission

```bash
chmod +x 1-install.sh 2-aliases.sh 3-auto-complete.sh 4-cleanup.sh
```

### Step 2: Run the Scripts

Run the scripts one by one in order:

```bash
./1-install.sh
./2-aliases.sh
./3-auto-complete.sh
./4-cleanup.sh
```

