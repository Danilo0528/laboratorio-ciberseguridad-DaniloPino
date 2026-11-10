#!/bin/sh
TARGET="https://servidor-web-dmz-dpino.onrender.com"

echo "=== SIMULACIÓN: GENERANDO TRÁFICO MASIVO HTTP ==="
echo "Objetivo: $TARGET"
echo "Enviando ráfaga de 30 peticiones HTTP simultáneas (DoS)..."
for i in $(seq 1 30); do
  curl -s -o /dev/null -w "Paquete #${i} enviado -> HTTP %{http_code} (%{time_total}s)\n" "$TARGET" &
done
wait

echo "=== PRUEBA FINALIZADA: 30 peticiones enviadas contra la DMZ ==="
python3 -m http.server 8080
