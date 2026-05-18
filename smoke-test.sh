#!/bin/bash
IP="69.6.212.151"
DOMAIN="colegiovillaprime.com.br"
echo "=== SMOKE TEST — $DOMAIN via $IP ==="
echo ""
echo "--- Páginas ---"
for route in "/" "/contato/" "/estrutura/" "/matriculas/" "/politica-de-privacidade/" "/proposta-pedagogica/" "/seguranca/" "/tecnologia/" "/turmas/"; do
  code=$(curl -so /dev/null -w "%{http_code}" -m 10 --resolve "${DOMAIN}:80:${IP}" "http://${DOMAIN}${route}" 2>/dev/null)
  if [ "$code" = "200" ]; then
    echo "  ✅ $code $route"
  else
    echo "  ❌ $code $route"
  fi
done
echo ""
echo "--- Arquivos técnicos ---"
for file in "/robots.txt" "/sitemap-index.xml" "/sitemap-0.xml" "/.htaccess" "/favicon.ico" "/og-image.jpg"; do
  code=$(curl -so /dev/null -w "%{http_code}" -m 10 --resolve "${DOMAIN}:80:${IP}" "http://${DOMAIN}${file}" 2>/dev/null)
  if [ "$code" = "200" ]; then
    echo "  ✅ $code $file"
  else
    echo "  ❌ $code $file"
  fi
done
echo ""
echo "=== DONE ==="
