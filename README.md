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

## 📚 Documentación

Los trabajos prácticos e informes del curso están dentro de la carpeta `/docs`.

## ✨ Autor

Pablo Gramajo
-📍 Diplomatura en Análisis de Datos — 2025
-💻 macOS + Docker + SQL Server
