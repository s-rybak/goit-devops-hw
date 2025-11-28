# DevOps Final Project - Terraform Infrastructure з VPC, EKS, RDS, ECR, Jenkins, Argo CD, Prometheus, Grafana

Цей проєкт демонструє інфраструктуру AWS, розгорнуту за допомогою Terraform з використанням модульної архітектури. Включає створення Kubernetes кластера (EKS), Jenkins для CI/CD, ArgoCD для GitOps, моніторинг через Prometheus та візуалізацію в Grafana, а також автоматичне розгортання Django-додатку.

## Структура проєкту

```
Project/
│
├── main.tf                  # Головний файл для підключення модулів
├── backend.tf               # Налаштування бекенду для стейтів (S3 + DynamoDB)
├── variables.tf             # Змінні проєкту
├── terraform.tfvars         # Значення змінних (створюється з .example)
├── terraform.tfvars.example # Приклад файлу зі змінними
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
│   │   └── outputs.tf       # Виведення інформації про VPC
│   │
│   ├── ecr/                 # Модуль для ECR
│   │   ├── ecr.tf           # Створення ECR репозиторію
│   │   ├── variables.tf     # Змінні для ECR
│   │   └── outputs.tf       # Виведення URL репозиторію
│   │
│   ├── eks/                 # Модуль для Kubernetes кластера
│   │   ├── eks.tf           # Створення кластера
│   │   ├── node.tf          # Налаштування worker nodes
│   │   ├── aws_ebs_csi_driver.tf  # EBS CSI драйвер
│   │   ├── variables.tf     # Змінні для EKS
│   │   └── outputs.tf       # Виведення інформації про кластер
│   │
│   ├── rds/                 # Модуль для RDS/Aurora баз даних
│   │   ├── rds.tf           # RDS інстанс
│   │   ├── aurora.tf        # Aurora кластер (writer + readers)
│   │   ├── shared.tf        # Спільні ресурси (subnet group, security group)
│   │   ├── variables.tf     # Змінні для RDS/Aurora
│   │   └── outputs.tf       # Виведення інформації про RDS
│   │
│   ├── jenkins/             # Модуль для Jenkins
│   │   ├── jenkins.tf       # Розгортання Jenkins через Helm
│   │   ├── values.yaml      # Налаштування Jenkins
│   │   ├── variables.tf     # Змінні для Jenkins
│   │   ├── outputs.tf       # Виведення інформації про Jenkins
│   │   └── providers.tf     # Провайдери для Jenkins
│   │
│   ├── argo_cd/             # Модуль для ArgoCD
│   │   ├── argo_cd.tf       # Розгортання ArgoCD через Helm
│   │   ├── values.yaml      # Налаштування ArgoCD
│   │   ├── variables.tf     # Змінні для ArgoCD
│   │   ├── outputs.tf       # Виведення інформації про ArgoCD
│   │   ├── providers.tf     # Провайдери для ArgoCD
│   │   └── charts/          # Helm чарт для ArgoCD Application
│   │       ├── Chart.yaml
│   │       ├── values.yaml
│   │       └── templates/
│   │           ├── application.yaml
│   │           └── repository.yaml
│   │
│   ├── prometheus/          # Модуль для Prometheus
│   │   ├── prometheus.tf    # Розгортання Prometheus через Helm
│   │   ├── values.yaml      # Налаштування Prometheus
│   │   ├── variables.tf     # Змінні для Prometheus
│   │   ├── outputs.tf       # Виведення інформації про Prometheus
│   │   └── providers.tf     # Провайдери для Prometheus
│   │
│   └── grafana/             # Модуль для Grafana
│       ├── grafana.tf       # Розгортання Grafana через Helm
│       ├── values.yaml      # Налаштування Grafana
│       ├── variables.tf     # Змінні для Grafana
│       ├── outputs.tf       # Виведення інформації про Grafana
│       └── providers.tf     # Провайдери для Grafana
│
├── charts/
│   └── django-app/          # Helm чарт для Django додатку
│       ├── templates/
│       │   ├── deployment.yaml
│       │   ├── service.yaml
│       │   ├── configmap.yaml
│       │   └── hpa.yaml
│       ├── Chart.yaml
│       └── values.yaml
│
└── Django/                  # Django додаток
    ├── app/                 # Вихідний код Django проекту
    ├── Dockerfile           # Dockerfile для збірки образу
    ├── Jenkinsfile          # CI/CD pipeline для Jenkins
    ├── docker-compose.yaml  # Для локального розгортання
    └── nginx/
        └── default.conf     # Конфігурація Nginx для проксування на локальному серидовищі
```

## Передумови

Перед початком роботи переконайтесь, що у вас встановлено:

- Terraform >= 1.0
- AWS CLI налаштований з профілем `goithw`
- kubectl
- helm

## Налаштування змінних

Перед розгортанням інфраструктури необхідно створити файл зі змінними:

1. Скопіюйте файл `terraform.tfvars.example` в `terraform.tfvars`:

```bash
cp terraform.tfvars.example terraform.tfvars
```

2. Відредагуйте `terraform.tfvars` і вкажіть свої значення:

```hcl
# Jenkins
jenkins_admin_password = "your-secure-password"

# GitHub
github_username        = "your-github-username"
github_pat             = "github_pat_xxxxxxxxxxxxx"  # GitHub Personal Access Token
github_url             = "https://github.com/your-username/your-app-repo"
github_tf_url          = "https://github.com/your-username/your-infra-repo"
github_tf_branch       = "main"
github_main_branch     = "main"
helm_chart_path        = "Project/charts/django-app"

# Grafana
grafana_admin_password = "your-grafana-password"

# RDS PostgreSQL
rds_db_password        = "your-db-password"
rds_db_user            = "postgres"
rds_db_name            = "myapp"
```

**Важливо:** GitHub Personal Access Token потрібен для доступу Jenkins та ArgoCD до репозиторіїв. Створіть токен з правами доступу до потрібних репозиторіїв з правами потрібними для коміту

## Команди для роботи з проєктом

### Ініціалізація Terraform

Після налаштування змінних, ініціалізуйте Terraform:

```bash
terraform init
```

Ця команда:

- Завантажує провайдери AWS, Helm та Kubernetes
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

---

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

### 5. Модуль `rds`

**Призначення:** Створення бази даних в AWS RDS: RDS інстанс або Aurora кластер (PostgreSQL).

**Що створює:**

- **RDS інстанс** (`aws_db_instance.standard`) – одноінстансна БД у вибраному engine (PostgreSQL за замовчуванням).
- **Aurora кластер** (`aws_rds_cluster.aurora`, `aws_rds_cluster_instance.*`) – кластер з одним writer та декількома read-only replica.
- **DB Subnet Group** (`aws_db_subnet_group.default`) – група приватних або публічних підмереж для розміщення БД.
- **Security Group** (`aws_security_group.rds`) – мережеві правила доступу до БД.

**Вхідні параметри (змінні модуля):**

- **`name`** – базова назва для інстансу/кластера.
- **`use_aurora`** – якщо `true`, створюється Aurora кластер; якщо `false`, RDS інстанс.
- **`engine`** – engine для стандартного RDS (використовується тільки при `use_aurora = false`).
- **`engine_version`** – версія engine для стандартного RDS (наприклад, `"14.7"`, `"17.2"`).
- **`engine_cluster`** – engine для Aurora кластера (використовується тільки при `use_aurora = true`).
- **`engine_version_cluster`** – версія engine для Aurora кластера.
- **`parameter_group_family_rds`** – тип параметр-групи, який має відповідати версії бази для rds.
- **`parameter_group_family_aurora`** – тип параметр-групи, який має відповідати версії бази для Aurora.
- **`aurora_replica_count`** – кількість read-only реплік Aurora.
- **`instance_class`** – клас інстансу для RDS/Aurora (наприклад, `"db.t3.small"`, `"db.r6g.large"`).
- **`allocated_storage`** – розмір диску в GiB для стандартного RDS (на Aurora не впливає).
- **`db_name`** – назва бази даних, яка буде створена.
- **`username`** – ім'я master-користувача БД.
- **`password`** – пароль master-користувача.
- **`vpc_id`** – ID VPC, в якій створюється security group.
- **`subnet_private_ids`** – ID приватних підмереж для розміщення БД.
- **`subnet_public_ids`** – ID публічних підмереж, якщо БД має бути публічно доступною.
- **`publicly_accessible`** – якщо `true`, інстанси/кластер будуть доступні з інтернету.
- **`multi_az`** – ввімкнення Multi-AZ для стандартного RDS.
- **`backup_retention_period`** – кількість днів зберігання автоматичних бекапів (наприклад, `"7"`).
- **`parameters`** – додаткові параметри БД для parameter group.
- **`tags`** – додаткові AWS теги, які застосовуються до всіх ресурсів модуля.

**Вивід:**

- **`db_endpoint`** – endpoint створеної БД (Aurora або RDS інстансу).
- **`db_security_group_id`** – ID security group, яка використовується для доступу до БД.
- **`db_host`** – hostname бази даних (без порту).
- **`db_port`** – порт бази даних.
- **`db_name`** – назва бази даних.
- **`db_username`** – username для підключення.
- **`db_password`** – password для підключення (sensitive).

**Автоматичне створення Kubernetes Secret:**

Після створення RDS, у `main.tf` автоматично створюється Kubernetes Secret `rds-credentials` з даними для підключення до бази, для безпечного збереження і використання сенситив данних в додатку.

**Приклад використання модуля:**

```hcl
module "rds" {
  source = "./modules/rds"

  name                       = "myapp-db"
  use_aurora                 = false  # true -> Aurora кластер, false -> стандартний RDS

  # --- Aurora-only ---
  engine_cluster             = "aurora-postgresql"
  engine_version_cluster     = "15.3"
  parameter_group_family_aurora = "aurora-postgresql15"
  aurora_replica_count       = 2

  # --- RDS-only ---
  engine                     = "postgres"
  engine_version             = "17.2"
  parameter_group_family_rds = "postgres17"

  # Common
  instance_class             = "db.t3.medium"
  allocated_storage          = 20
  db_name                    = "myapp"
  username                   = "postgres"
  password                   = "admin123AWS23"
  subnet_private_ids         = module.vpc.private_subnets
  subnet_public_ids          = module.vpc.public_subnets
  publicly_accessible        = true
  vpc_id                     = module.vpc.vpc_id
  multi_az                   = true
  backup_retention_period    = 7
  parameters = {
    max_connections              = "200"
    log_min_duration_statement   = "500"
  }

  tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}
```

**Як змінити тип БД, engine та клас інстансу:**

- **Перехід між стандартним RDS та Aurora:**
  - Стандартний RDS: `use_aurora = false`, налаштовуєте `engine`, `engine_version`, `parameter_group_family_rds`.
  - Aurora кластер: `use_aurora = true`, налаштовуєте `engine_cluster`, `engine_version_cluster`, `parameter_group_family_aurora`, `aurora_replica_count` (кількість read-реплік).
- **Зміна engine / версії:**
  - Для стандартного RDS – змінюєте `engine` (наприклад, `"postgres"`, `"mysql"`) та `engine_version`, і підбираєте відповідний `parameter_group_family_rds`.
  - Для Aurora – змінюєте `engine_cluster` (наприклад, `"aurora-postgresql"`, `"aurora-mysql"`) та `engine_version_cluster`, і відповідно `parameter_group_family_aurora`.
- **Зміна класу інстансу:**
  - Оновлюєте `instance_class` (наприклад, `"db.t3.small"`, `"db.t3.large"`, `"db.r6g.large"`); ця змінна застосовується і до стандартного RDS, і до інстансів Aurora.
- **Налаштування доступності та мережі:**
  - `multi_az = true` для високої доступності стандартного RDS.
  - `publicly_accessible` разом з вибором `subnet_private_ids`/`subnet_public_ids` визначають, чи буде БД доступна з інтернету.
  - За потреби порт і дозволені CIDR для доступу можна змінити в ресурсі `aws_security_group.rds` (за замовчуванням відкритий порт 5432 TCP для всіх `0.0.0.0/0`).

---

### 6. Модуль `jenkins`

**Призначення:** Розгортання Jenkins в EKS кластері для CI/CD пайплайнів.

**Що створює:**

- **Kubernetes Namespace** - окремий namespace `jenkins` для ізоляції
- **Storage Class** - EBS Storage Class для persistent storage
- **IAM Role** - роль для ServiceAccount з доступом до ECR
- **Kubernetes ServiceAccount** - сервісний акаунт з анотацією IAM ролі
- **Helm Release** - розгортання Jenkins через офіційний Helm chart

**Вхідні параметри:**

- `cluster_name` - назва EKS кластера
- `jenkins_admin_password` - пароль адміністратора Jenkins (якщо поточна версія jenkins дозволяє кастумний пароль, в іншому випадку буде згенеровано безпечний пароль, який можна дістати з сервіса кубернетіс)
- `github_username` - ім'я користувача GitHub
- `github_pat` - Personal Access Token для GitHub
- `github_url` - URL репозиторію з тестовим додатком
- `github_main_branch` - основна гілка репозиторію
- `oidc_provider_arn` - ARN OIDC провайдера EKS
- `oidc_provider_url` - URL OIDC провайдера EKS

**Вивід:**

- `jenkins_service_url` - URL для доступу до Jenkins UI
- `jenkins_admin_user` - ім'я адміністратора
- `jenkins_namespace` - namespace де розгорнуто Jenkins

**Навіщо потрібен:** Jenkins забезпечує автоматизацію CI/CD процесів - збірку, тестування та публікацію Docker образів в ECR.

**Тестовий проект:**
В цьому репозиторії знаходиться Django додаток та `Jenkinsfile` з описом пайплайну.

---

### 7. Модуль `argo_cd`

**Призначення:** Розгортання ArgoCD для GitOps-підходу в управлінні Kubernetes ресурсами.

**Що створює:**

- **ArgoCD Helm Release** - основний компонент ArgoCD
- **ArgoCD Application** - налаштування автоматичного розгортання Django додатку
- **Git Repository** - підключення до Git репозиторію з Helm чартами

**Вхідні параметри:**

- `namespace` - namespace для ArgoCD (за замовчуванням: argocd)
- `chart_version` - версія Helm чарту ArgoCD
- `github_username` - ім'я користувача GitHub
- `github_pat` - Personal Access Token для GitHub
- `github_url` - URL репозиторію з Helm чартами
- `github_main_branch` - гілка для відстеження
- `helm_chart_path` - шлях до Helm чарту в репозиторії

**Вивід:**

- `argocd_server_url` - URL для доступу до ArgoCD UI
- `argocd_admin_password` - пароль адміністратора ArgoCD
- `argocd_namespace` - namespace де розгорнуто ArgoCD

**Навіщо потрібен:** ArgoCD забезпечує декларативне управління Kubernetes ресурсами через Git репозиторій (GitOps), автоматично синхронізуючи стан кластера з репозиторієм.

---

### 8. Модуль `prometheus`

**Призначення:** Розгортання Prometheus для моніторингу та збору метрик з Kubernetes кластера.

**Що створює:**

- **Prometheus Server** - сервер для збору та зберігання метрик
- **Alertmanager** - компонент для управління алертами
- **Node Exporter** - збір метрик з worker nodes
- **Kube State Metrics** - метрики стану Kubernetes об'єктів

**Вхідні параметри:**

- `namespace` - namespace для Prometheus (за замовчуванням: prometheus)
- `chart_version` - версія Helm chart для Prometheus

**Вивід:**

- `prometheus_namespace` - namespace де розгорнуто Prometheus
- `prometheus_service_name` - ім'я сервісу Prometheus
- `prometheus_chart_version` - версія Helm chart
- `prometheus_server_url` - внутрішній URL для підключення Grafana

**Навіщо потрібен:** Prometheus забезпечує моніторинг всіх компонентів інфраструктури та додатків, збираючи метрики в реальному часі методом pull.

---

### 9. Модуль `grafana`

**Призначення:** Розгортання Grafana для візуалізації метрик та створення дашбордів.

**Що створює:**

- **Grafana** - розгортання Grafana через офіційний Helm chart
- **Data Source** - автоматичне підключення Prometheus як джерела даних
- **Service** - LoadBalancer сервіс для доступу до UI

**Вхідні параметри:**

- `namespace` - namespace для Grafana (за замовчуванням: grafana)
- `chart_version` - версія Helm chart для Grafana
- `grafana_admin_password` - пароль адміністратора Grafana
- `prometheus_url` - URL Prometheus сервера для data source

**Вивід:**

- `grafana_namespace` - namespace де розгорнуто Grafana
- `grafana_service_name` - ім'я сервісу Grafana
- `grafana_chart_version` - версія Helm chart

**Навіщо потрібен:** Grafana надає потужний інтерфейс для візуалізації метрик з Prometheus, створення кастомних дашбордів та налаштування алертів.

---

## Django Application

### Опис

Тестовий Django додаток для демонстрації роботи CI/CD:

- **app/** - вихідний код Django проекту
- **Dockerfile** - Конфігурація для створення Docker-image
- **Jenkinsfile** - Опис CI/CD pipeline для Jenkins
- **docker-compose.yaml** - Конфігурація для Docker compose
- **nginx/** - конфігурація Nginx для локального проксування додатку

### Jenkinsfile

Pipeline для автоматичної збірки та деплою Django додатку:

1. Збірка Docker-image та публікація його в ecr з тагом нової версії
2. Оновлення тегу версії Docker-image в values.yaml хельм чарту додатку

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

- `image.repository` - URL ECR репозиторію
- `image.tag` - тег Docker-образу (за замовчуванням: latest)
- `service.port` - порт сервісу (8000)
- `hpa.minReplicas` / `hpa.maxReplicas` - мінімальна/максимальна кількість реплік
- `config.*` - змінні оточення для Django

**Інтеграція з GitOps:**
ArgoCD автоматично розгортає цей Helm-чарт після синхронізації з Git репозиторієм, відстежуючи зміни у файлі `values.yaml`.

---

## Налаштування

У файлі `backend.tf` міститься закоментована конфігурація віддаленого бекенду. Після створення S3 бакета та DynamoDB таблиці за допомогою модуля `s3-backend`, розкоментуйте конфігурацію для використання віддаленого зберігання стану:

```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-goithw-rybak"
    key            = "Project/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
    profile        = "goithw"
  }
}
```

## Вивід проєкту

Після успішного застосування конфігурації, Terraform виведе наступну інформацію:

**S3 Backend:**

- `s3_bucket_name` - назва S3 бакета для зберігання стану
- `dynamodb_table_name` - назва таблиці DynamoDB для блокувань

**VPC:**

- `vpc_id` - ID створеної VPC
- `public_subnets` - список ID публічних підмереж
- `private_subnets` - список ID приватних підмереж

**ECR:**

- `ecr_repository_url` - URL для роботи з ECR репозиторієм
- `ecr_repository_arn` - ARN ECR репозиторію
- `ecr_repository_name` - ім'я ECR репозиторію

**EKS:**

- `eks_cluster_endpoint` - API endpoint для підключення до кластера
- `eks_cluster_name` - назва EKS кластера
- `eks_node_role_arn` - ARN IAM-ролі для worker nodes
- `oidc_provider_arn` - ARN OIDC провайдера
- `oidc_provider_url` - URL OIDC провайдера

**RDS:**

- `db_endpoint` - endpoint створеної бази даних (Aurora або стандартний RDS).
- `db_security_group_id` - ID security group, через яку відбувається доступ до БД.

**Jenkins:**

- `jenkins_service_url` - URL для доступу до Jenkins UI
- `jenkins_admin_user` - ім'я адміністратора (за замовчуванням: admin)
- `jenkins_namespace` - namespace Jenkins

**ArgoCD:**

- `argocd_server_url` - URL для доступу до ArgoCD UI
- `argocd_admin_password` - початковий пароль адміністратора
- `argocd_namespace` - namespace ArgoCD

**Prometheus:**

- `prometheus_namespace` - namespace Prometheus
- `prometheus_server_url` - URL Prometheus сервера

**Grafana:**

- `grafana_namespace` - namespace Grafana
- `grafana_service_name` - ім'я сервісу Grafana

---

---

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

---

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
# Переглянути всі namespace
kubectl get namespaces

# Переглянути деплойменти
kubectl get deployments -A

# Переглянути поди
kubectl get pods -A

# Переглянути сервіси
kubectl get services -A

# Переглянути HPA
kubectl get hpa -A
```

### Перегляд логів Django-додатку

```bash
# Отримати назву пода
kubectl get pods -n default

# Переглянути логи
kubectl logs <pod-name>

# Переглянути логи в реальному часі
kubectl logs -f <pod-name>
```

### Робота з Helm

```bash
# Переглянути встановлені Helm релізи (в усіх namespace)
helm list -A

# Переглянути релізи Jenkins
helm list -n jenkins

# Переглянути релізи ArgoCD
helm list -n argocd

# Переглянути релізи Prometheus
helm list -n prometheus

# Переглянути релізи Grafana
helm list -n grafana
```

### Масштабування додатку вручну

```bash
# Змінити кількість реплік
kubectl scale deployment django-app --replicas=3

# Переглянути статус HPA
kubectl get hpa django-app
```

---

## Робота з Jenkins

### Доступ до Jenkins UI

Після розгортання, отримайте URL Jenkins:

```bash
kubectl get svc -n jenkins
```

**Логін:**

- Username: `admin`
- Password: значення з `terraform.tfvars` (змінна `jenkins_admin_password`) Або, якщо версія не дозволяє кастумні пароль, можна дізнатись пароль виконавши наступну команду `kubectl get secret jenkins -n jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode`

### Налаштування Jenkins Pipeline

1. **Зайдіть в Jenkins UI**

2. **Апрувте скрипт в Jenkins Security:**

   - Перейдіть в `Manage Jenkins` → `In-process Script Approval`
   - Затвердіть скрипт, що очікує апруву (`seed-job`)

Після чого створиться пайплайн. Джоба під назвою `goit-django-docker`

### Перегляд логів Jenkins

```bash
# Логи Jenkins пода
kubectl logs -n jenkins -l app.kubernetes.io/component=jenkins-controller -f

# Переглянути всі поди в namespace jenkins
kubectl get pods -n jenkins
```

---

## Робота з ArgoCD

### Доступ до ArgoCD UI

Отримайте URL ArgoCD:

```bash
kubectl get svc -n argocd
```

**Логін:**

- Username: `admin`
- Password: отримайте з команди:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### Перегляд Applications в ArgoCD

```bash
# Переглянути всі ArgoCD додатки
kubectl get applications -n argocd

# Детальна інформація про додаток
kubectl describe application example-app -n argocd
```

### Синхронізація додатку

ArgoCD автоматично відстежує зміни в Git репозиторії та синхронізує стан кластера.

### Перегляд логів ArgoCD

```bash
# Логи ArgoCD сервера
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-server -f

# Логи Application Controller
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-application-controller -f
```

---

## Робота з Prometheus

### Доступ до Prometheus UI

Отримайте сервіс Prometheus:

```bash
kubectl get svc -n prometheus
```

### Перегляд метрик

```bash
# Переглянути всі поди Prometheus
kubectl get pods -n prometheus

# Переглянути логи Prometheus сервера
kubectl logs -n prometheus -l app.kubernetes.io/name=prometheus -f
```

---

## Робота з Grafana

### Доступ до Grafana UI

Отримайте сервіс Grafana:

```bash
kubectl get svc -n grafana
```

**Логін:**

- Username: `admin`
- Password: значення з `terraform.tfvars` (змінна `grafana_admin_password`)

### Перевірка Data Sources

Prometheus автоматично налаштований як data source. Перевірте в:
`Configuration` → `Data Sources` → `Prometheus`

### Дашборди

В проєкті налаштовані такі дашборди в сеції `default`:

- **kubernetes-cluster** (ID: 7249)
- **node-exporter** (ID: 1860)
- **pod-monitoring** (ID: 6417)

### Імпорт дашбордів

Якщо дашбордів не достатньо можна додати ще, для цього:

1. Перейдіть в `Dashboards` → `Import`
2. Введіть ID дашборду
3. Виберіть Prometheus як data source

### Перегляд логів Grafana

```bash
# Переглянути всі поди Grafana
kubectl get pods -n grafana

# Переглянути логи Grafana
kubectl logs -n grafana -l app.kubernetes.io/name=grafana -f
```

---

## Порядок розгортання проєкту

### Крок 1: Підготовка змінних

```bash
cd Project

# Скопіюйте файл з прикладом змінних
cp terraform.tfvars.example terraform.tfvars

# Відредагуйте terraform.tfvars та вкажіть ваші значення
```

### Крок 2: Ініціалізація та розгортання інфраструктури

```bash
# Ініціалізація Terraform
terraform init

# Перегляд змін
terraform plan

# Застосування змін (створення інфраструктури)
terraform apply
```

**Що буде створено:**

- VPC з підмережами
- ECR репозиторій
- EKS кластер з worker nodes

### Крок 3: Налаштування kubectl

```bash
# Налаштування kubectl для підключення до EKS
aws eks update-kubeconfig --region us-east-1 --name eks-cluster-demo --profile <profile>

# Перевірка підключення
kubectl cluster-info
kubectl get nodes
```

Розкоментуйте в `main.tf` блоки:

```bash
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

data "aws_eks_cluster" "eks" {
  name = module.eks.eks_cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.eks_cluster_name
}
```

та модулі `jenkins`, `argo_cd`, `rds`, `kubernetes_secret`, `prometheus`, `grafana`

```bash

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
  helm_chart_path = var.helm_chart_path
}

#Підключаємо модуль RDS
module "rds" {
  source = "./modules/rds"

  name                       = "myapp-db"
  use_aurora                 = false

  # --- Aurora-only ---
  engine_cluster             = "aurora-postgresql"
  engine_version_cluster     = "15.3"
  parameter_group_family_aurora = "aurora-postgresql15"
  aurora_replica_count       = 2

  # --- RDS-only ---
  engine                     = "postgres"
  engine_version             = "17.2"
  parameter_group_family_rds = "postgres17"

  # Common
  instance_class             = "db.t3.medium"
  allocated_storage          = 20
  db_name                    = var.rds_db_name
  username                   = var.rds_db_user
  password                   = var.rds_db_password
  subnet_private_ids         = module.vpc.private_subnets
  subnet_public_ids          = module.vpc.public_subnets
  publicly_accessible        = true
  vpc_id                     = module.vpc.vpc_id
  multi_az                   = true
  backup_retention_period    = 7
  parameters = {
    max_connections              = "200"
    log_min_duration_statement   = "500"
  }

  tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}

#Створюємо Kubernetes Secret з даними RDS
resource "kubernetes_secret" "rds_credentials" {
  metadata {
    name      = "rds-credentials"
    namespace = "default"
  }

  data = {
    POSTGRES_HOST     = module.rds.db_host
    POSTGRES_PORT     = tostring(module.rds.db_port)
    POSTGRES_DB       = module.rds.db_name
    POSTGRES_USER     = module.rds.db_username
    POSTGRES_PASSWORD = module.rds.db_password
  }

  type = "Opaque"

  depends_on = [module.eks, module.rds]
}

#Підключаємо модуль Prometheus
module "prometheus" {
  source        = "./modules/prometheus"
  namespace     = "prometheus"
  chart_version = "25.8.0"
  providers = {
    helm = helm
  }
}

#Підключаємо модуль Grafana
module "grafana" {
  source       = "./modules/grafana"
  namespace    = "grafana"
  chart_version = "7.0.0"
  grafana_admin_password = var.grafana_admin_password
  prometheus_url = module.prometheus.prometheus_server_url
  providers = {
    helm = helm
  }
  depends_on = [module.prometheus]
}
```

Модуль `rds` було закоментовано, для того щоб при створенні передати секрети в `kubernetes_secret` який, в свою чергу, залежить від `eks`, що має бути створений в першу чергу

### Крок 4: Ініціалізація та розгортання `jenkins` + `argo_cd` + `rds` + `kubernetes_secret` + `prometheus` + `grafana`

```bash
# Застосування змін
terraform apply
```

**Що буде створено:**

- RDS PostgreSQL база даних
- Kubernetes Secret з даними RDS
- Jenkins для CI/CD
- ArgoCD для GitOps
- Prometheus для моніторингу
- Grafana для візуалізації

Після чого можна починати користуватись інфраструктурою як описано вище. Для початку потрібно налаштувати `jenkins`

---

## Тестування CI/CD Pipeline

1. **Внесіть зміни в Django проект:**

   - Змініть код в `Project/Django/app/`
   - Зробіть commit і push змін

2. **Запустіть Jenkins Job:**

   - Jenkins побудує Docker образ
   - Завантажить образ в ECR
   - Оновить тег в Git репозиторії з Helm чартом

3. **ArgoCD автоматично синхронізує:**

   - ArgoCD виявить зміни в Git репозиторії
   - Автоматично оновить Django додаток в кластері

### Повний цикл CI/CD

```
1. Developer → Push code to GitHub (Project/Django/)
2. Jenkins → Build Docker image → Push to ECR
3. Jenkins → Update Helm chart values in Git
4. ArgoCD → Detect changes → Deploy to EKS
5. Kubernetes → Running Django application
6. Prometheus → Collect metrics
7. Grafana → Visualize metrics
```

---

## Очищення ресурсів

Для видалення всіх створених ресурсів:

```bash
terraform destroy
```
