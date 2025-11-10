# 🧠 Diplomatura en Análisis de Datos

Esta  **Diplomatura**, brinda una base sólida en **análisis de datos**, enfocada en el uso práctico de herramientas como **SQL** y **Power BI**.

---

## 📦 Estructura del proyecto

``` Estructura del proyecto
diplomatura_en_analisis_de_datos/
│
├── docker-compose.yml          # Contenedor Docker con SQL Server
│
├── backups/                    # Archivos .bak (backups de la base de datos)
│   └── contosoDB.bak
│
├── data/                       # Archivos CSV originales (uno por tabla)
│   ├── customer.csv
│   ├── product.csv
│   └── sales.csv
│
├── sql/                        # Scripts SQL del proyecto
│   ├── create_tables/          # Scripts para crear tablas
│   ├── etl_scripts/            # Scripts ETL que cargan los CSV
│   ├── queries/                # Consultas y reportes de análisis
│   └── utils/                  # Funciones o procedimientos opcionales
│
├── docs/                       # Documentación y entregas del curso
│   ├── TP1_Transformaciones.txt
│   ├── TP2_Modelo_ER.pdf
│   └── notas.txt
│
└── README.md                   # Este archivo
```

---

## 🐳 Configuración con Docker

El contenedor de SQL Server se levanta con el archivo `docker-compose.yml`.

### 1️⃣ Levantar el contenedor

```bash
docker-compose up -d
```

Esto creará y ejecutará una instancia de **SQL Server** en tu máquina.

Podés conectarte desde **Azure Data Studio**, **DBeaver** o **SQL Server Management Studio** con los siguientes datos:

| Parámetro  | Valor |
|-------------|--------|
| **Servidor** | `localhost,1433` |
| **Usuario**  | `sa` |
| **Contraseña** | (la definida en tu `.env`) |

### Variables de entorno

Para no dejar credenciales en `docker-compose.yml`, se utiliza un archivo `.env`. Copiá el ejemplo y editá la contraseña segura:

```bash
cp .env.example .env
# editar .env y cambiar MSSQL_SA_PASSWORD
```

No subas tu `.env` al repo (ya está en `.gitignore`).

### Ejecutar el ETL automáticamente

He añadido un script `run_etl.sh` en la raíz que ejecuta, en orden, los SQL de `sql/create_tables` y `sql/etl_scripts` dentro del contenedor. Pasos rápidos:

1. Copiá y editá `.env` como se indicó.
2. Levantá el contenedor:

```bash
docker-compose up -d
```

3. Hacé ejecutable el script y ejecutalo:

```bash
chmod +x run_etl.sh
./run_etl.sh
```

El script usa `sqlcmd` dentro del contenedor. Si preferís ejecutar archivos manualmente con `docker exec`, un ejemplo de comando es:

```bash
docker exec -i azuresqledge /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P "${MSSQL_SA_PASSWORD}" -i /dev/stdin < sql/create_tables/01_DimCurrencyExchange.sql
```


## 📚 Documentación

Los trabajos prácticos e informes del curso están dentro de la carpeta `/docs`.

## ✨ Autor

Pablo Gramajo
-📍 Diplomatura en Análisis de Datos — 2025
-💻 macOS + Docker + SQL Server
