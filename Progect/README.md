# Lesson 5 - Terraform Infrastructure with EKS

Цей проєкт демонструє інфраструктуру AWS, розгорнуту за допомогою Terraform з використанням модульної архітектури. Включає створення Kubernetes кластера (EKS) та автоматичне розгортання Django-додатку за допомогою Helm.

## Структура проєкту

```
lesson-7/
│
├── main.tf                  # Головний файл для підключення модулів
├── backend.tf               # Налаштування бекенду для стейтів (S3 + DynamoDB
├── outputs.tf               # Загальні виводи ресурсів
│
├── modules/                 # Каталог з усіма модулями
│   ├── s3-backend/          # Модуль для S3 та DynamoDB
│   │   ├── s3.tf            # Створення S3-бакета
│   │   ├── dynamodb.tf      # Створення DynamoDB
│   │   ├── variables.tf     # Змінні для S3
│   │   └── outputs.tf       # Виведення інформації про S3 та DynamoDB
│   │
│   ├── vpc/                 # Модуль для VPC
│   │   ├── vpc.tf           # Створення VPC, підмереж, Internet Gateway
│   │   ├── routes.tf        # Налаштування маршрутизації
│   │   ├── variables.tf     # Змінні для VPC
│   │   └── outputs.tf
│   ├── ecr/                 # Модуль для ECR
│   │   ├── ecr.tf           # Створення ECR репозиторію
│   │   ├── variables.tf     # Змінні для ECR
│   │   └── outputs.tf       # Виведення URL репозиторію
│   │
│   ├── eks/                 # Модуль для Kubernetes кластера
│   │   ├── eks.tf           # Створення кластера
│   │   ├── variables.tf     # Змінні для EKS
│   │   └── outputs.tf       # Виведення інформації про кластер
│
├── charts/
│   └── django-app/
│       ├── templates/
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   ├── configmap.yaml
│       │   └── hpa.yaml
│       ├── Chart.yaml
│       └── values.yaml     # ConfigMap зі змінними середовища


```

## Команди для роботи з проєктом

### Ініціалізація Terraform

Перед початком роботи необхідно ініціалізувати Terraform та завантажити необхідні провайдери:

```bash
terraform init
```

Ця команда:

- Завантажує провайдер AWS
- Ініціалізує модулі
- Підготовлює робоче середовище

### Перегляд змін

Щоб подивитися, які зміни будуть застосовані до інфраструктури:

```bash
terraform plan
```

Ця команда показує план змін без їх застосування, що дозволяє перевірити конфігурацію перед розгортанням.

### Застосування змін

Для створення або оновлення інфраструктури виконайте:

```bash
terraform apply
```

Terraform запитає підтвердження перед застосуванням змін.

### Видалення інфраструктури

Для видалення всіх ресурсів, створених Terraform:

```bash
terraform destroy
```

## Опис модулів

### 1. Модуль `s3-backend`

**Призначення:** Створення інфраструктури для віддаленого зберігання стану Terraform.

**Що створює:**

- **S3 бакет** - для зберігання файлу стану Terraform (`terraform.tfstate`)
  - Увімкнено версіонування для збереження історії змін
  - Налаштовано контроль власності об'єктів
  - Шифрування даних
- **DynamoDB таблиця** - для блокування стану під час одночасної роботи (state locking)
  - Режим оплати: "PAY_PER_REQUEST"
  - Hash key: "LockID"

**Вхідні параметри:**

- `bucket_name` - назва S3 бакета
- `table_name` - назва таблиці DynamoDB

**Вивід:**

- `s3_bucket_name` - назва створеного S3 бакета
- `dynamodb_table_name` - назва створеної таблиці DynamoDB

**Навіщо потрібен:**
Цей модуль дозволяє зберігати стан Terraform у хмарі для збереження консинстенції архітектури

---

### 2. Модуль `vpc`

**Призначення:** Створення віртуальної приватної мережі (VPC) та мережевої інфраструктури в AWS.

**Що створює:**

- **VPC (Virtual Private Cloud)** - ізольована мережа в AWS
- **Публічні підмережі (Public Subnets)** - 3 підмережі в різних зонах доступності
- **Приватні підмережі (Private Subnets)** - 3 підмережі в різних зонах доступності
- **Internet Gateway** - шлюз для виходу в інтернет
- **Route Tables** - таблиці маршрутизації для публічних підмереж

**Вхідні параметри:**

- `vpc_cidr_block` - CIDR блок для VPC (наприклад, "10.0.0.0/16")
- `public_subnets` - список CIDR блоків для публічних підмереж
- `private_subnets` - список CIDR блоків для приватних підмереж
- `availability_zones` - список зон доступності
- `vpc_name` - ім'я VPC

**Навіщо потрібен:**
VPC забезпечує ізоляцію мережі та контроль над трафіком:

- Публічні підмережі - для веб-серверів, балансувальників навантаження
- Приватні підмережі - для баз даних, бекенд-сервісів

### 3. Модуль `ecr`

**Призначення:** Створення репозиторію Amazon ECR (Elastic Container Registry) для зберігання Docker-образів.

**Що створює:**

- **ECR Repository** - репозиторій для Docker-образів
  - Змінні теги образів (MUTABLE)
  - Автоматичне сканування на вразливості при завантаженні образів
  - Шифрування AES256
- **Repository Policy** - політика доступу до репозиторію
  - Дозволи на pull та push образів
  - Перегляд та опис образів

**Вхідні параметри:**

- `ecr_name` - назва репозиторію ECR
- `scan_on_push` - увімкнути/вимкнути автоматичне сканування образів (true/false)

**Вивід:**

- `ecr_repository_url` - URL репозиторію для push/pull образів
- `ecr_repository_arn` - ARN репозиторію
- `ecr_repository_name` - ім'я репозиторію

**Навіщо потрібен:**
ECR - це приватний реєстр Docker-образів від AWS

### 4. Модуль `eks`

**Призначення:** Створення керованого Kubernetes кластера (Amazon EKS) з групою worker nodes.

**Що створює:**

- **IAM-роль для EKS кластера** - роль з необхідними дозволами для управління кластером
- **EKS Cluster** - керований Kubernetes кластер
- **IAM-роль для Worker Nodes** - роль для EC2-інстансів (воркерів)
- **Node Group** - група EC2-інстансів для запуску контейнерів
  - Автоматичне масштабування (min/max/desired size)

**Вхідні параметри:**

- `cluster_name` - назва EKS кластера
- `subnet_ids` - список ID підмереж для розгортання кластера
- `instance_type` - тип EC2-інстансів для worker nodes (наприклад, "t3.small")
- `desired_size` - бажана кількість worker nodes
- `max_size` - максимальна кількість worker nodes
- `min_size` - мінімальна кількість worker nodes

**Вивід:**

- `eks_cluster_endpoint` - API endpoint для підключення до кластера
- `eks_cluster_name` - назва EKS кластера
- `eks_node_role_arn` - ARN IAM-ролі для worker nodes

**Навіщо потрібен:** EKS дозволяє запускати контейнеризовані додатки в керованому Kubernetes кластері.

---

## Helm Chart - Django App

**Призначення:** Розгортання Django-додатку в Kubernetes кластері через Helm.

**Що включає:**

- **Deployment** - визначає, як запускати Django-додаток
  - Автоматичне підтягування образу з ECR
  - Використання ConfigMap для змінних оточення
  - Налаштування ресурсів (CPU, Memory)
- **Service** - забезпечує мережевий доступ до подів
- **ConfigMap** - зберігає конфігурацію додатку
  - Змінні оточення для PostgreSQL
  - Змінні оточення для Django
- **HorizontalPodAutoscaler** - автоматичне масштабування при навантаженні

**Конфігурація (values.yaml):**

- `image.repository` - URL ECR репозиторію (встановлюється Terraform автоматично)
- `image.tag` - тег Docker-образу (за замовчуванням: latest)
- `service.port` - порт сервісу (8000)
- `hpa.minReplicas` / `hpa.maxReplicas` - мінімальна/максимальна кількість реплік
- `config.*` - змінні оточення для Django

**Інтеграція з Terraform:**
Terraform автоматично розгортає цей Helm-чарт після створення EKS кластера, передаючи URL ECR репозиторію як параметр.

---

## Налаштування

У файлі `backend.tf` міститься закоментована конфігурація віддаленого бекенду. Після створення S3 бакета та DynamoDB таблиці за допомогою модуля `s3-backend`, розкоментуйте конфігурацію для використання віддаленого зберігання стану:

```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-goithw-rybak"
    key            = "lesson-5/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
    profile        = "goithw"
  }
}
```

У файлі `main.tf` міститься закоментована конфігурація helm.

```
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

data "aws_eks_cluster" "eks" {
  name = module.eks.eks_cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.eks_cluster_name
}
```

Та модулі jenkins і ArgoCD

```
#Підключаємо модуль Jenkins
module "jenkins" {
  source       = "./modules/jenkins"
  cluster_name = module.eks.eks_cluster_name
  jenkins_admin_password = var.jenkins_admin_password
  github_username = var.github_username
  github_pat = var.github_pat
  github_url = var.github_url
  github_main_branch = var.github_main_branch
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url
  providers = {
    helm = helm
  }
}

#Підключаємо модуль Argo CD
module "argo_cd" {
  source       = "./modules/argo_cd"
  namespace    = "argocd"
  chart_version = "5.46.4"
  github_username = var.github_username
  github_pat = var.github_pat
  github_url = var.github_tf_url
  github_main_branch = var.github_tf_branch
}

```

Після створення EKS за допомогою модуля `eks`, розкоментуйте цю конфігурацію та виконайте:

```bash
terraform init -migrate-state
terraform apply
```

## Вивід проєкту

Після успішного застосування конфігурації, Terraform виведе наступну інформацію:

**S3 Backend:**

- `s3_bucket_name` - назва S3 бакета для зберігання стану
- `dynamodb_table_name` - назва таблиці DynamoDB для блокувань

**ECR:**

- `ecr_repository_url` - URL для роботи з ECR репозиторієм
- `ecr_repository_arn` - ARN ECR репозиторію
- `ecr_repository_name` - ім'я ECR репозиторію

**EKS:**

- `eks_cluster_endpoint` - API endpoint для підключення до кластера
- `eks_cluster_name` - назва EKS кластера
- `eks_node_role_arn` - ARN IAM-ролі для worker nodes

## Додаткові команди

### Перегляд поточного стану

```bash
terraform show
```

### Перегляд виходів

```bash
terraform output
```

### Форматування коду

```bash
terraform fmt
```

### Валідація конфігурації

```bash
terraform validate
```

## Робота з EKS та Kubernetes

### Налаштування kubectl для підключення до EKS

Після створення EKS кластера, налаштуйте kubectl для підключення:

```bash
aws eks update-kubeconfig --region us-east-1 --name eks-cluster-demo --profile goithw
```

### Перевірка статусу кластера

```bash
kubectl cluster-info
kubectl get nodes
```

### Перегляд розгорнутих ресурсів

```bash
# Переглянути деплойменти
kubectl get deployments

# Переглянути поди
kubectl get pods

# Переглянути сервіси
kubectl get services

# Переглянути HPA
kubectl get hpa
```

### Перегляд логів Django-додатку

```bash
# Отримати назву пода
kubectl get pods

# Переглянути логи
kubectl logs <pod-name>

# Переглянути логи в реальному часі
kubectl logs -f <pod-name>
```

### Робота з Helm

```bash
# Переглянути встановлені Helm релізи
helm list

# Оновити Helm чарт після змін
helm upgrade django-app ./charts/django-app

# Видалити Helm реліз
helm uninstall django-app
```

### Масштабування додатку вручну

```bash
# Змінити кількість реплік
kubectl scale deployment django-app --replicas=3

# Переглянути статус HPA
kubectl get hpa django-app
```

## Порядок розгортання проєкту

1. **Ініціалізація Terraform:**

   ```bash
   terraform init
   ```

2. **Перегляд та застосування змін:**

   ```bash
   terraform plan
   terraform apply
   ```

3. **Налаштування kubectl:**

   ```bash
   aws eks update-kubeconfig --region us-east-1 --name eks-cluster-demo --profile goithw
   ```

4. **Перевірка розгортання:**
   ```bash
   kubectl get all
   kubectl get hpa
   ```

## Очищення ресурсів

Для видалення всіх створених ресурсів:

```bash
terraform destroy
```
