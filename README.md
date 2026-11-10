# laboratorio-ciberseguridad-DaniloPino

Laboratorio modular defensivo/ofensivo de la Unidad 2 — *Seguridad en redes y aplicaciones web*.
Desplegado en **Render** (Runtime Docker) y sincronizado con **GitHub**.

**Estudiante:** Danilo Pino (dpino)

## Módulos

| Carpeta | Servicio en Render | URL pública |
|---|---|---|
| `00-servidor-dmz` | servidor-web-dmz-dpino | https://servidor-web-dmz-dpino.onrender.com |
| `01-ataque-dos` | modulo-01-dos-dpino | https://modulo-01-dos-dpino.onrender.com |
| `02-escaneo-puertos` | modulo-02-escaneo-dpino | https://modulo-02-escaneo-dpino.onrender.com |
| `03-fuerza-bruta-rutas` | modulo-03-fuerzabruta-dpino | https://modulo-03-fuerzabruta-dpino.onrender.com |
| `04-exfiltracion-dns` | modulo-04-exfiltracion-dpino | https://modulo-04-exfiltracion-dpino.onrender.com |
| `05-cadena-suministro` | modulo-05-cadena-dpino | https://modulo-05-cadena-dpino.onrender.com |
| `06-credential-stuffing` | modulo-06-stuffing-dpino | https://modulo-06-stuffing-dpino.onrender.com |
| `07-proxy-mitm` | modulo-07-mitm-dpino | https://modulo-07-mitm-dpino.onrender.com |

## Cómo funciona

- **00 (DMZ):** servidor web víctima. Es el objetivo de todos los demás módulos y muestra el
  mensaje personalizado *"Servidor DMZ Activo - Laboratorio de Danilo Pino"*.
- **01 – 06:** scripts de ataque que se ejecutan **una sola vez al arrancar el contenedor**
  (ráfaga HTTP, escaneo de puertos, enumeración de rutas, exfiltración DNS, dependencia
  maliciosa, credential stuffing) y después mantienen vivo un servidor Python para que Render
  no suspenda el servicio. La evidencia del ataque queda en la pestaña **Logs** de Render.
- **07:** proxy Flask que intercepta, reenvía a la DMZ y **inyecta** un comentario HTML en la
  respuesta (ataque man-in-the-middle).

## Evidencias

- Video de la demostración en vivo (máx. 7 minutos).
- Documento PDF con los logs de Render de cada ejecución.
